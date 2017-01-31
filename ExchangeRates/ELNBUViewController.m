//
//  ELSecondSectorTableViewController.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELNBUViewController.h"
#import "ELNBUTableViewCell.h"
#import "ELCalculator.h"
#import "ELPrivatBankViewController.h"

#import "ELCurrency+CoreDataProperties.h"

@interface ELNBUViewController ()
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation ELNBUViewController

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

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    NSArray *selectedIndexPaths = nil;
    
    if (!self.selectedIndexPath) {
        selectedIndexPaths = @[selectedIndexPath];
    } else {
        selectedIndexPaths = @[selectedIndexPath, self.selectedIndexPath];
    }
    
    _selectedIndexPath = selectedIndexPath;

    [self.tableView reloadRowsAtIndexPaths:selectedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ELNBUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    [self designCell:cell withIndexPath:indexPath];
    
    ELCurrency *currency = [self.currenciesArray objectAtIndex:indexPath.row];
    CGFloat rate = currency.saleRate;
    NSInteger coefficient = 0;
    [ELCalculator optimizeRate:&rate withExchangeCoefficient:&coefficient];
    
    cell.saleRateLabel.text = [NSString stringWithFormat:@"%1.3f", rate];
    cell.exchangeСoefficientLabel.text = [NSString stringWithFormat:@"%d%@", coefficient, basicCurrencyCode] ;
    cell.currencyNameLabel.text = [ELUtils currencyLocalizedNameWithCode:currency.code];

    return cell;
}

- (void)designCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.selectedIndexPath]) {
        cell.contentView.backgroundColor = [ELTheme selectedCellBackgroundColor];
    } else {
        //Regards to all non selected cells
        if (indexPath.row % 2) {
            cell.contentView.backgroundColor = [ELTheme pairedCellBackgroundColor];
        } else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - Public API

- (void)selectRowWithCurrency:(NSString *)code
{
    NSPredicate *currencyCodePredicate = [NSPredicate predicateWithFormat:@"code == %@", code];
    ELCurrency *selectedCurrency = [[self.currenciesArray filteredArrayUsingPredicate:currencyCodePredicate] firstObject];
    NSInteger row = [self.currenciesArray indexOfObject:selectedCurrency];
    NSIndexPath *newSelectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];

    if (![newSelectedIndexPath isEqual:self.selectedIndexPath]) {
        self.selectedIndexPath = newSelectedIndexPath;
        [self.tableView scrollToRowAtIndexPath:newSelectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

@end
