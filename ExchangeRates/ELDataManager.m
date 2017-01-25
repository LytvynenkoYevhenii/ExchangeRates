//
//  ELDataManager.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 16.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELDataManager.h"
#import "ELServerManager.h"
#import "ELCalculator.h"

#import "ELCurrency+CoreDataProperties.h"


@implementation ELDataManager

+ (ELDataManager *)sharedManager
{
    static ELDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ELDataManager alloc] init];
    });
    return manager;
}

- (void)currenciesWithDate:(NSDate *)date
                  bankType:(ELBankType)bankType
                   success:(void(^)(NSArray* currencies))success
                   failure:(void(^)(NSError *error, NSInteger statusCode))failure;

{
    //Try get data from data base
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSArray *result = [ELCurrency MR_findAllWithPredicate:datePredicate];
    
    if ([result count]) {
        success(result);
        return;
    }

    //Check for connection before sending the URL request
    if ([[ELServerManager sharedManager] connected]) {
       
        // 1. Get json from server -> parse to Currencies in default context (for date) and return result array
        [[ELServerManager sharedManager] getCurrenciesWithDate:date bankType:bankType inSuccess:success inFailure:failure];
        
        // 2. Get jsons from server with 1 year , parse to Currencies in private context (async) and save this context
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear fromDate:date];
        components.day = 1;
        components.month = 1;
        
        NSDate *startDate = [gregorianCalendar dateFromComponents:components];
        
        [components setYear:components.year + 1];
        
        
        NSDate *endDate = [gregorianCalendar dateFromComponents:components];
        
        endDate = [ELCalculator dateByAddingYears:0 months:0 days:-1 toDate:endDate];
        
        [[ELServerManager sharedManager] loadCurrenciesFromDate:startDate toDate:endDate bankType:bankType completion:^(BOOL succes, NSError *error, NSInteger statusCode) {
        
        }];
        
    } else if (failure) {
        
        //In non connected case show alert
        NSError *error = [[NSError alloc] init];
        failure(error, NO_CONNECT_ERROR_STATUS_CODE);
    }
    
}

@end
