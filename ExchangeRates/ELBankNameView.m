//
//  ELBankNameView.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELBankNameView.h"

NSString * const ELBankNameViewNibName = @"ELBankNameView";

@interface ELBankNameView()
@property (strong, nonatomic) IBOutlet UIView *xibView;
@end

@implementation ELBankNameView

@synthesize date = _date;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UINib *nib = [UINib nibWithNibName:ELBankNameViewNibName bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.xibView];
        self.xibView.frame = self.bounds;
        self.xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.date = [NSDate date];
    }
    return self;
}

#pragma mark - Custom Accessor

- (void) setDate:(NSDate *)date
{
    _date = date;
    
    NSAttributedString *attributedTitle = [ELUtils attributedTitleForActiveStateWithDate:date];
    self.dateLabel.attributedText = attributedTitle;
}

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

@end
