//
//  ELPrivatBankTableHeaderView.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 13.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELPrivatBankTableHeaderView.h"

@interface ELPrivatBankTableHeaderView()
@property (strong, nonatomic) IBOutlet UIView *xibView;
@end

@implementation ELPrivatBankTableHeaderView

static NSString * const nibName = @"ELPrivatBankTableHeaderView";

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.xibView];
        self.xibView.frame = self.bounds;
        self.xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

@end
