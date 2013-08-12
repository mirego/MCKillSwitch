//
//  MCKillSwitchExampleTests.m
//  MCKillSwitchExampleTests
//
//  Created by Stéphanie Paquet on 2013-05-10.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchExampleTests.h"
#import "MCKillSwitch.h"
#import "MCMockKillSwitchAPIOK.h"
#import "MCMockKillSwitchAPIAlert.h"
#import "MCMockKillSwitchAPIKill.h"
#import "MCMockKillSwitchAPINoInternet.h"

@interface MCKillSwitchExampleTests () <MCKillSwitchDelegate>

@end

@implementation MCKillSwitchExampleTests

- (void)setUp
{
    MCKillSwitch *killSwitch = [[MCKillSwitch alloc] init];
    STAssertNotNil(killSwitch, @"Could not create test subject.");
}

- (void)tearDown
{
    [MCKillSwitch clearSavedInfo];
}

- (void)testKillSwitchAPIOk
{
    MCKillSwitch *ks = [self killSwitchActionOK];
    [ks execute];
    
    [self basesTestsForKillSwitch:ks];
}

- (void)testKillSwitchAPIAlert
{
    MCKillSwitch *ks = [self killSwitchActionAlert];
    [ks execute];
    
    [self basesTestsForKillSwitch:ks];
}

- (void)testKillSwitchAPIKill
{
    MCKillSwitch *ks = [self killSwitchActionKill];
    [ks execute];
    
    [self basesTestsForKillSwitch:ks];
}

- (void)testKillSwitchAPINoInternet
{
    MCKillSwitch *ks = [self killSwitchNoInternet];
    [ks execute];
    
    [self basesTestsForKillSwitch:ks];
}

- (void)testKillSwitchNoInternetAfterOkInfo
{
    MCKillSwitch *ksOk = [self killSwitchActionOK];
    [ksOk execute];
    
    MCKillSwitch *ksNoInternet = [self killSwitchNoInternet];
    [ksNoInternet execute];
}

- (void)testKillSwitchNoInternetAfterAlertInfo
{
    MCKillSwitch *ksAlert = [self killSwitchActionAlert];
    [ksAlert execute];
    
    MCKillSwitch *ksNoInternet = [self killSwitchNoInternet];
    [ksNoInternet execute];
}

- (void)testKillSwitchNoInternetAfterKillInfo
{
    MCKillSwitch *ksKill = [self killSwitchActionKill];
    [ksKill execute];
    
    MCKillSwitch *ksNoInternet = [self killSwitchNoInternet];
    [ksNoInternet execute];
}

//------------------------------------------------------------------------------
#pragma mark - Helper methods
//------------------------------------------------------------------------------

- (MCKillSwitch *)killSwitchWithAPIClass:(Class)apiClass
{
    MCKillSwitch *killSwitch = nil;
    BOOL isAPIKillSwitchClass = [apiClass isSubclassOfClass:[MCKillSwitchAPI class]];
    
    if (isAPIKillSwitchClass) {
        killSwitch = [[MCKillSwitch alloc] initWithAPI:[[apiClass alloc] init]];
        killSwitch.delegate = self;
    }
    else {
        STAssertTrue(isAPIKillSwitchClass, @"Attempt to create a kill switch with a non MCKillSwithAPI class.");
    }
    
    return killSwitch;
}

- (MCKillSwitch *)killSwitchActionOK
{
    return [self killSwitchWithAPIClass:[MCMockKillSwitchAPIOK class]];
}

- (MCKillSwitch *)killSwitchActionAlert
{
    return [self killSwitchWithAPIClass:[MCMockKillSwitchAPIAlert class]];
}

- (MCKillSwitch *)killSwitchActionKill
{
    return [self killSwitchWithAPIClass:[MCMockKillSwitchAPIKill class]];
}

- (MCKillSwitch *)killSwitchNoInternet
{
    return [self killSwitchWithAPIClass:[MCMockKillSwitchAPINoInternet class]];
}

- (void)basesTestsForKillSwitch:(MCKillSwitch *)killSwitch
{
    NSString *versionParam = killSwitch.parameters[kMCKillSwitchAPIAppVersion];
    BOOL versionIsString = [versionParam isKindOfClass:[NSString class]];
    
    STAssertNotNil(killSwitch, @"Could not create kill switch object.");
    STAssertNotNil(versionParam, @"Version parameter not set.");
    STAssertTrue(versionIsString, @"Version parameter not a string.");
}

//------------------------------------------------------------------------------
#pragma mark - MCKillSwitchDelegate methods
//------------------------------------------------------------------------------

- (void)killSwitch:(MCKillSwitch *)killSwitch shouldShowKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo
{
    NSLog(@"killSwitch:shouldShowKillSwitchInfo:\n%@", killSwitchInfo);
    
    BOOL validDisplayDirective = killSwitchInfo.action != MCKillSwitchActionOK && killSwitchInfo.message && killSwitchInfo.message.length > 0;
    NSDictionary *savedInfoDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kMCKillSwitchInfo];
    NSString *savedInfoVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kMCKillSwitchInfoVersion];
    NSString *versionParam = killSwitch.parameters[kMCKillSwitchAPIAppVersion];
    BOOL versionMatches = [savedInfoVersion isEqualToString:versionParam];
    
    STAssertNotNil(killSwitchInfo, @"Could not get kill switch info.");
    STAssertTrue(validDisplayDirective, @"The kill switch info should not be shown.");
    STAssertNotNil(savedInfoDictionary, @"Did not saved info in the user defaults.");
    STAssertNotNil(savedInfoVersion, @"Did not saved the version related to the info in the user defaults.");
    STAssertTrue(versionMatches, @"Version saved in the user defaults doesn’t match the version in the parameters.");
}

- (void)killSwitch:(MCKillSwitch *)killSwitch didNotNeedToShowKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo
{
    NSLog(@"killSwitch:didNotNeedToShowKillSwitchInfo:\n%@", killSwitchInfo);
    
    BOOL validDisplayDirective = killSwitchInfo.action == MCKillSwitchActionOK || !killSwitchInfo.message || killSwitchInfo.message.length == 0;
    
    STAssertTrue(validDisplayDirective, @"The kill switch info should have been shown.");
}


@end
