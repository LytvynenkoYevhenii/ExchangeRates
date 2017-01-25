//
//  ELAppStartConfigurator.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 17.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELAppStartConfigurator.h"
#import "ELParser.h"
#import "ELServerManager.h"

#import "ELCurrency+CoreDataProperties.h"

@implementation ELAppStartConfigurator

#pragma mark - Public methods

- (void)configureApp
{
    //Nav bar style
    [[UINavigationBar appearance] setTitleTextAttributes:[ELTheme textAttributesForNavigationBarTitle]];

    //CoreData setup
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    //if data base is not empty than just return
    if ([ELCurrency MR_findFirst]) {
        return;
    }
    
    //If device is connected to the network than data for past year will be fetched from server, otherwise data for 01.01.2013 will be created locally
    if (![[ELServerManager sharedManager] connected]) {
        [self createCurrenciesManually];
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"ELManuallyDataBaseKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - Private methods

- (void)createCurrenciesManually
{
    //Parse currencies from local saved template JSON to default context
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ResponseData_01.12.2014" ofType:@"json"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSData *responseData = [content dataUsingEncoding:NSUTF8StringEncoding];

    [[ELParser  sharedInstance] parseCurrenciesFromAPIWithType:ELApiTypePrivatBankArchive responseData:responseData
                                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
}

@end
