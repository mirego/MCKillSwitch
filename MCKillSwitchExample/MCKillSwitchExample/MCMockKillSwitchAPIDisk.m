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

@property(nonatomic) NSDictionary *parameters;
@end

@implementation MCMockKillSwitchAPIDisk
{

}
- (void)startWithParameters:(NSDictionary *)parameters
{
    self.parameters = [parameters copy];
    [self successWithInfoDictionary:[self expectedDictionary]];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (NSDictionary *)expectedDictionary
{
    NSString *pathJSON = [[NSBundle mainBundle] pathForResource:self.parameters[kMCKillSwitchAPIAppVersion] ofType:@"json"];
    NSData *dataJSON = [NSData dataWithContentsOfFile:pathJSON];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:dataJSON options:NSJSONReadingMutableContainers error:NULL];
    return dictionary;
}
@end