//
//  MCKillSwitchInfoButton.m
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchInfoButton.h"

@implementation MCKillSwitchInfoButton

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"label"];
        _urlPath = dictionary[@"url"];
        _type = [MCKillSwitchInfoButton typeForString:dictionary[@"type"]];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

+ (MCKillSwitchInfoButtonType)typeForString:(NSString *)string
{
    MCKillSwitchInfoButtonType type = MCKillSwitchInfoButtonTypeURL;
    
    if ([string isEqualToString:@"url"]) {
        type = MCKillSwitchInfoButtonTypeURL;
    }
    else if ([string isEqualToString:@"cancel"]) {
        type = MCKillSwitchInfoButtonTypeCancel;
    }
    
    return type;
}

+ (NSString *)stringForType:(MCKillSwitchInfoButtonType)type
{
    switch (type) {
        case MCKillSwitchInfoButtonTypeURL:
            return @"URL";
        case MCKillSwitchInfoButtonTypeCancel:
            return @"Cancel";
    }
}

@end
