//
//  ELConstants.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 19.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ELBankTypePrivatBank,
    ELBankTypeNBU
} ELBankType;

typedef enum {
    ELApiTypePrivatBankArchive,
    ELApiTypePrivatBankToday,
    ELApiTypeNBU
} ELApiType;

extern NSString * const ELPrivatBankFullName;
extern NSString * const ELPrivatBankShortName;
extern NSString * const ELNBUBankFullName;
extern NSString * const ELNBUBankShortName;
extern NSString * const ELPrivatBankArchiveTemplateName;
extern NSString * const ELMainStoryboardName;
extern NSString * const ELStandardDateFormat;
extern NSString * const ELNbuApiDateFormat;

//Global keys
extern NSString * const kELManuallyDataBase;

//Notifications
extern NSString* const ELServerManagerCurrenciesDidLoadNotification;

//Notification user info keys
extern NSString* const ELServerManagerCurrencyDateUserInfoKey;
extern NSString* const ELServerManagerStartDateUserInfoKey;
extern NSString* const ELServerManagerEndDateUserInfoKey;
extern NSString* const ELServerManagerCurrencyBankNameInfoKey;
