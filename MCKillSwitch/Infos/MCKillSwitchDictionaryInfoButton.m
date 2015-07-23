//
// Copyright (c) 2015, Mirego
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

#import "MCKillSwitchDictionaryInfoButton.h"

@implementation MCKillSwitchDictionaryInfoButton

@synthesize title= _title;
@synthesize urlPath = _urlPath;
@synthesize type = _type;

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"label"];
        _urlPath = dictionary[@"url"];
        _type = [MCKillSwitchDictionaryInfoButton typeForString:dictionary[@"type"]];
    }
    
    return self;
}

+ (NSDictionary *)infoButtonDictionaryFromInfoButton:(id<MCKillSwitchInfoButton>)infoButton
{
    if (infoButton == nil) {
        return nil;
    }
    
    NSMutableDictionary *infoButtonDictionary = [NSMutableDictionary new];
    
    infoButtonDictionary[@"type"] = [self stringForType:infoButton.type];
    
    if (infoButton.title != nil) {
        infoButtonDictionary[@"label"] = infoButton.title;
    }
    
    if (infoButton.type == MCKillSwitchInfoButtonTypeURL) {
        if (infoButton.urlPath != nil) {
            infoButtonDictionary[@"url"] = infoButton.urlPath;
        }
    }
    
    return infoButtonDictionary.count > 0 ? [[NSDictionary alloc] initWithDictionary:infoButtonDictionary] : nil;
}

+ (id<MCKillSwitchInfoButton>)infoButtonFromInfoButtonDictionary:(NSDictionary *)infoButtonDictionary
{
    if (infoButtonDictionary == nil) {
        return nil;
    }
    
    return [[MCKillSwitchDictionaryInfoButton alloc] initWithDictionary:infoButtonDictionary];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

+ (MCKillSwitchInfoButtonType)typeForString:(NSString *)string
{
    MCKillSwitchInfoButtonType type = MCKillSwitchInfoButtonTypeURL;
    
    if ([string isEqualToString:@"url"]) {
        type = MCKillSwitchInfoButtonTypeURL;
    } else if ([string isEqualToString:@"cancel"]) {
        type = MCKillSwitchInfoButtonTypeCancel;
    }
    
    return type;
}

+ (NSString *)stringForType:(MCKillSwitchInfoButtonType)type
{
    switch (type) {
        case MCKillSwitchInfoButtonTypeURL:
            return @"url";
        case MCKillSwitchInfoButtonTypeCancel:
            return @"cancel";
    }
}

@end
