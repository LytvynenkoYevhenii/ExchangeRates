//
//  ELCurrencyListRootViewControllerTableViewController.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 31.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELCurrencyListRootViewController.h"

#import "ELCurrency+CoreDataProperties.h"

@interface ELCurrencyListRootViewController ()

@end

@implementation ELCurrencyListRootViewController

@synthesize currenciesArray = _currenciesArray;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom accessor

- (NSArray *)currenciesArray
{
    if (!_currenciesArray) {
        _currenciesArray = [ELCurrency MR_findAllWithPredicate:self.sourceObjectsPredicate inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return _currenciesArray;
}

- (void) setCurrenciesArray:(NSArray<ELCurrency *> *)currenciesArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES];
    NSArray *sortedArray = [currenciesArray sortedArrayUsingDescriptors:@[descriptor]];
    
    _currenciesArray = sortedArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setSourceObjectsPredicate:(NSPredicate *)sourceObjectsPredicate
{
    _sourceObjectsPredicate = sourceObjectsPredicate;
    self.currenciesArray = [ELCurrency MR_findAllWithPredicate:sourceObjectsPredicate inContext:[NSManagedObjectContext MR_defaultContext]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currenciesArray count];
}


@end
