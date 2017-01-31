//
//  ELCalculator.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 13.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELCalculator.h"

@implementation ELCalculator

+ (void) optimizeRate:(CGFloat*)rate withExchangeCoefficient:(NSInteger*)coefficient
{
    CGFloat rateValue           = *rate;
    NSInteger coefficientValue   = 1;
    
    if (rateValue == 0) {
        return;
    }
    
    while (rateValue < 10) {
        coefficientValue *= 10;
        rateValue       *= 10;
    }
    *rate       = rateValue;
    *coefficient = coefficientValue;
}

+ (NSDate *)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days toDate:(NSDate *)date
{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setYear:years];
    [component setMonth:months];
    [component setDay:days];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *resultDate = [gregorianCalendar dateByAddingComponents:component toDate:date options:0];
    
    return resultDate;
}

+ (NSDate *)maxDateForCurrenciesArchive
{
    static NSDate *resultDate = nil;
    
    if (!resultDate) {
        resultDate = [NSDate date];
    }
    return resultDate;
}

+ (NSDate *)minDateForCurrenciesArchive
{
    static NSDate *resultDate = nil;
    
    if (!resultDate) {
        NSDate *today = [NSDate date];
        resultDate = [self dateByAddingYears:-4 months:0 days:0 toDate:today];
    }
    return resultDate;
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDate *minDate = [ELCalculator minDateForCurrenciesArchive];
    if ([fromDate compare:minDate] == NSOrderedAscending) {
        fromDate = minDate;
    }
    
    NSDate *maxDate = [ELCalculator maxDateForCurrenciesArchive];
    if ([toDate compare:maxDate] == NSOrderedDescending) {
        toDate = maxDate;
    }
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    
    return components;
}

@end
