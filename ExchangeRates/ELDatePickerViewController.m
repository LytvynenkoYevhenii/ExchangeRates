//
//  ELDatePickerViewController.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELDatePickerViewController.h"

NSString * const ELDatePickerViewControllerStoryboardID = @"ELDatePickerViewController";

@interface ELDatePickerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *syncSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ELDatePickerViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    self.datePicker.date = self.startingDate;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessor

- (void)setStartingDate:(NSDate *)startingDate
{
    _startingDate = startingDate;
    [self.datePicker setDate:startingDate animated:YES];
}

- (void) setBankName:(NSString *)bankName
{
    _bankName = bankName;
    self.bankNameLabel.text = bankName;
}

#pragma mark - Actions

- (IBAction)actionConfirm:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.completionBlock(YES, self.syncSwitch.isOn, self.datePicker.date);
    }];
}

- (IBAction)actionCancel:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.completionBlock(NO, self.syncSwitch.isOn, self.datePicker.date);
    }];}

@end
