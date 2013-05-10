//
//  MCKillSwitchInfoButton.h
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MCKillSwitchInfoButtonType) {
    MCKillSwitchInfoButtonTypeURL,
    MCKillSwitchInfoButtonTypeCancel
};

@interface MCKillSwitchInfoButton : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *urlPath;
@property (nonatomic, readonly) MCKillSwitchInfoButtonType type;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
