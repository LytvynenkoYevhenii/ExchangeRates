//
//  ELFirstSectorTableViewController.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCurrency;

@protocol ELPrivatBankViewControllerDelegate;

@interface ELPrivatBankViewController : UIViewController

@property (weak, nonatomic) id <ELPrivatBankViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray <ELCurrency *>*currenciesArray;

@end


@protocol ELPrivatBankViewControllerDelegate <NSObject>

- (void) privatBankViewController:(ELPrivatBankViewController *)privatBankViewController didSelectCurrencyWithCode:(NSString *)currency;

@end
