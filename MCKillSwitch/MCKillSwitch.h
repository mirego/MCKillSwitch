//
//  MCKillSwitch.h
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKillSwitchDynamicAPI.h"
#import "MCKillSwitchInfo.h"

extern NSString * const kMCKillSwitchInfo;
extern NSString * const kMCKillSwitchInfoVersion;

@protocol MCKillSwitchDelegate;

@interface MCKillSwitch : NSObject <MCKillSwitchAPIDelegate>

@property (nonatomic, weak) id <MCKillSwitchDelegate> delegate;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) BOOL executeOnAppDidBecomeActive; // default NO
@property (nonatomic, readonly, getter = isExecuting) BOOL executing;

- (id)initWithBaseURL:(NSURL *)baseURL;
- (id)initWithAPI:(id<MCKillSwitchAPI>)killSwitchAPI;

- (void)execute;

- (void)prepareToShowInfo:(NSDictionary *)info;

+ (void)clearSavedInfo;

+ (void)configureStaticKillSwitchWithURL:(NSString *)urlString;
@end


@protocol MCKillSwitchDelegate <NSObject>

- (void)killSwitch:(MCKillSwitch *)killSwitch shouldShowKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo;
- (void)killSwitch:(MCKillSwitch *)killSwitch didNotNeedToShowKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo;

@end