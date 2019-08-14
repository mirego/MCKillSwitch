//
// Copyright (c) 2013-2019, Mirego
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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MCKillSwitch.h"
#import "MCMockKillSwitchAPIOK.h"
#import "MCMockKillSwitchAPIAlert.h"
#import "MCMockKillSwitchAPIKill.h"
#import "MCMockKillSwitchAPINoInternet.h"
#import "MCMockKillSwitchAPIDisk.h"

@interface MCKillSwitchExampleTests : XCTestCase <MCKillSwitchDelegate>

@end

@implementation MCKillSwitchExampleTests

- (void)setUp
{
    MCKillSwitch *killSwitch = [[MCKillSwitch alloc] init];
    XCTAssertNotNil(killSwitch, @"Could not create test subject.");
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

- (void)testKillSwitchDiskAPI
{
    MCKillSwitch *killSwitch = [self killSwitchDisk];
    
    [killSwitch execute];
    
    [self basesTestsForKillSwitch:killSwitch];
}

//------------------------------------------------------------------------------
#pragma mark - Helper methods
//------------------------------------------------------------------------------

- (MCKillSwitch *)killSwitchWithAPIClass:(Class)apiClass
{
    MCKillSwitch *killSwitch = nil;
    
    BOOL conformsToMCKillSwitchAPIProtocol = [apiClass conformsToProtocol:@protocol(MCKillSwitchAPI)];
    if (conformsToMCKillSwitchAPIProtocol) {
        killSwitch = [[MCKillSwitch alloc] initWithAPI:[[apiClass alloc] init] version:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
        killSwitch.delegate = self;
        
    } else {
        XCTFail(@"Attempt to create a kill switch with a non class not conforming to the MCKillSwithAPI protocol.");
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

- (MCKillSwitch *)killSwitchDisk
{
    return [self killSwitchWithAPIClass:[MCMockKillSwitchAPIDisk class]];
}

- (void)basesTestsForKillSwitch:(MCKillSwitch *)killSwitch
{
    NSString *versionParam = killSwitch.parameters[kMCKillSwitchAPIAppVersion];
    BOOL versionIsString = [versionParam isKindOfClass:[NSString class]];
    
    XCTAssertNotNil(killSwitch, @"Could not create kill switch object.");
    XCTAssertNotNil(versionParam, @"Version parameter not set.");
    XCTAssertTrue(versionIsString, @"Version parameter not a string.");
}

//------------------------------------------------------------------------------
#pragma mark - MCKillSwitchDelegate methods
//------------------------------------------------------------------------------

- (void)killSwitch:(MCKillSwitch *)killSwitch shouldShowKillSwitchInfo:(id<MCKillSwitchInfo>)info
{
    NSLog(@"killSwitch:shouldShowKillSwitchInfo:\n%@", info);
    
    BOOL validDisplayDirective = info.action != MCKillSwitchActionOK && info.message && info.message.length > 0;
    NSDictionary *savedInfoDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kMCKillSwitchInfo];
    NSString *savedInfoVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kMCKillSwitchInfoVersion];
    NSString *versionParam = killSwitch.parameters[kMCKillSwitchAPIAppVersion];
    BOOL versionMatches = [savedInfoVersion isEqualToString:versionParam];
    
    XCTAssertNotNil(info, @"Could not get kill switch info.");
    XCTAssertTrue(validDisplayDirective, @"The kill switch info should not be shown.");
    XCTAssertNotNil(savedInfoDictionary, @"Did not saved info in the user defaults.");
    XCTAssertNotNil(savedInfoVersion, @"Did not saved the version related to the info in the user defaults.");
    XCTAssertTrue(versionMatches, @"Version saved in the user defaults doesn’t match the version in the parameters.");
}

- (void)killSwitch:(MCKillSwitch *)killSwitch didNotNeedToShowKillSwitchInfo:(id<MCKillSwitchInfo>)info
{
    NSLog(@"killSwitch:didNotNeedToShowKillSwitchInfo:\n%@", info);
    
    BOOL validDisplayDirective = info.action == MCKillSwitchActionOK || !info.message || info.message.length == 0;
    
    XCTAssertTrue(validDisplayDirective, @"The kill switch info should have been shown.");
}

@end
