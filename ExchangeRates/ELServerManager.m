//
//  ServerManager.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELServerManager.h"
#import "ELCurrency+CoreDataProperties.h"

@interface ELServerManager()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation ELServerManager

static NSString * const privatBankApiBaseURL = @"https://api.privatbank.ua/p24api/";

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

#pragma mark - Request methods

- (NSArray <ELCurrency *>*)getCurrenciesWithDate:(NSDate *)date
{
    date = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 30 * 2];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURL *privatBankApiURL = [self privatBankApiURLWithDate:date];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:privatBankApiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"responseDict=%@",responseDict);
        
        [self createNewCurrenciesFromResponseDictionary:responseDict];
    }];
    
    [task resume];
    
    return nil;
}

#pragma mark - Private methods

- (NSURL *)privatBankApiURLWithDate:(NSDate *)date
{
    NSString *formattedDate = [self.dateFormatter stringFromDate:date];
    
    NSString *parameters = [NSString stringWithFormat:@"exchange_rates?json&date=%@", formattedDate];
    NSString *urlString = [privatBankApiBaseURL stringByAppendingString:parameters];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

- (void) createNewCurrenciesFromResponseDictionary:(NSDictionary *)dictionary
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NSString *dateString = [dictionary objectForKey:@"date"];
        NSDate *currencyDate = [self.dateFormatter dateFromString:dateString];
        
        NSArray *exchangeRates = [dictionary objectForKey:@"exchangeRate"];
        
        NSArray *bankNames = @[@"PrivatBank", @"National Bank"];
        
        for (NSString *bankName in bankNames) {
            
            for (NSDictionary *currencyDict in exchangeRates) {
            
                ELCurrency *newCurrency = [ELCurrency MR_createEntityInContext:localContext];
                newCurrency.date = currencyDate;
                
                NSString *purchaseRateKey = @"purchaseRate";
                NSString *saleRateKey = @"saleRate";
                
                if ([bankName isEqualToString:@"National Bank"]) {
                    purchaseRateKey = @"purchaseRateNB";
                    saleRateKey = @"saleRateNB";
                }
                newCurrency.purchaseRate = [[currencyDict objectForKey:purchaseRateKey] floatValue];
                newCurrency.saleRate = [[currencyDict objectForKey:saleRateKey] floatValue];
                newCurrency.code = [currencyDict objectForKey:@"currency"];
            }
        }
    }];
}

@end
