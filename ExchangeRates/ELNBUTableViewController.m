//
//  ELSecondSectorTableViewController.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELNBUTableViewController.h"
#import "ELNBUTableViewCell.h"
#import "ELCalculator.h"
#import "ELPrivatBankViewController.h"

#import "ELCurrency+CoreDataProperties.h"

NSString * const ELNBUBankName = @"NBU";

@interface ELNBUTableViewController ()
@property (strong, nonatomic) NSArray *currenciesArray;
@end

@implementation ELNBUTableViewController

static NSString * const cellReuseIdentifier = @"ELNBUTableViewCell";
static NSString * const cellNibName = @"ELNBUTableViewCell";
static NSString * const basicCurrencyCode = @"UAH";

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register nib
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
        NSPredicate *nbuPredicate = [NSPredicate predicateWithFormat:@"bank.name == %@", ELNBUBankName];
        _currenciesArray = [ELCurrency MR_findAllWithPredicate:nbuPredicate];
    }
    return _currenciesArray;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currenciesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELNBUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if (!cell.selected) {
        if (indexPath.row % 2) {
            cell.contentView.backgroundColor = [ELTheme pairedCellBackgroundColor];
        } else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    ELCurrency *currency = [self.currenciesArray objectAtIndex:indexPath.row];
    CGFloat rate = currency.saleRate;
    NSInteger coefficient = 0;
    [ELCalculator optimizeRate:&rate withExchangeCoefficient:&coefficient];
    
    cell.saleRateLabel.text = [NSString stringWithFormat:@"%1.3f", rate];
    cell.exchangeСoefficientLabel.text = [NSString stringWithFormat:@"%d%@", coefficient, basicCurrencyCode] ;
    cell.currencyNameLabel.text = [ELUtils currencyLocalizedNameWithCode:currency.code];

    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - Public API

- (void)selectRowWithCurrency:(NSString *)code
{
    NSPredicate *currencyCodePredicate = [NSPredicate predicateWithFormat:@"code == %@", code];
    ELCurrency *selectedCurrency = [[self.currenciesArray filteredArrayUsingPredicate:currencyCodePredicate] firstObject];
    NSInteger row = [self.currenciesArray indexOfObject:selectedCurrency];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}



@end
