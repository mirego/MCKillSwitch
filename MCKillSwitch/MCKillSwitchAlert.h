//
//  MCKillSwitchAlert.h
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKillSwitch.h"

@protocol MCKillSwitchAlertDelegate;

@interface MCKillSwitchAlert : NSObject <UIAlertViewDelegate, MCKillSwitchDelegate>

@property (nonatomic, weak) id <MCKillSwitchAlertDelegate> delegate;
@property (nonatomic, readonly, getter = isShowing) BOOL showing;

- (void)showAlertForKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo;
- (void)hideAlert;

- (BOOL)shouldHideAlertAfterButtonAction;

@end


@protocol MCKillSwitchAlertDelegate <NSObject>

- (void)killSwitchAlertDidShow:(MCKillSwitchAlert *)killSwitchAlert;
- (void)killSwitchAlertDidHide:(MCKillSwitchAlert *)killSwitchAlert;

@end