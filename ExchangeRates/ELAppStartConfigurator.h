//
//  ELAppStartConfigurator.h
//  ExchangeRates
//
//  Created by Lytvynenko Yevhenii on 17.01.17.
//  Copyright © 2017 Lytvynenko Yevhenii. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ELAppStartConfiguratorDelegate;

@interface ELAppStartConfigurator : NSObject

@property (weak, nonatomic) id <ELAppStartConfiguratorDelegate> delegate;

- (void)configureApp;

@end


@protocol ELAppStartConfiguratorDelegate

- (void)showMessage;

@end
