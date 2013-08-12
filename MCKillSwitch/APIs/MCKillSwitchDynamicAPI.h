//
//  MCKillSwitchDynamicAPI.h
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCKillSwitchAPI.h"

extern NSString * const kMCKillSwitchAPIPath;
extern NSString * const kMCKillSwitchAPILanguage;
extern NSString * const kMCKillSwitchAPIUserAgent;
extern NSString * const kMCKillSwitchAPIAppVersion;
extern NSString * const kMCKillSwitchAPIPlatform;

@protocol MCKillSwitchAPIDelegate;

@interface MCKillSwitchDynamicAPI : NSObject <MCKillSwitchAPI, NSURLConnectionDataDelegate>
- (id)initWithBaseURL:(NSURL *)baseURL;
- (id)initWithBaseURL:(NSURL *)url URLIsStatic:(BOOL)staticURL;
- (void)successWithInfoDictionary:(NSDictionary *)infoDictionary;
- (void)failWithError:(NSError *)error;
@end
