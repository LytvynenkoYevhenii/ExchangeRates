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

@end
