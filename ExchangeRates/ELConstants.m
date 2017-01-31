//
//  ELConstants.m
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 19.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import "ELConstants.h"

NSString * const ELPrivatBankFullName               = @"PrivatBank";
NSString * const ELPrivatBankShortName              = @"PB";
NSString * const ELNBUBankFullName                  = @"National Bank";
NSString * const ELNBUBankShortName                 = @"NBU";
NSString * const ELPrivatBankArchiveTemplateName    = @"ResponseData_01.12.2014.json";
NSString * const ELMainStoryboardName               = @"Main";
NSString * const ELStandardDateFormat               = @"dd.MM.yyyy";
NSString * const ELNbuApiDateFormat                 = @"YYYYMMdd";
NSString * const ELTemplateJSONDate                 = @"01.12.2014";

//Global keys
NSString * const kELManuallyDataBase                = @"ELManuallyDataBaseKey";

//Notifications
NSString* const ELServerManagerCurrenciesDidLoadNotification = @"ELServerManagerCurrenciesDidLoadNotification";

//Notification user info keys
NSString* const ELServerManagerCurrencyDateUserInfoKey = @"ELServerManagerCurrencyDateUserInfoKey";
NSString* const ELServerManagerStartDateUserInfoKey = @"ELServerManagerStartDateUserInfoKey";
NSString* const ELServerManagerEndDateUserInfoKey = @"ELServerManagerEndDateUserInfoKey";
NSString* const ELServerManagerCurrencyBankNameInfoKey = @"ELServerManagerCurrencyBankNameInfoKey";
