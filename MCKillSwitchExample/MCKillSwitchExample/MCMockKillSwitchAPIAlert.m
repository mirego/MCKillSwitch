//
//  MCMockKillSwitchAPIAlert.m
//  MCKillSwitchExample
//
//  Created by Stéphanie Paquet on 2013-05-10.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCMockKillSwitchAPIAlert.h"

@implementation MCMockKillSwitchAPIAlert

//------------------------------------------------------------------------------
#pragma mark - Overrided methods
//------------------------------------------------------------------------------

- (void)startWithParameters:(NSDictionary *)parameters
{
    [self successWithInfoDictionary:[self expectedDictionary]];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (NSDictionary *)expectedDictionary
{
    NSString *pathJSON = [[NSBundle mainBundle] pathForResource:@"action_alert" ofType:@"json"];
    NSData *dataJSON = [NSData dataWithContentsOfFile:pathJSON];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingMutableContainers error:NULL];
    return dictionary;
}

@end
