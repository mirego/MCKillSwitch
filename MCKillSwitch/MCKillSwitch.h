//
// Copyright (c) 2015, Mirego
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// - Neither the name of the Mirego nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import "MCKillSwitchDynamicAPI.h"
#import "MCKillSwitchInfo.h"

extern NSString * const kMCKillSwitchInfo;
extern NSString * const kMCKillSwitchInfoVersion;
extern NSString * const kMCKillDefaultAPIKeyParameterName;

@protocol MCKillSwitchDelegate;

@interface MCKillSwitch : NSObject <MCKillSwitchAPIDelegate>

@property (nonatomic, weak) id<MCKillSwitchDelegate> delegate;
@property (nonatomic) NSDictionary *parameters;
@property (nonatomic) BOOL executeOnAppDidBecomeActive; // default NO
@property (nonatomic, readonly, getter = isExecuting) BOOL executing;

- (instancetype)initWithBaseURL:(NSURL *)baseURL;
- (instancetype)initWithAPI:(id<MCKillSwitchAPI>)killSwitchAPI;

- (void)execute;

- (void)prepareToShowInfo:(id<MCKillSwitchInfo>)info;

+ (void)clearSavedInfo;

+ (void)configureStaticJSONFileKillSwitchWithURL:(NSURL *)url;
+ (void)configureDefaultKillSwitchWithAPIKey:(NSString *)APIkey;
+ (void)configureKillSwitchWithCustomURL:(NSURL *)url parameters:(NSDictionary *)parameters;
@end


@protocol MCKillSwitchDelegate <NSObject>

- (void)killSwitch:(MCKillSwitch *)killSwitch shouldShowKillSwitchInfo:(id<MCKillSwitchInfo>)info;
- (void)killSwitch:(MCKillSwitch *)killSwitch didNotNeedToShowKillSwitchInfo:(id<MCKillSwitchInfo>)info;
@end
