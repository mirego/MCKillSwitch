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

- (instancetype)initWithBaseURL:(NSURL *)baseURL  orAPI:(id<MCKillSwitchAPI>)killSwitchAPI {
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
    
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:_parameters];
    [finalParams setObject:[self applicationVersion] forKey:kMCKillSwitchAPIAppVersion];

    _parameters = finalParams;
    
    [_killSwitchAPI startWithParameters:finalParams];
}

- (void)prepareToShowInfo:(NSDictionary *)info
{
    _executing = NO;
    
    MCKillSwitchInfo *ksInfo = [[MCKillSwitchInfo alloc] initWithDictionary:info];
    BOOL shouldShow = info && (ksInfo.action != MCKillSwitchActionOK);
    
    if (shouldShow) {
        [_delegate killSwitch:self shouldShowKillSwitchInfo:ksInfo];
    } else {
        [_delegate killSwitch:self didNotNeedToShowKillSwitchInfo:ksInfo];
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

- (NSString *)applicationVersion
{
    NSString *version = @"1.0";
    if ([[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]) {
        version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    }
    
    return version;
}

- (void)saveInfo:(NSDictionary *)info
{
    if (info) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:info forKey:kMCKillSwitchInfo];
        [userDefaults setObject:[self applicationVersion] forKey:kMCKillSwitchInfoVersion];
        [userDefaults synchronize];
        
    } else {
        [MCKillSwitch clearSavedInfo];
    }
}

- (NSDictionary *)lastSavedInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *info = [userDefaults objectForKey:kMCKillSwitchInfo];
    NSString *infoVersion = [userDefaults objectForKey:kMCKillSwitchInfoVersion];
    
    if (info) {
        BOOL versionMatchesCurrent = infoVersion && [infoVersion isEqualToString:[self applicationVersion]];
        
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

- (void)killSwitchAPI:(MCKillSwitchDynamicAPI *)killSwitchAPI didLoadInfoDictionary:(NSDictionary *)infoDictionary
{
    NSLog(@"MCKillSwitch: Success loading info: %@", infoDictionary);
    
    [self saveInfo:infoDictionary];
    [self prepareToShowInfo:infoDictionary];
}

- (void)killSwitchAPI:(MCKillSwitchDynamicAPI *)killSwitchAPI didFailWithError:(NSError *)error
{
    NSLog(@"MCKillSwitch: Error loading info\n%@", error);
    
    NSDictionary *lastSavedInfo = [self lastSavedInfo];
    
    if (lastSavedInfo) {
        [self prepareToShowInfo:lastSavedInfo];
    } else {
        [self prepareToShowInfo:nil];
    }
}

@end
