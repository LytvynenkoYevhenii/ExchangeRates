//
//  ELBankNameView.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELBankNameView.h"
#import "ELUtils.h"

@interface ELBankNameView()
@property (strong, nonatomic) IBOutlet UIView *xibView;
@end

@implementation ELBankNameView

static NSString * const nibName = @"ELBankNameView";

#pragma mark - Custom Accessor

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.xibView];
        self.xibView.frame = self.bounds;
        self.xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.date = [NSDate dateWithTimeIntervalSinceNow:0];
    }
    return self;
}

- (void) setDate:(NSDate *)date
{
    _date = date;

    NSAttributedString *attributedTitle = [ELUtils attributedTitleForActiveStateWithDate:date];
//    [self.dateButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    self.dateLabel.attributedText = attributedTitle;
}


@end
