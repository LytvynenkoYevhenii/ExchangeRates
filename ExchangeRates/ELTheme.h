//
//  ELTheme.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 12.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

extern NSString * const ELMainFontName;

#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a / 100.f]

@interface ELTheme : NSObject

//colors
+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)interactiveTextColor;
+ (UIColor *)passiveInteractTextColor;
+ (UIColor *)privatBankCurrencyTextColor;
+ (UIColor *)bankNameTextColor;
+ (UIColor *)pairedCellBackgroundColor;
+ (UIColor *)iconInPassiveStateColor;
+ (UIColor *)iconInActiveStateColor;
+ (UIColor *)selectedCellBackgroundColor;

//Text attributes
+ (NSDictionary *)textAttributesForNavigationBarTitle;

@end
