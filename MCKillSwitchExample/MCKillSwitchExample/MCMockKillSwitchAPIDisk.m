//
//  MCMockKillSwitchAPIDisk
//  MCKillSwitchExample
//
//  Created by mlefrancois on 2013-08-09
//  Copyright (c) 2013 Mirego Inc. All rights reserved.
//


#import "MCMockKillSwitchAPIDisk.h"

//------------------------------------------------------------------------------
#pragma mark - MCMockKillSwitchAPIDisk
//------------------------------------------------------------------------------
@interface MCMockKillSwitchAPIDisk ()

@end

@implementation MCMockKillSwitchAPIDisk
{

}
- (void)startWithParameters:(NSDictionary *)parameters
{
    [self successWithInfoDictionary:[self expectedDictionary]];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (NSDictionary *)expectedDictionary
{
    NSString *pathJSON = [[NSBundle mainBundle] pathForResource:@"action_kill" ofType:@"json"];
    NSData *dataJSON = [NSData dataWithContentsOfFile:pathJSON];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingMutableContainers error:NULL];
    return dictionary;
}
@end