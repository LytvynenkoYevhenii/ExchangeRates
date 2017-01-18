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

//Fetch methods
- (void)getCurrenciesWithDate:(NSDate *)date
                    inSuccess:(void(^)(NSArray <ELCurrency *>* currencies))success
                    inFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

//Parse currencies and add to DB
- (void)asyncCreateNewCurrenciesFromPrivatArchiveAPIWithResponseData:(NSData *)data withCompletion:(void(^)(BOOL success, NSError *error))completion;
- (void)syncCreateNewCurrenciesFromPrivatArchiveAPIWithResponseData:(NSData *)data;

@end
