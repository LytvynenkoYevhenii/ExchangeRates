//
//  ELDatePickerView.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELDatePickerView.h"

@implementation ELDatePickerView

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    //Set max date for date picker to equal with today
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    self.datePicker.maximumDate = today;
}

@end
