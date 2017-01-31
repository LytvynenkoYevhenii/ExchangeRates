//
//  ELSecondSectorTableViewController.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELCurrencyListRootViewController.h"

@class ELCurrency;

@interface ELNBUViewController : ELCurrencyListRootViewController

- (void)selectRowWithCurrency:(NSString *)code;

@end
