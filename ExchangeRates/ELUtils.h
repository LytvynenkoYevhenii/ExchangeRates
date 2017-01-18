//
//  ELUtils.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NO_CONNECT_ERROR_STATUS_CODE 123

@interface ELUtils : NSObject

//Attributed title for date button when user interaction enabled
+ (NSAttributedString *)attributedTitleForActiveStateWithDate:(NSDate *)date;

//Attributed title for date button when user interaction disabled
+ (NSAttributedString *)attributedTitleForUnactiveStateWithDate:(NSDate *)date;

//Image changing
+ (void)changeTintColor:(UIColor *)color forImageInView:(UIImageView *)imageView;

//String generation
+ (NSString *)currencyLocalizedNameWithCode:(NSString *)currencyCode;

@end
