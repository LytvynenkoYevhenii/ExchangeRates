//
//  ELSecondSectorTableViewController.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCurrency;

@interface ELNBUTableViewController : UITableViewController

@property (strong, nonatomic) NSArray <ELCurrency *>*currenciesArray;

- (void)selectRowWithCurrency:(NSString *)code;

@end
