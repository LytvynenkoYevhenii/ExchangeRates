//
//  ELFirstSectorTableViewCell.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELPrivatBankTableViewCell.h"

@implementation ELPrivatBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView *bgColorView = [[UIView alloc] init];
    
    bgColorView.backgroundColor = [ELTheme selectedCellBackgroundColor];
    
    [self setSelectedBackgroundView:bgColorView];
}

@end
