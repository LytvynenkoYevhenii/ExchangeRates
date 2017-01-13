//
//  ELTheme.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 12.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELTheme.h"

#import <UIKit/UIKit.h>

@implementation ELTheme

+ (UIColor *)navigationBarBackgroundColor
{
    return RGBA(105, 154, 138, 100);
}

+ (UIColor *)interactiveTextColor
{
    return RGBA(245, 166, 35, 100);
}

+ (UIColor *)passiveInteractTextColor
{
    return RGBA(162, 162, 162, 100);
}

+ (UIColor *)privatBankCurrencyTextColor
{
    return RGBA(98,  98,  98,  100);
}

+ (UIColor *)bankNameTextColor
{
    return RGBA(105,  105,  105,  100);
}

+ (UIColor *)iconInPassiveStateColor
{
    return RGBA(216, 216, 216, 100);
}

+ (UIColor *)iconInActiveStateColor
{
    return RGBA(105, 146, 123, 100);
}


@end
