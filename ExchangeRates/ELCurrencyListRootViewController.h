//
//  ELCurrencyListRootViewControllerTableViewController.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 31.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCurrency;

@interface ELCurrencyListRootViewController : UIViewController

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray <ELCurrency *>*currenciesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSPredicate *sourceObjectsPredicate;

@end
