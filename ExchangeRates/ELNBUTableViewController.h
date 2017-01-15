//
//  ELSecondSectorTableViewController.h
//  CurrenciesApp
//
//  Created by Lytvynenko Yevhenii on 11.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ELNBUBankFullName;
extern NSString * const ELNBUBankShortName;

@interface ELNBUTableViewController : UITableViewController 
- (void)selectRowWithCurrency:(NSString *)code;
@end
