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

#import "MCKillSwitch.h"
#import "MCKillSwitchStaticAPI.h"
#import "MCKillSwitchAlert.h"

#import "MCKillSwitchDictionaryInfo.h"

NSString * const kMCKillSwitchInfo = @"com.mirego.killswitch.info";
NSString * const kMCKillSwitchInfoVersion = @"com.mirego.killswitch.info.version";
NSString * const kMCKillDefaultAPIKeyParameterName = @"key";

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitch ()

@property (nonatomic, readonly) id<MCKillSwitchAPI> killSwitchAPI;
@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitch

- (instancetype)init
{
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    return [self initWithBaseURL:baseURL orAPI:nil];
}

- (instancetype)initWithAPI:(id<MCKillSwitchAPI>)killSwitchAPI
{
    return [self initWithBaseURL:nil orAPI:killSwitchAPI];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL orAPI:(id<MCKillSwitchAPI>)killSwitchAPI {
    self = [super init];
    if (self) {
        _killSwitchAPI = killSwitchAPI ? killSwitchAPI : [[MCKillSwitchDynamicAPI alloc] initWithBaseURL:baseURL];
        _killSwitchAPI.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _killSwitchAPI.delegate = nil;
}

//------------------------------------------------------------------------------
#pragma mark - Setters methods
//------------------------------------------------------------------------------

- (void)setExecuteOnAppDidBecomeActive:(BOOL)executeOnAppDidBecomeActive
{
    BOOL stateHasChanged = _executeOnAppDidBecomeActive != executeOnAppDidBecomeActive;
    
    _executeOnAppDidBecomeActive = executeOnAppDidBecomeActive;
    
    if (stateHasChanged) {
        if (executeOnAppDidBecomeActive) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute) name:UIApplicationDidBecomeActiveNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        }
    }
}

//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------

- (void)execute
{
    _executing = YES;
    
    // Add application version to the parameters
    NSMutableDictionary *parametersCopy = [[NSMutableDictionary alloc] initWithDictionary:self.parameters];
    parametersCopy[kMCKillSwitchAPIAppVersion] = [MCKillSwitch applicationVersion];
    _parameters = [[NSDictionary alloc] initWithDictionary:parametersCopy];
    
    [_killSwitchAPI startWithParameters:self.parameters];
}

- (void)prepareToShowInfo:(id<MCKillSwitchInfo>)info
{
    _executing = NO;
    
    BOOL shouldShowInfo = info && (info.action != MCKillSwitchActionOK);
    if (shouldShowInfo) {
        [self.delegate killSwitch:self shouldShowKillSwitchInfo:info];
    } else {
        [self.delegate killSwitch:self didNotNeedToShowKillSwitchInfo:info];
    }
}

+ (void)clearSavedInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kMCKillSwitchInfo];
    [userDefaults removeObjectForKey:kMCKillSwitchInfoVersion];
    [userDefaults synchronize];
}

+ (void)configureStaticJSONFileKillSwitchWithURL:(NSURL *)url
{
    static MCKillSwitchAlert *killSwitchAlert;
    killSwitchAlert = [[MCKillSwitchAlert alloc] init];
    
    static MCKillSwitch *killSwitch;
    killSwitch = [[MCKillSwitch alloc] initWithAPI:[MCKillSwitchStaticAPI staticJSONFileKillSwitchDynamicAPIWithURL:url]];
    killSwitch.executeOnAppDidBecomeActive = YES;
    killSwitch.delegate = killSwitchAlert;
}

+ (void)configureDefaultKillSwitchWithAPIKey:(NSString *)APIkey
{
    static MCKillSwitchAlert *killSwitchAlert;
    killSwitchAlert = [[MCKillSwitchAlert alloc] init];
    
    static MCKillSwitch *killSwitch;
    killSwitch = [[MCKillSwitch alloc] initWithAPI:[MCKillSwitchDynamicAPI defaultURLKillSwitchDynamicAPI]];
    killSwitch.executeOnAppDidBecomeActive = YES;
    killSwitch.delegate = killSwitchAlert;
    killSwitch.parameters = @{ kMCKillDefaultAPIKeyParameterName: APIkey };
}

+ (void)configureKillSwitchWithCustomURL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    static MCKillSwitchAlert *killSwitchAlert;
    killSwitchAlert = [[MCKillSwitchAlert alloc] init];
    
    static MCKillSwitch *killSwitch;
    killSwitch = [[MCKillSwitch alloc] initWithAPI:[MCKillSwitchDynamicAPI killSwitchDynamicAPIWithCustomURL:url]];
    killSwitch.executeOnAppDidBecomeActive = YES;
    killSwitch.delegate = killSwitchAlert;
    killSwitch.parameters = parameters;
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

+ (NSString *)applicationVersion
{
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    if (version == nil) {
        version = @"1.0";
    }

    return version;
}

- (void)saveInfo:(id<MCKillSwitchInfo>)info
{
    if (info) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[MCKillSwitchDictionaryInfo infoDictionaryFromInfo:info] forKey:kMCKillSwitchInfo];
        [userDefaults setObject:[MCKillSwitch applicationVersion] forKey:kMCKillSwitchInfoVersion];
        [userDefaults synchronize];
        
    } else {
        [MCKillSwitch clearSavedInfo];
    }
}

- (id<MCKillSwitchInfo>)lastSavedInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id<MCKillSwitchInfo> info = [MCKillSwitchDictionaryInfo infoFromInfoDictionary:[userDefaults objectForKey:kMCKillSwitchInfo]];
    NSString *infoVersion = [userDefaults objectForKey:kMCKillSwitchInfoVersion];
    
    if (info) {
        BOOL versionMatchesCurrent = infoVersion && [infoVersion isEqualToString:[MCKillSwitch applicationVersion]];
        if (!versionMatchesCurrent) {
            info = nil;
            [MCKillSwitch clearSavedInfo];
        }
    }
    
    return info;
}

//------------------------------------------------------------------------------
#pragma mark - MCKillSwitchAPIDelegate
//------------------------------------------------------------------------------

- (void)killSwitchAPI:(MCKillSwitchDynamicAPI *)killSwitchAPI didLoadInfo:(id<MCKillSwitchInfo>)info
{
#ifdef KILLSWITCH_LOG
    NSLog(@"MCKillSwitch: Success loading info\n%@", [info description]);
#endif     
    [self saveInfo:info];
    [self prepareToShowInfo:info];
}

- (void)killSwitchAPI:(MCKillSwitchDynamicAPI *)killSwitchAPI didFailWithError:(NSError *)error
{
    NSLog(@"MCKillSwitch: Error loading info\n%@", error);
    
    id<MCKillSwitchInfo> lastSavedInfo = [self lastSavedInfo];
    
    if (lastSavedInfo) {
        [self prepareToShowInfo:lastSavedInfo];
    } else {
        [self prepareToShowInfo:nil];
    }
}

@end
