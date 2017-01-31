//
//  ELFirstSectorTableViewController.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELCurrencyListRootViewController.h"

@class ELCurrency;

@protocol ELPrivatBankViewControllerDelegate;


@interface ELPrivatBankViewController : ELCurrencyListRootViewController

@property (weak, nonatomic) id <ELPrivatBankViewControllerDelegate> delegate;

@end


@protocol ELPrivatBankViewControllerDelegate <NSObject>

- (void) privatBankViewController:(ELPrivatBankViewController *)privatBankViewController didSelectCurrencyWithCode:(NSString *)currency;

@end
