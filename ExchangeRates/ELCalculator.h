//
//  ELCalculator.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 13.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELCalculator : NSObject

//For example: you receive 00.025365 units of some currency per 1 units of another. Optimized result is 25.365 per 1000
+ (void) optimizeRate:(CGFloat*)rate withExchangeCoefficient:(NSInteger*)coeficient;

//Calculate date by adding date components. Also you can decrease any date by sending the negative numbers
+ (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days toDate:(NSDate *)date;

//Min archive date
+ (NSDate *)minDateForCurrenciesArchive;

//Max archive date 
+ (NSDate *)maxDateForCurrenciesArchive;

@end
