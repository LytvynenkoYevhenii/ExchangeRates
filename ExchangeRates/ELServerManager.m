//
//  ServerManager.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELServerManager.h"
#import "Reachability.h"

#import "ELCurrency+CoreDataProperties.h"

@interface ELServerManager()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation ELServerManager

static NSString * const privatBankArchiveApiBaseURL = @"https://api.privatbank.ua/p24api/";

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

#pragma mark - Custom Accessor

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"dd.MM.yyyy"];
    }
    return _dateFormatter;
}

#pragma mark - Public methods

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void) getCurrenciesWithDate:(NSDate *)date
                     inSuccess:(void (^)(NSArray<ELCurrency *> *))success
                     inFailure:(void (^)(NSError *, NSInteger))failure
{
    if ([date isEqual:[NSDate date]]) { //if today - use todayAPI
        
    } else { //use archive API
        [self getCurrenciesFromPrivateArchiveAPIWithDate:date inSuccess:success inFailure:failure];
    }
}

- (void) asyncCreateNewCurrenciesFromPrivatArchiveAPIWithResponseData:(NSData *)data withCompletion:(void(^)(BOOL success, NSError *error))completion
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [self createNewCurrenciesFromPrivatArchiveAPIWithResponseData:data inContext:localContext];
    } completion:completion];
}

- (void) syncCreateNewCurrenciesFromPrivatArchiveAPIWithResponseData:(NSData *)data
{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        [self createNewCurrenciesFromPrivatArchiveAPIWithResponseData:data inContext:localContext];
    }];
}

#pragma mark - Request methods

- (void) getCurrenciesFromPrivateArchiveAPIWithDate:(NSDate *)date
                                         inSuccess:(void(^)(NSArray <ELCurrency *>* currencies))success
                                         inFailure:(void(^)(NSError *error, NSInteger statusCode))failure
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *privatBankApiURL = [self privatBankArchiveApiURLWithDate:date];
    
    __block NSArray *currenciesResultArray = nil;
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:privatBankApiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            [self asyncCreateNewCurrenciesFromPrivatArchiveAPIWithResponseData:data withCompletion:^(BOOL success, NSError *error) {
                if (success) {
                    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date == %@", date];
                    currenciesResultArray = [ELCurrency MR_findAllWithPredicate:datePredicate];
                } else if (error && failure) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    failure(error, httpResponse.statusCode);
                }
            }];
        }
    }];

    [task resume];
}

#pragma mark - Private methods

- (NSURL *)privatBankArchiveApiURLWithDate:(NSDate *)date
{
    NSString    *formattedDate  = [self.dateFormatter stringFromDate:date];
    NSString    *parameters     = [NSString stringWithFormat:@"exchange_rates?json&date=%@", formattedDate];
    NSString    *urlString      = [privatBankArchiveApiBaseURL stringByAppendingString:parameters];
    NSURL       *url            = [NSURL URLWithString:urlString];
    
    return url;
}

- (void)createNewCurrenciesFromPrivatArchiveAPIWithResponseData:(NSData *)data inContext:(NSManagedObjectContext *)context
{
    if (!context || !data) {
        return;
    }
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *dateString = [responseDict objectForKey:@"date"];
    NSDate *currencyDate = [self.dateFormatter dateFromString:dateString];
    
    NSArray *exchangeRates = [responseDict objectForKey:@"exchangeRate"];
    
    for (NSDictionary *currencyDict in exchangeRates) {
        
        if ([currencyDict objectForKey:@"purchaseRate"]) {
            //Create PB currency
            ELCurrency *pbCurrency = [ELCurrency MR_createEntityInContext:context];
            pbCurrency.bankName = @"PrivatBank";
            pbCurrency.code = [currencyDict objectForKey:@"currency"];
            pbCurrency.purchaseRate = [[currencyDict objectForKey:@"purchaseRate"] floatValue];
            pbCurrency.saleRate = [[currencyDict objectForKey:@"saleRate"] floatValue];
            pbCurrency.date = currencyDate;
        }
        
        if ([currencyDict objectForKey:@"purchaseRateNB"]) {
            //Create NBU currency
            ELCurrency *nbuCurrency = [ELCurrency MR_createEntityInContext:context];
            nbuCurrency.bankName = @"National Bank";
            nbuCurrency.code = [currencyDict objectForKey:@"currency"];
            nbuCurrency.purchaseRate = [[currencyDict objectForKey:@"purchaseRateNB"] floatValue];
            nbuCurrency.saleRate = [[currencyDict objectForKey:@"saleRateNB"] floatValue];
            nbuCurrency.date = currencyDate;
        }
    }
}

@end
