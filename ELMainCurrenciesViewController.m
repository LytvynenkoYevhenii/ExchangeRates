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
#import "ELServerManager.h"

#import "ELCurrency+CoreDataProperties.h"

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
    [self addTestCurrencies];
    
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
    self.privatBankActivityView.bankNameLabel.text = NSLocalizedString(ELPrivatBankFullName, nil);
    self.nbuActivityView.bankNameLabel.text = NSLocalizedString(ELNBUBankFullName, nil);

    //Set nav bar title
    self.navigationItem.title = NSLocalizedString(@"Exchange Rate", nil);
    
    [[ELServerManager sharedManager]getCurrenciesWithDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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
        NSArray *bankNames = @[ELPrivatBankFullName, ELNBUBankFullName];
        
        for (NSString *bankName in bankNames) {
           
            for (NSString *key in currencyCodes) {
                ELCurrency *currency = [ELCurrency MR_createEntityInContext:localContext];
                currency.code = key;
                currency.saleRate = arc4random() % 40001 /1000.f + 10.f; //10.f...50.f
                currency.purchaseRate = currency.saleRate * ((arc4random() % 21) / 100.f + 0.8f); //0.8...1.0
                currency.bankName = bankName;
            }
        }
    }];
}

- (void) changeDateForBankNameView:(ELBankNameView *)view
{
    NSString *bankName = nil;
    
    if ([view isEqual:self.privatBankActivityView]) {
        bankName = NSLocalizedString(ELPrivatBankFullName, nil);
    } else {
        bankName = NSLocalizedString(ELNBUBankFullName, nil);
    }
    
    [ELUtils changeTintColor:[ELTheme iconInActiveStateColor]
              forImageInView:view.calendarIconImageView];
    
    ELDatePicker *datePicker = [[ELDatePicker alloc] initWithPresentingController:self startingDate:view.date andBankName:bankName];
    
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

#pragma mark - Rotation

- (void)orientationChanged:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIDeviceOrientationPortrait) {
        self.privatBankActivityView.bankNameLabel.text = NSLocalizedString(ELPrivatBankFullName, nil);
        self.nbuActivityView.bankNameLabel.text = NSLocalizedString(ELNBUBankFullName, nil);

    } else {
        self.privatBankActivityView.bankNameLabel.text = NSLocalizedString(ELPrivatBankShortName, nil);
        self.nbuActivityView.bankNameLabel.text = NSLocalizedString(ELNBUBankShortName, nil);
    }
}


@end
