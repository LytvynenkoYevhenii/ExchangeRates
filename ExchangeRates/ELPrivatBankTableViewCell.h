//
//  ELFirstSectorTableViewCell.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELPrivatBankTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleRateLabel;

@end
