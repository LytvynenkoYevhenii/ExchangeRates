//
//  ELSecondSectorTableViewCell.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELNBUTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *currencyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeСoefficientLabel;

@end
