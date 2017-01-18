//
//  ELDataManager.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 16.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, ELBankType) {
//    ELBankTypePrivat,
//    ELBankTypeNBU
//};

@interface ELDataManager : NSObject

+ (ELDataManager *)sharedManager;

- (void)currenciesWithDate:(NSDate *)date
                   success:(void(^)(NSArray* currencies))success
                   failure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
