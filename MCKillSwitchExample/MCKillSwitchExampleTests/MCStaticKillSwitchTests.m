//
//  MCStaticKillSwitchTests.m
//  MCKillSwitchExample
//
//  Created by Marc Lefrancois on 2013-08-09.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCStaticKillSwitchTests.h"
#import "MCKillSwitch.h"
#import "MCMockKillSwitchAPIDisk.h"

@implementation MCStaticKillSwitchTests

- (void)setUp
{
    MCKillSwitch *killSwitch = [[MCKillSwitch alloc] initWithAPI:[[MCMockKillSwitchAPIDisk alloc] init]];
    STAssertNotNil(killSwitch, @"Could not create test subject.");
}



@end
