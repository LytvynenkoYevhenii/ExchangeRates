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
    
    static NSDictionary *currencyCodeToNameDictionary = nil;
    
    if (!currencyCodeToNameDictionary) {
        currencyCodeToNameDictionary = @{@"USD" : @"U.S. Dollar",
                                         @"EUR" : @"Euro",
                                         @"RUR" : @"Russian Ruble",
                                         @"RUB" : @"Russian Ruble",
                                         @"CHF" : @"Swiss Frank",
                                         @"GBP" : @"British Pound",
                                         @"PLZ" : @"Polish Zloty",
                                         @"SEC" : @"Swedish Krona",
                                         @"XAU" : @"Gold",
                                         @"CAD" : @"Canadian Dollar",
                                         @"HUF" : @"Hungarian Forint"};
    }
    
    NSString *name = [currencyCodeToNameDictionary objectForKey:currencyCode];
    
    if (name) {
        localizedName = NSLocalizedString(name, nil);
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
