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
#import "ELDataManager.h"

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
    self.privatBankActivityView.bankNameLabel.text = NSLocalizedString(ELPrivatBankFullName, nil);
    self.nbuActivityView.bankNameLabel.text = NSLocalizedString(ELNBUBankFullName, nil);

    //Set nav bar title
    self.navigationItem.title = NSLocalizedString(@"Exchange Rate", nil);
    
    //Add observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
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
   
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
//        NSArray *currencyCodes = @[@"USD", @"EUR", @"RUR", @"CHF", @"GBP", @"PLZ", @"SEC", @"XAU", @"CAD"];
//        NSArray *bankNames = @[ELPrivatBankFullName, ELNBUBankFullName];
//        
//        for (NSString *bankName in bankNames) {
//           
//            for (NSString *key in currencyCodes) {
//                ELCurrency *currency = [ELCurrency MR_createEntityInContext:localContext];
//                currency.code = key;
//                currency.saleRate = arc4random() % 40001 /1000.f + 10.f; //10.f...50.f
//                currency.purchaseRate = currency.saleRate * ((arc4random() % 21) / 100.f + 0.8f); //0.8...1.0
//                currency.bankName = bankName;
//            }
//        }
//    }];
}

- (void) changeDateForBankNameView:(ELBankNameView *)view
{
    NSString *bankName = nil;
    
    if ([view isEqual:self.privatBankActivityView]) {
        bankName = NSLocalizedString(ELPrivatBankFullName, nil);
    } else {
        bankName = NSLocalizedString(ELNBUBankFullName, nil);
    }
    
    //Chenge color of the calendar icon
    [ELUtils changeTintColor:[ELTheme iconInActiveStateColor]
              forImageInView:view.calendarIconImageView];
    
    //Show date picker view controller
    ELDatePicker *datePicker = [[ELDatePicker alloc] initWithPresentingController:self startingDate:view.date andBankName:bankName];
    
    [datePicker showDatePickerWithConfirmDataBlock:^(BOOL confirm, BOOL sync, NSDate *date) {
        [ELUtils changeTintColor:[ELTheme iconInPassiveStateColor] forImageInView:view.calendarIconImageView];
        if (confirm) {
            [[ELDataManager sharedManager] currenciesWithDate:date success:^(NSArray *currencies) {
                if (sync) {
                    self.privatBankActivityView.date = date;
                    self.nbuActivityView.date = date;
                    
                    //Table views data reloading
                    self.pbViewController.currenciesArray = currencies;
                    self.nbuViewController.currenciesArray = currencies;

                } else {
                    view.date = date;
                    
                    //Table view data reloading
                    if ([view isEqual:self.privatBankActivityView]) {
                        self.pbViewController.currenciesArray = currencies;
                    } else {
                        self.nbuViewController.currenciesArray = currencies;
                    }
                    
                    //Table view data must be reloaded
                    self.pbViewController.currenciesArray = currencies;
                    self.nbuViewController.currenciesArray = currencies;
                }
                
            } failure:^(NSError *error, NSInteger statusCode) {
                
                //If device is not connected to internet - show alert and set last date
                if (statusCode == NO_CONNECT_ERROR_STATUS_CODE) {
                    [self showAlertForNoConnectError];
                }
            }];
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

#pragma mark - Alerts

- (void) showAlertForNoConnectError
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Connect", nil) message:NSLocalizedString(@"Data can`t be downloaded because connection is lost.", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
