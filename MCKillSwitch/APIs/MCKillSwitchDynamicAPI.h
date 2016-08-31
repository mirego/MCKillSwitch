//
// Copyright (c) 2016, Mirego
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
#import "MCKillSwitchAPI.h"

extern NSString * const kMCKillSwitchAPIPath;
extern NSString * const kMCKillSwitchAPILanguage;
extern NSString * const kMCKillSwitchAPIUserAgent;
extern NSString * const kMCKillSwitchAPIAppVersion;
extern NSString * const kMCKillSwitchAPIPlatform;
extern NSString * const kMCKillSwitchAPIDefaultAPIBaseURL;

@protocol MCKillSwitchAPIDelegate;

@interface MCKillSwitchDynamicAPI : NSObject <MCKillSwitchAPI, NSURLConnectionDataDelegate>

+ (MCKillSwitchDynamicAPI *)defaultURLKillSwitchDynamicAPI;
+ (MCKillSwitchDynamicAPI *)killSwitchDynamicAPIWithCustomURL:(NSURL *)url;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBaseURL:(NSURL *)baseURL;
- (instancetype)initWithBaseURL:(NSURL *)url URLIsStatic:(BOOL)URLIsStatic NS_DESIGNATED_INITIALIZER;
- (void)successWithInfoDictionary:(NSDictionary *)infoDictionary;
- (void)failWithError:(NSError *)error;
@end
