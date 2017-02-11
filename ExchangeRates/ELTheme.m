//
//  ELTheme.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 12.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELTheme.h"

#import <UIKit/UIKit.h>

NSString * const ELMainFontName = @"AvenirNext-Medium";

@implementation ELTheme

#pragma mark - Colors

+ (UIColor *)navigationBarBackgroundColor   { return RGBA(54,  143, 104, 100); }
+ (UIColor *)interactiveTextColor           { return RGBA(245, 166, 35,  100); }
+ (UIColor *)passiveInteractTextColor       { return RGBA(162, 162, 162, 100); }
+ (UIColor *)privatBankCurrencyTextColor    { return RGBA(98,  98,  98,  100); }
+ (UIColor *)bankNameTextColor              { return RGBA(105, 105, 105, 100); }
+ (UIColor *)pairedCellBackgroundColor      { return RGBA(240, 245, 242, 100); }
+ (UIColor *)iconInPassiveStateColor        { return RGBA(216, 216, 216, 100); }
+ (UIColor *)iconInActiveStateColor         { return RGBA(105, 146, 123, 100); }
+ (UIColor *)navigationBarTitleTextColor    { return [UIColor whiteColor];}
+ (UIColor *)selectedCellBackgroundColor    { return [[ELTheme navigationBarBackgroundColor] colorWithAlphaComponent:0.2f]; }

#pragma mark - Text attributes

+ (NSDictionary *)textAttributesForNavigationBarTitle
{
    UIFont *font = [UIFont fontWithName:ELMainFontName size: 20.f];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [self navigationBarTitleTextColor],
                                 NSFontAttributeName            : font};
    return attributes;
}

@end
