//
//  ELDatePicker.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ELDatePickerViewController.h"

@interface ELDatePicker : NSObject

//Initialization
-(instancetype)initWithPresentingController:(UIViewController *)controller startingDate:(NSDate *)date andBankName:(NSString *)bankName;

//Presenting
-(void)showDatePickerWithConfirmDataBlock:(ELDatePickerCompletionBlock)block;

@end
