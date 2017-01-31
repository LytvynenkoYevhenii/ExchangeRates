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

//Get currencies with date without saving to DB
- (void) getCurrenciesWithDate:(NSDate *)date bankType:(ELBankType)bankType inContext:(NSManagedObjectContext *)context completion:(void(^)(NSArray <ELCurrency *>*currencies, NSError *error, NSInteger statusCode))completion;

//Background dowmloading the currency archive
- (void) loadCurrenciesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate bankType:(ELBankType)bankType completion:(void(^)(BOOL succes, NSError *error, NSInteger statusCode))completionBlock;

@end
