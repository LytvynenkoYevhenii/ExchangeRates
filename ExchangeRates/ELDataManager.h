//
//  ELDataManager.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 16.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ELCurrency;

@interface ELDataManager : NSObject

+ (ELDataManager *)sharedManager;

- (void)currenciesWithDate:(NSDate *)date
                  bankType:(ELBankType)bankType
                completion:(void(^)(NSArray <ELCurrency *>*currencies, NSError *error, NSInteger statusCode))completion;

@end
