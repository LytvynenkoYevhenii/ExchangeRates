//
//  ServerManager.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELServerManager.h"
#import "Reachability.h"
#import "ELParser.h"
#import "ELCalculator.h"

#import "ELCurrency+CoreDataProperties.h"

@implementation ELServerManager

static NSString * const privatBankArchiveApiBaseURL = @"https://api.privatbank.ua/p24api/exchange_rates?json&date=";
static NSString * const privatBankTodayApiURL       = @"https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=4";
static NSString * const nbuApiURL                   = @"https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?";

#pragma mark - Initialization

+ (ELServerManager *)sharedManager
{
    static ELServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ELServerManager alloc] init];
    });
    return manager;
}

#pragma mark - Connection

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

#pragma mark - GET methods

- (void) getCurrenciesWithDate:(NSDate *)date
                      bankType:(ELBankType)bankType
                     inSuccess:(void (^)(NSArray<ELCurrency *> *currencies))successBlock
                     inFailure:(void (^)(NSError *error, NSInteger statusCode))failureBlock
{
    //Get from server and parse the Currencies with date in default context
    ELApiType apiType = [self apiTypeForBankType:bankType withDate:date];
    NSURL *apiURL = [self apiURLWithApiType:apiType withDate:date];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            NSArray *currencies = [[ELParser sharedInstance] parseCurrenciesFromAPIWithType:apiType responseData:data inContext:[NSManagedObjectContext MR_defaultContext]];
            if (successBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(currencies);
                });
            }
        } else {
            if (failureBlock) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(error, httpResponse.statusCode);
                });
            }
        }
    }];

    [dataTask resume];
}

#pragma mark - LOAD methods

- (void) loadCurrenciesWithDate:(NSDate *)date apiType:(ELApiType)apiType inContext:(NSManagedObjectContext *)context completionBlock:(void(^)(BOOL success, NSError *error, NSInteger statusCode))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [self apiURLWithApiType:apiType withDate:date];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (completion) {
            
            if (data) {
                
                //Parse data to currencies and save to data base on private queue
                [[ELParser sharedInstance] parseCurrenciesFromAPIWithType:apiType responseData:data inContext:context];
                
                if (completion) {
                    completion(YES, nil, 0);
                }
                
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                completion(NO, error, httpResponse.statusCode);
            }
        }
    }];
    [task resume];
}

- (void) loadCurrenciesFromDate:(NSDate *)fromDate
                         toDate:(NSDate *)toDate
                       bankType:(ELBankType)bankType
                     completion:(void(^)(BOOL succes, NSError *error, NSInteger statusCode))completionBlock
{
    //If date is fail - it will be corrected
    
    NSDate *minDate = [ELCalculator minDateForCurrenciesArchive];
    if ([fromDate compare:minDate] == NSOrderedAscending) {
        fromDate = minDate;
    }
    
    NSDate *maxDate = [ELCalculator maxDateForCurrenciesArchive];
    if ([toDate compare:maxDate] == NSOrderedDescending) {
        toDate = maxDate;
    }
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    
    NSDate *currentDate = [fromDate copy];
    
    __block NSInteger blockCallNumber = 0;

    NSManagedObjectContext *contextForSaving = [NSManagedObjectContext MR_rootSavingContext];
    
    NSDate *start = [NSDate dateWithTimeIntervalSinceNow:0];
    
    for (int i = 0; i < components.day; i++) {
        
        ELApiType apiType = [self apiTypeForBankType:bankType withDate:toDate];
        currentDate = [ELCalculator dateByAddingYears:0 months:0 days:1 toDate:currentDate];
        
        [self loadCurrenciesWithDate:currentDate apiType:apiType inContext:contextForSaving completionBlock:^(BOOL success, NSError *error, NSInteger statusCode) {
            
            blockCallNumber++;
            
            //Create notification for loading process
            
            if (success) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = @{ELServerManagerCurrencyDateUserInfoKey : currentDate,
                                               ELServerManagerStartDateUserInfoKey : fromDate,
                                               ELServerManagerEndDateUserInfoKey : toDate,
                                               ELServerManagerCurrencyBankNameInfoKey : ELPrivatBankFullName};
                    
                    NSNotification *loadNotification = [NSNotification notificationWithName:ELServerManagerCurrenciesDidLoadNotification object:nil userInfo:userInfo];
                    [[NSNotificationCenter defaultCenter] postNotification:loadNotification];
                });
            }
            
            if (blockCallNumber == components.day) {
                
                //Last calling of the block
                if (completionBlock) {

                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError *error = nil;
                        
                        if (![contextForSaving save:&error]) {
                            completionBlock(NO, error, CONTEXT_SAVING_ERROR_STATUS_CODE);
                        } else {
                            completionBlock(YES, nil, 0);
                            NSDate *finish = [NSDate dateWithTimeIntervalSinceNow:0];
                            NSInteger timeInterval = [finish timeIntervalSinceDate:start];
                            NSLog(@"TIME INTERVAL = %d", timeInterval);
                        }
                    });
                }
            }
        }];
    }
}

#pragma mark - Private methods

- (NSURL *)apiURLWithApiType:(ELApiType)apiType withDate:(NSDate *)date
{
    NSURL *result = nil;
    
    switch (apiType) {
        case ELApiTypePrivatBankArchive:
            result = [self privatBankArchiveApiURLWithDate:date];
            break;
            
        case ELApiTypePrivatBankToday:
            result = [NSURL URLWithString:privatBankTodayApiURL];
            break;
            
        case ELApiTypeNBU:
            result = [self nbuApiURLWithDate:date];
            break;
        default:
            break;
    }
    
    return result;
}

- (NSURL *)privatBankArchiveApiURLWithDate:(NSDate *)date
{
    NSString    *formattedDate  = [[ELUtils standardFormatter] stringFromDate:date];
    NSString    *urlString      = [privatBankArchiveApiBaseURL stringByAppendingString:formattedDate];
    NSURL       *url            = [NSURL URLWithString:urlString];
    
    return url;
}

- (NSURL *)nbuApiURLWithDate:(NSDate *)date
{
    //Date format YYYYMMDD
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ELNbuApiDateFormat];
    
    NSString    *formattedDate  = [formatter stringFromDate:date];
    NSString    *parameters     = [NSString stringWithFormat:@"date=%@&json", formattedDate];
    NSString    *urlString      = [nbuApiURL stringByAppendingString:parameters];
    NSURL       *url            = [NSURL URLWithString:urlString];

    return url;
}

- (ELApiType)apiTypeForBankType:(ELBankType)bankType withDate:(NSDate *)date
{
    ELApiType apiType = 0;
    
    switch (bankType) {
        case ELBankTypePrivatBank:
            if ([date isEqualToDate:[ELCalculator maxDateForCurrenciesArchive]]) {
                apiType = ELApiTypePrivatBankToday;
            } else {
                apiType = ELApiTypePrivatBankArchive;
            }
            break;
            
        case ELBankTypeNBU:
            apiType = ELApiTypeNBU;
            
            break;

        default:
            break;
    }
    
    return apiType;
}

- (void)showInLogsStateOfAllTasks
{
    [[NSURLSession sharedSession] getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for (NSURLSessionDataTask *task in tasks) {
            switch (task.state) {
                case NSURLSessionTaskStateRunning:
                    NSLog(@"\n TASK URL: %@ \n State : running ", task.currentRequest.URL);
                    break;
                case NSURLSessionTaskStateCanceling:
                    NSLog(@"\n TASK URL: %@ \n State : canceling ", task.currentRequest.URL);
                    break;
                case NSURLSessionTaskStateCompleted:
                    NSLog(@"\n TASK URL: %@ \n State : completed ", task.currentRequest.URL);
                    break;
                case NSURLSessionTaskStateSuspended:
                    NSLog(@"\n TASK URL: %@ \n State : suspended ", task.currentRequest.URL);
                    break;
                    
                default:
                    break;
            }
        }
    }];
}

@end
