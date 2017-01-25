//
//  ELParser.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 19.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ELCurrency;

@interface ELParser : NSObject

+ (ELParser *)sharedInstance;

- (NSArray <ELCurrency*>*)parseCurrenciesFromAPIWithType:(ELApiType)apiType responseData:(NSData *)data inContext:(NSManagedObjectContext *)context;

@end
