//
//  MCKillSwitchAPI.h
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMCKillSwitchAPIPath;
extern NSString * const kMCKillSwitchAPILanguage;
extern NSString * const kMCKillSwitchAPIUserAgent;
extern NSString * const kMCKillSwitchAPIAppVersion;
extern NSString * const kMCKillSwitchAPIPlatform;

@protocol MCKillSwitchAPIDelegate;

@interface MCKillSwitchAPI : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <MCKillSwitchAPIDelegate> delegate;

- (id)initWithBaseURL:(NSURL *)baseURL;

- (void)start;
- (void)startWithParameters:(NSDictionary *)parameters;
- (void)cancel;

- (void)successWithInfoDictionary:(NSDictionary *)infoDictionary;
- (void)failWithError:(NSError *)error;

@end


@protocol MCKillSwitchAPIDelegate <NSObject>

- (void)killSwitchAPI:(MCKillSwitchAPI *)killSwitchAPI didLoadInfoDictionary:(NSDictionary *)infoDictionary;
- (void)killSwitchAPI:(MCKillSwitchAPI *)killSwitchAPI didFailWithError:(NSError *)error;

@end