//
//  ServerManager.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ELCurrency;

@interface ELServerManager : NSObject

//Initialization
+ (ELServerManager *)sharedManager;

//Check the network connection
- (BOOL)connected;

//Get currencies
- (void) getCurrenciesWithDate:(NSDate *)date
                      bankType:(ELBankType)bankType
                     inSuccess:(void (^)(NSArray<ELCurrency *> *currencies))success
                     inFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

//Background dowmloading the currency archive
- (void) loadCurrenciesFromDate:(NSDate *)fromDate
                         toDate:(NSDate *)toDate
                       bankType:(ELBankType)bankType
                     completion:(void(^)(BOOL succes, NSError *error, NSInteger statusCode))completionBlock;

@end
