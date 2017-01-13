//
//  ELBankNameView.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELBankNameView : UIView

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *calendarIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
