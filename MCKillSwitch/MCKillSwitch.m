//
//  MCKillSwitch.m
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitch.h"

NSString * const kMCKillSwitchInfo = @"com.mirego.killswitch.info";
NSString * const kMCKillSwitchInfoVersion = @"com.mirego.killswitch.info.version";

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitch ()

@property (nonatomic, strong) MCKillSwitchAPI *killSwitchAPI;

@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitch

- (id)init
{
    return [self initWithBaseURL:nil];
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
    return [self initWithBaseURL:baseURL andAPI:nil];
}

- (id)initWithBaseURL:(NSURL *)baseURL andAPI:(MCKillSwitchAPI *)killSwitchAPI
{
    self = [super init];
    if (self) {
        if (!baseURL) {
            NSLog(@"MCKillSwitch: Base URL not set");
        }
        
        _killSwitchAPI = killSwitchAPI ? killSwitchAPI : [[MCKillSwitchAPI alloc] initWithBaseURL:baseURL];
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
        }
        else {
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
        if ([_delegate respondsToSelector:@selector(killSwitch:shouldShowKillSwitchInfo:)]) {
            [_delegate killSwitch:self shouldShowKillSwitchInfo:ksInfo];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(killSwitch:didNotNeedToShowKillSwitchInfo:)]) {
            [_delegate killSwitch:self didNotNeedToShowKillSwitchInfo:ksInfo];
        }
    }
}

+ (void)clearSavedInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kMCKillSwitchInfo];
    [userDefaults removeObjectForKey:kMCKillSwitchInfoVersion];
    [userDefaults synchronize];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (NSString *)applicationVersion
{
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    return version;
}

- (void)saveInfo:(NSDictionary *)info
{
    if (info) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:info forKey:kMCKillSwitchInfo];
        [userDefaults setObject:[self applicationVersion] forKey:kMCKillSwitchInfoVersion];
        [userDefaults synchronize];
    }
    else {
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

- (void)killSwitchAPI:(MCKillSwitchAPI *)killSwitchAPI didLoadInfoDictionary:(NSDictionary *)infoDictionary
{
    NSLog(@"MCKillSwitch: Success loading info");
    
    [self saveInfo:infoDictionary];
    [self prepareToShowInfo:infoDictionary];
}

- (void)killSwitchAPI:(MCKillSwitchAPI *)killSwitchAPI didFailWithError:(NSError *)error
{
    NSLog(@"MCKillSwitch: Error loading info\n%@", error);
    
    NSDictionary *lastSavedInfo = [self lastSavedInfo];
    
    if (lastSavedInfo) {
        [self prepareToShowInfo:lastSavedInfo];
    }
    else {
        [self prepareToShowInfo:nil];
    }
}

@end
