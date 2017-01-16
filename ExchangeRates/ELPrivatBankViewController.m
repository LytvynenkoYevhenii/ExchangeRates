//
//  ELFirstSectorTableViewController.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELPrivatBankViewController.h"
#import "ELPrivatBankTableViewCell.h"
#import "ELCurrency+CoreDataProperties.h"

NSString * const ELPrivatBankFullName = @"PrivatBank";
NSString * const ELPrivatBankShortName = @"PB";

@interface ELPrivatBankViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *currenciesArray;
@end

@implementation ELPrivatBankViewController

static NSString * const cellReuseIdentifier = @"ELPrivatBankTableViewCell";
static NSString * const cellNibName = @"ELPrivatBankTableViewCell";

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register nibs
    UINib *cellNib = [UINib nibWithNibName:cellNibName bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom accessor

- (NSArray *)currenciesArray
{
    if (!_currenciesArray) {
        NSPredicate *pbPredicate = [NSPredicate predicateWithFormat:@"bankName == %@", ELPrivatBankFullName];
        _currenciesArray = [ELCurrency MR_findAllWithPredicate:pbPredicate];
    }
    return _currenciesArray;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currenciesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELPrivatBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    ELCurrency *currency = [self.currenciesArray objectAtIndex:indexPath.row];
    cell.currencyLabel.text = currency.code;
    cell.purchaseRateLabel.text = [NSString stringWithFormat:@"%1.3f", currency.purchaseRate];
    cell.saleRateLabel.text = [NSString stringWithFormat:@"%1.3f", currency.saleRate];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ELCurrency *currency = [self.currenciesArray objectAtIndex:indexPath.row];
    [self.delegate privatBankViewController:self didSelectCurrencyWithCode:currency.code];
}

@end
