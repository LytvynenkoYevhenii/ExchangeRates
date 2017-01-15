//
//  ELDatePickerViewController.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 15.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ELDatePickerCompletionBlock)(BOOL confirm, BOOL sync, NSDate *date);

extern NSString * const ELDatePickerViewControllerStoryboardID;

@interface ELDatePickerViewController : UIViewController
@property (strong, nonatomic) NSDate * startingDate;
@property (strong, nonatomic) NSString *bankName;
@property (copy, nonatomic) ELDatePickerCompletionBlock completionBlock;
@end

