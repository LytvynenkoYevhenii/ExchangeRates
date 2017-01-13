//
//  ELTheme.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 12.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a / 100.f]

@interface ELTheme : NSObject

+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)interactiveTextColor;
+ (UIColor *)passiveInteractTextColor;
+ (UIColor *)privatBankCurrencyTextColor;
+ (UIColor *)bankNameTextColor;
+ (UIColor *)iconInPassiveStateColor;
+ (UIColor *)iconInActiveStateColor;

@end
