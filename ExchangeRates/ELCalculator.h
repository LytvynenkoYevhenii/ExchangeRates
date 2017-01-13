//
//  ELCalculator.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 13.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELCalculator : NSObject

+ (void) optimizeRate:(CGFloat*)rate withExchangeCoefficient:(NSInteger*)coeficient;

@end
