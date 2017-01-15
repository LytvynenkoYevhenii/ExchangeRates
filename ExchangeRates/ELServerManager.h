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

+ (ELServerManager *)sharedManager;

- (NSArray <ELCurrency *>*)getCurrenciesWithDate:(NSDate *)date;

@end
