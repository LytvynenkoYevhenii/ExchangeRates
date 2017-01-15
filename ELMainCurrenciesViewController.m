//
//  ViewController.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 10.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELMainCurrenciesViewController.h"
#import "ELBankNameView.h"
#import "ELPrivatBankViewController.h"
#import "ELNBUTableViewController.h"
#import "ELDatePicker.h"

#import "ELCurrency+CoreDataProperties.h"
#import "ELBank+CoreDataProperties.h"

@interface ELMainCurrenciesViewController ()<ELPrivatBankViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet ELBankNameView *privatBankActivityView;
@property (weak, nonatomic) IBOutlet ELBankNameView *nbuActivityView;
@property (weak, nonatomic) IBOutlet UIView *pbSectorView;
@property (weak, nonatomic) IBOutlet UIView *nbuSectorView;

//Child view controllers
@property (strong, nonatomic) ELPrivatBankViewController *pbViewController;
@property (strong, nonatomic) ELNBUTableViewController *nbuViewController;

@end

@implementation ELMainCurrenciesViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self addTestCurrencies];
    
    //Child view controllers
    NSPredicate *pbPredicate = [NSPredicate predicateWithFormat:@"class == %@", [ELPrivatBankViewController class]];
    self.pbViewController = [[self.childViewControllers filteredArrayUsingPredicate:pbPredicate]firstObject];
    
    NSPredicate *nbuPredicate = [NSPredicate predicateWithFormat:@"class == %@", [ELNBUTableViewController class]];
    self.nbuViewController = [[self.childViewControllers filteredArrayUsingPredicate:nbuPredicate]firstObject];
    
    //Set self as delegate of the PB view controller for sync selection
    self.pbViewController.delegate = self;
    
    //Add actions
    [self.nbuActivityView.dateButton addTarget:self action:@selector(actionChangeDateForNBU:) forControlEvents:UIControlEventTouchUpInside];
    [self.privatBankActivityView.dateButton addTarget:self action:@selector(actionChangeDateForPrivatBank:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set bank names
    self.privatBankActivityView.bankNameLabel.text = NSLocalizedString(ELPrivatBankName, nil);
    self.nbuActivityView.bankNameLabel.text = NSLocalizedString(ELNBUBankName, nil);

    //Set nav bar title
    self.navigationItem.title = NSLocalizedString(@"Exchange Rate", nil);
    
    //Add date picker view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <ELPrivatBankViewControllerDelegate>

- (void) privatBankViewController:(ELPrivatBankViewController *)privatBankViewController didSelectCurrencyWithCode:(NSString *)currency
{
    [self.nbuViewController selectRowWithCurrency:currency];
}

#pragma mark - Private methods

- (void)addTestCurrencies
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *currencyCodes = @[@"USD", @"EUR", @"RUR", @"CHF", @"GBP", @"PLZ", @"SEC", @"XAU", @"CAD"];
        NSArray *bankNames = @[ELPrivatBankName, ELNBUBankName];
        
        for (NSString *bankName in bankNames) {
            ELBank *bank = [ELBank MR_createEntityInContext:localContext];
            bank.name = bankName;
            
            for (NSString *key in currencyCodes) {
                ELCurrency *currency = [ELCurrency MR_createEntityInContext:localContext];
                currency.code = key;
                currency.saleRate = arc4random() % 40001 /1000.f + 10.f; //10.f...50.f
                currency.purchaseRate = currency.saleRate * ((arc4random() % 21) / 100.f + 0.8f); //0.8...1.0
                currency.bank = bank;
            }
        }
    }];
}

- (void) changeDateForBankNameView:(ELBankNameView *)view
{
    [ELUtils changeTintColor:[ELTheme iconInActiveStateColor]
              forImageInView:view.calendarIconImageView];
    
    ELDatePicker *datePicker = [[ELDatePicker alloc] initWithPresentingController:self startingDate:view.date andBankName:view.bankNameLabel.text];
    
    [datePicker showDatePickerWithConfirmDataBlock:^(BOOL confirm, BOOL sync, NSDate *date) {
        [ELUtils changeTintColor:[ELTheme iconInPassiveStateColor] forImageInView:view.calendarIconImageView];
        if (confirm) {
            if (sync) {
                self.privatBankActivityView.date = date;
                self.nbuActivityView.date = date;
            } else {
                view.date = date;
            }
        }
    }];
}

#pragma mark - Actions

- (void)actionChangeDateForPrivatBank:(UIButton *)sender
{
    [self changeDateForBankNameView:self.privatBankActivityView];
}

- (void)actionChangeDateForNBU:(UIButton *)sender
{
    [self changeDateForBankNameView:self.nbuActivityView];
}


@end
