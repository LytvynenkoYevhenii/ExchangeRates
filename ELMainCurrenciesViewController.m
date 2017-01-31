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
#import "ELNBUViewController.h"
#import "ELDatePicker.h"
#import "ELDataManager.h"

#import "ELCurrency+CoreDataProperties.h"

@interface ELMainCurrenciesViewController ()<ELPrivatBankViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet ELBankNameView *privatBankActivityView;
@property (weak, nonatomic) IBOutlet ELBankNameView *nbuActivityView;
@property (weak, nonatomic) IBOutlet UIView *pbSectorView;
@property (weak, nonatomic) IBOutlet UIView *nbuSectorView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

//Child view controllers
@property (strong, nonatomic) ELPrivatBankViewController *pbViewController;
@property (strong, nonatomic) ELNBUViewController *nbuViewController;

@end

@implementation ELMainCurrenciesViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Child view controllers
    NSPredicate *pbPredicate = [NSPredicate predicateWithFormat:@"class == %@", [ELPrivatBankViewController class]];
    self.pbViewController = [[self.childViewControllers filteredArrayUsingPredicate:pbPredicate]firstObject];
    
    NSPredicate *nbuPredicate = [NSPredicate predicateWithFormat:@"class == %@", [ELNBUViewController class]];
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
    
    //Add observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currenciesDidLoad:)
                                                 name:ELServerManagerCurrenciesDidLoadNotification
                                               object:nil];
    
    //Source array for today
    [self getAllCurrenciesWithDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:ELServerManagerCurrenciesDidLoadNotification object:nil];
}

#pragma mark - <ELPrivatBankViewControllerDelegate>

- (void) privatBankViewController:(ELPrivatBankViewController *)privatBankViewController didSelectCurrencyWithCode:(NSString *)currency
{
    [self.nbuViewController selectRowWithCurrency:currency];
}

#pragma mark - Private methods

- (void) changeDateForBankNameView:(ELBankNameView *)view
{
    NSString *bankName = nil;
    ELBankType bankType = 0;
    
    if ([view isEqual:self.privatBankActivityView]) {
        bankName = NSLocalizedString(ELPrivatBankFullName, nil);
        bankType = ELBankTypePrivatBank;
    } else {
        bankName = NSLocalizedString(ELNBUBankFullName, nil);
        bankType = ELBankTypeNBU;
    }
    
    //Change color of the calendar icon
    [ELUtils changeTintColor:[ELTheme iconInActiveStateColor]
              forImageInView:view.calendarIconImageView];
    
    //Show date picker view controller
    ELDatePicker *datePicker = [[ELDatePicker alloc] initWithPresentingController:self startingDate:view.date andBankName:bankName];
    
    [datePicker showDatePickerWithConfirmDataBlock:^(BOOL confirm, BOOL sync, NSDate *date) {
        
        [ELUtils changeTintColor:[ELTheme iconInPassiveStateColor] forImageInView:view.calendarIconImageView];
        
        if (sync) {
            self.nbuActivityView.date = date;
            self.privatBankActivityView.date = date;
            [self getAllCurrenciesWithDate:date];
        } else {
            view.date = date;
            [self getCurrenciesWithDate:date bankType:bankType];
        }
    }];
}

- (void)getAllCurrenciesWithDate:(NSDate *)date
{
    [self getCurrenciesWithDate:date bankType:ELBankTypePrivatBank];
    [self getCurrenciesWithDate:date bankType:ELBankTypeNBU];
}

- (void) getCurrenciesWithDate:(NSDate *)date bankType:(ELBankType)bankType
{
    [[ELDataManager sharedManager] currenciesWithDate:date bankType:bankType completion:^(NSArray<ELCurrency *> *currencies, NSError *error, NSInteger statusCode) {
        if ([currencies count]) {
           
            //Table view data reloading
            if (bankType == ELBankTypePrivatBank) {
                self.pbViewController.currenciesArray = currencies;
            } else {
                self.nbuViewController.currenciesArray = currencies;
            }

        } else {
            
            //If device is not connected to internet - show alert and set last date
            if (statusCode == NO_CONNECT_ERROR_STATUS_CODE) {
                [self showAlertForNoConnectError];
            }
            
            //If DB is empty -> set max and min date to date picker equals to 01.12.2014 (templates date) set date for BankNameViews equals to 01.12.2014
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kELManuallyDataBase]) {
                self.privatBankActivityView.date = [[ELUtils standardFormatter] dateFromString:ELTemplateJSONDate];
                self.nbuActivityView.date = [[ELUtils standardFormatter] dateFromString:ELTemplateJSONDate];
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

#pragma mark - Alerts

- (void) showAlertForNoConnectError
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Connect", nil) message:NSLocalizedString(@"Data can`t be downloaded because connection is lost.", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - Observing

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

- (void) currenciesDidLoad:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSDate *startDate = [userInfo valueForKey:ELServerManagerStartDateUserInfoKey];
    NSDate *loadedCurrenciesDate = [userInfo valueForKey:ELServerManagerCurrencyDateUserInfoKey];
    NSDate *endDate = [userInfo valueForKey:ELServerManagerEndDateUserInfoKey];
    CGFloat fullTimeInterval = [endDate timeIntervalSinceDate:startDate];
    CGFloat currentTimeInterval = [loadedCurrenciesDate timeIntervalSinceDate:startDate];
    CGFloat progress = currentTimeInterval / fullTimeInterval;
    
    if (self.progressView.progress >= progress) {
        return;
    }
    
    [self.progressView setProgress:progress];
}

@end
