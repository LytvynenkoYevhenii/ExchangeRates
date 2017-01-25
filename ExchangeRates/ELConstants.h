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

extern NSString * const kELManuallyDataBase;
