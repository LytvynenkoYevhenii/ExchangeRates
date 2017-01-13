//
//  ViewController.m
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 10.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELMainCurrenciesViewController.h"
#import "ELBankNameView.h"
//#import "ELUtils.h"

@interface ELMainCurrenciesViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet ELBankNameView *privatBankActivityView;
@property (weak, nonatomic) IBOutlet ELBankNameView *nbuActivityView;

@end

@implementation ELMainCurrenciesViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
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

@end
