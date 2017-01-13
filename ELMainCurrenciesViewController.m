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

#import "ELCurrency+CoreDataProperties.h"
#import "ELBank+CoreDataProperties.h"
//#import "ELUtils.h"

@interface ELMainCurrenciesViewController ()<ELPrivatBankViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet ELBankNameView *privatBankActivityView;
@property (weak, nonatomic) IBOutlet ELBankNameView *nbuActivityView;

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
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
   
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
    
    //Add date picker view
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observing

- (void)orientationChanged:(NSNotification *)notification
{
    if ([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortrait) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
    } else {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
    }
}

#pragma mark - <ELPrivatBankViewControllerDelegate>

- (void) privatBankViewController:(ELPrivatBankViewController *)privatBankViewController didSelectCurrencyWithCode:(NSString *)currency
{
    [self.nbuViewController selectRowWithCurrency:currency];
}

- (void)addTestCurrencies
{
    NSArray *currencyCodes = @[@"USD", @"EUR", @"RUR", @"CHF", @"GBP", @"PLZ", @"SEC", @"XAU", @"CAD"];
    NSArray *bankNames = @[privatBankName, nbuBankName];
    
    for (NSString *bankName in bankNames) {
        ELBank *bank = [ELBank MR_createEntity];
        bank.name = bankName;
        
        for (NSString *key in currencyCodes) {
            ELCurrency *currency = [ELCurrency MR_createEntity];
            
            currency.code = key;
            currency.saleRate = arc4random() % 40001 /1000.f + 10.f; //10.f...50.f
            currency.purchaseRate = currency.saleRate * ((arc4random() % 21) / 100.f + 0.8f); //0.8...1.0
            currency.bank = bank;
        }
    }
    
    NSError *error = nil;
    
    [[NSManagedObjectContext MR_defaultContext] save:&error];
    
    if (error) {
        NSLog(@"Error with saving context = %@", [error localizedDescription]);
    }
}

#pragma mark - Actions

- (void)actionChangeDateForNBU:(UIButton *)sender
{
    
}

- (void)actionChangeDateForPrivatBank:(UIButton *)sender
{
    
}

@end
