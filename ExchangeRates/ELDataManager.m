//
//  ELDataManager.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 16.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELDataManager.h"
#import "ELServerManager.h"

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
                   success:(void(^)(NSArray* currencies))success
                   failure:(void(^)(NSError *error, NSInteger statusCode))failure
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
       
        //Send the URL request
        [[ELServerManager sharedManager] getCurrenciesWithDate:date inSuccess:success inFailure:failure];
    
    } else if (failure) {
        
        //In non connected case show alert
        NSError *error = [[NSError alloc] init];
        failure(error, NO_CONNECT_ERROR_STATUS_CODE);
    }
    
}

@end
