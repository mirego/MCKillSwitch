//
//  MCMockKillSwitchAPINoInternet.m
//  MCKillSwitchExample
//
//  Created by Stéphanie Paquet on 2013-05-10.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCMockKillSwitchAPINoInternet.h"

@implementation MCMockKillSwitchAPINoInternet

//------------------------------------------------------------------------------
#pragma mark - Overrided methods
//------------------------------------------------------------------------------

- (void)startWithParameters:(NSDictionary *)parameters
{
    [self failWithError:nil];
}

@end
