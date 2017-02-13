//
//  ELParser.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 19.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELParser.h"
#import "ELDataManager.h"
#import "ELCurrency+CoreDataProperties.h"

@implementation ELParser

#pragma mark - Initialization

+ (ELParser *)sharedInstance
{
    static ELParser *parser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[ELParser alloc] init];
    });
    
    return parser;
}

#pragma mark - Public API

- (NSArray <ELCurrency*>*)parseCurrenciesFromAPIWithType:(ELApiType)apiType responseData:(NSData *)data inContext:(NSManagedObjectContext *)context
{
    if (!context || !data) {
        return nil;
    }
    NSArray *resultArray = nil;
    
    switch (apiType) {
        case ELApiTypePrivatBankArchive:
            resultArray = [self parseCurrenciesFromPrivatArchiveAPIWithResponseData:data inContext:context];
            break;
            
        case ELApiTypePrivatBankToday:
            resultArray = [self parseCurrenciesFromPrivatBankTodayAPIWithResponseData:data inContext:context];
            break;
            
        case ELApiTypeNBU:
            resultArray = [self parseCurrenciesFromNbuApiWithResponseData:data inContext:context];
            break;
            
        default:
            break;
    }
    
    return resultArray;
}

#pragma mark - Private API

- (NSArray <ELCurrency*>*)parseCurrenciesFromPrivatArchiveAPIWithResponseData:(NSData *)data inContext:(NSManagedObjectContext *)context
{
    static NSString * const codeKey         = @"currency";
    static NSString * const purchaseRateKey = @"purchaseRate";
    static NSString * const saleRateKey     = @"saleRate";
    static NSString * const dateKey         = @"date";
    static NSString * const exchangeRateKey = @"exchangeRate";
    
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *dateString = [responseDict objectForKey:dateKey];
    
    NSArray *currenciesArray = [responseDict objectForKey:exchangeRateKey];
    
    return [self createCurrenciesFromArray:currenciesArray withCodeKey:codeKey purchaseRateKey:purchaseRateKey saleRateKey:saleRateKey formattedDate:dateString inContext:context];
}

- (NSArray <ELCurrency*>*)parseCurrenciesFromPrivatBankTodayAPIWithResponseData:(NSData *)data inContext:(NSManagedObjectContext *)context
{
    static NSString * const codeKey         = @"ccy";
    static NSString * const purchaseRateKey = @"buy";
    static NSString * const saleRateKey     = @"sale";
    
    NSArray* currenciesArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *date = [[ELUtils standardFormatter] stringFromDate:[NSDate date]];
    
    return [self createCurrenciesFromArray:currenciesArray withCodeKey:codeKey purchaseRateKey:purchaseRateKey saleRateKey:saleRateKey formattedDate:date inContext:context];
}

- (NSArray <ELCurrency *>*)parseCurrenciesFromNbuApiWithResponseData:(NSData *)data inContext:(NSManagedObjectContext *)context
{
    static NSString * const codeKey         = @"cc";
    static NSString * const purchaseRateKey = @"rate";
    static NSString * const saleRateKey     = @"rate";
    static NSString * const dateKey         = @"exchangedate";
    
    NSError *error = nil;
    
    NSArray *currenciesArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];

    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    NSDictionary *firstCurrencyDict = [currenciesArray firstObject];
    NSString *date = [firstCurrencyDict valueForKey:dateKey];
    
    return [self createCurrenciesFromArray:currenciesArray withCodeKey:codeKey purchaseRateKey:purchaseRateKey saleRateKey:saleRateKey formattedDate:date inContext:context];
}

- (NSArray *)createCurrenciesFromArray:(NSArray *)currenciesArray withCodeKey:(NSString *)codeKey purchaseRateKey:(NSString *)purchaseRateKey saleRateKey:(NSString *)saleRateKey formattedDate:(NSString *)date inContext:(NSManagedObjectContext *)context
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSDictionary *currencyDict in currenciesArray) {
        
        if (![currencyDict valueForKey:codeKey] || ![currencyDict valueForKey:saleRateKey]) {
            continue;
        }
        
        //Create PB currency
        ELCurrency *nbuCurrency = [ELCurrency MR_createEntityInContext:context];
        nbuCurrency.bankName = ELNBUBankFullName;
        nbuCurrency.code = [currencyDict valueForKey:codeKey];
        nbuCurrency.purchaseRate = [[currencyDict valueForKey:purchaseRateKey] floatValue];
        nbuCurrency.saleRate = [[currencyDict valueForKey:saleRateKey] floatValue];
        nbuCurrency.date = date;
        
        [resultArray addObject:nbuCurrency];
    }
    return [NSArray arrayWithArray:resultArray];
}

@end
