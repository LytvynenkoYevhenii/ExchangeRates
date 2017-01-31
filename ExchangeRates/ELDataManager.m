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

#pragma mark - Initialization

+ (ELDataManager *)sharedManager
{
    static ELDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ELDataManager alloc] init];
    });
    return manager;
}

#pragma mark - Public API

- (void)currenciesWithDate:(NSDate *)date
                  bankType:(ELBankType)bankType
                completion:(void(^)(NSArray <ELCurrency *>*currencies, NSError *error, NSInteger statusCode))completion;

{
    if (!completion || !date) {
        return;
    }
    
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    
    //Try get data from data base
    
    NSString *bankName = nil;
    
    if (bankType == ELBankTypePrivatBank) {
        bankName = ELPrivatBankFullName;
    } else if (bankType == ELBankTypeNBU) {
        bankName = ELNBUBankFullName;
    }
    
    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"date == %@ AND bankName == %@", [[ELUtils standardFormatter]stringFromDate:date], bankName];
    NSArray *result = [ELCurrency MR_findAllWithPredicate:datePredicate inContext:defaultContext];
    
    if ([result count]) {
        completion(result, nil, 0);
        return;
    }

    //Check for connection before sending the URL request
    if ([[ELServerManager sharedManager] connected]) {
       
        // 1. Get json from server -> parse to Currencies in default context (for date) and return result array
     
        [[ELServerManager sharedManager] getCurrenciesWithDate:date bankType:bankType inContext:defaultContext completion:^(NSArray<ELCurrency *> *currencies, NSError *error, NSInteger statusCode) {
            
            if (completion) {
                if ([currencies count]) {
                    completion(currencies, nil, 0);
                } else {
                    completion(nil, error, statusCode);
                }
            }
        }];
        
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
        
    } else {
        completion(nil, nil, NO_CONNECT_ERROR_STATUS_CODE);
    }
}


@end
