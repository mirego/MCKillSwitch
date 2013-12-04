//
//  MCKillSwitchStaticAPI
//  MCKillSwitchExample
//
//  Created by mlefrancois on 2013-08-12
//  Copyright (c) 2013 Mirego Inc. All rights reserved.
//


#import "MCKillSwitchStaticAPI.h"

//------------------------------------------------------------------------------
#pragma mark MCKillSwitchStaticAPI (privates methods)
//------------------------------------------------------------------------------
@interface MCKillSwitchStaticAPI ()
@end

//------------------------------------------------------------------------------
#pragma mark MCKillSwitchStaticAPI implementation
//------------------------------------------------------------------------------
@implementation MCKillSwitchStaticAPI
@synthesize delegate;

//------------------------------------------------------------------------------
#pragma mark constructors and destructor
//------------------------------------------------------------------------------

+ (MCKillSwitchStaticAPI *)staticJSONFileKillSwitchDynamicAPIWithURL:(NSURL *)url
{
    MCKillSwitchStaticAPI *killSwitchStaticAPI = [[MCKillSwitchStaticAPI alloc] initWithBaseURL:url];
    return killSwitchStaticAPI;
}

- (id)initWithBaseURL:(NSURL *)baseURL
{
    return [super initWithBaseURL:baseURL URLIsStatic:YES];
}

//------------------------------------------------------------------------------
#pragma mark public methods
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
#pragma mark private methods
//------------------------------------------------------------------------------

@end