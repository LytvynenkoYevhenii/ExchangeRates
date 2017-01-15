//
//  ELDatePicker.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELDatePicker.h"

@interface ELDatePicker()
@property (nonatomic, strong) UIViewController *presentingViewController;
@property (nonatomic, strong) NSString  *bankName;
@property (nonatomic, strong) NSDate *startingDate;
@end

@implementation ELDatePicker

#pragma mark - Initialization

-(instancetype)initWithPresentingController:(UIViewController *)controller startingDate:(NSDate *)date andBankName:(NSString *)bankName
{
    self = [super init];
    if (self) {
        self.presentingViewController = controller;
        self.startingDate = date;
        self.bankName = bankName;
    }
    return self;
}

#pragma mark - Show date picker


-(void)showDatePickerWithConfirmDataBlock:(ELDatePickerCompletionBlock)block
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ELDatePickerViewController *datePickerVC = [storyBoard instantiateViewControllerWithIdentifier:ELDatePickerViewControllerStoryboardID];
    
    datePickerVC.startingDate = self.startingDate;
    datePickerVC.bankName = self.bankName;
    datePickerVC.completionBlock = block;
    
    [self.presentingViewController presentViewController:datePickerVC animated:YES completion:nil];
}

@end
