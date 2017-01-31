//
//  ELUtils.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation ELUtils

#pragma mark - Attributed titles

+ (NSAttributedString *)attributedTitleForActiveStateWithDate:(NSDate *)date
{
    UIColor *activeStateColor = [UIColor orangeColor];
    return [self attributedTitleWithDate:date andColor:activeStateColor];
}

+ (NSAttributedString *)attributedTitleForUnactiveStateWithDate:(NSDate *)date
{
    UIColor *unactiveStateColor = [UIColor darkGrayColor];
    return [self attributedTitleWithDate:date andColor:unactiveStateColor];
}

#pragma mark - Image operations

+ (void)changeTintColor:(UIColor *)color forImageInView:(UIImageView *)imageView
{
    if (imageView.image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
        imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    if ([imageView.tintColor isEqual:color]) {
        return;
    }
    
    [imageView setTintColor:color];
}

+ (NSString *)currencyLocalizedNameWithCode:(NSString *)currencyCode
{
    NSString *localizedName = currencyCode;
    
    if ([[NSLocale ISOCurrencyCodes] containsObject:currencyCode]) {
        NSLocale *locale = [NSLocale currentLocale];
        localizedName = [locale displayNameForKey:NSLocaleCurrencyCode value:currencyCode];
    }
    return localizedName;
}

+ (NSDateFormatter *)standardFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ELStandardDateFormat];
    return formatter;
}

#pragma mark - Private methods

+ (NSAttributedString *)attributedTitleWithDate:(NSDate *)date andColor:(UIColor *)color
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:ELStandardDateFormat];
    
    NSString *title = [formatter stringFromDate:date];
    UIFont *font = [UIFont fontWithName:ELMainFontName size:16.f];
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                 NSForegroundColorAttributeName : color};
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    
    return attributedTitle;
}

@end
