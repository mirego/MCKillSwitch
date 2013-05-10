//
//  MCKillSwitchInfo.h
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKillSwitchInfoButton.h"

typedef NS_ENUM(NSInteger, MCKillSwitchAction) {
    MCKillSwitchActionOK,
    MCKillSwitchActionAlert,
    MCKillSwitchActionKill
};

@interface MCKillSwitchInfo : NSObject

@property (nonatomic, readonly) MCKillSwitchAction action;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSArray *buttons;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (MCKillSwitchInfoButton *)cancelButton;
- (NSArray *)urlButtons;
- (NSArray *)orderedButtons;

@end
