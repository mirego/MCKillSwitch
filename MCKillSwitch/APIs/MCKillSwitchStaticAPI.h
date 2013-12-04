//
//  MCKillSwitchStaticAPI
//  MCKillSwitchExample
//
//  Created by mlefrancois on 2013-08-12
//  Copyright (c) 2013 Mirego Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MCKillSwitchDynamicAPI.h"

@interface MCKillSwitchStaticAPI : MCKillSwitchDynamicAPI
+ (MCKillSwitchStaticAPI *)staticJSONFileKillSwitchDynamicAPIWithURL:(NSURL *)url;
@end