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

#import "MCKillSwitchDictionaryInfo.h"
#import "MCKillSwitchDictionaryInfoButton.h"

@implementation MCKillSwitchDictionaryInfo

@synthesize action = _action;
@synthesize message = _message;
@synthesize buttons = _buttons;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _action = [MCKillSwitchDictionaryInfo actionForString:dictionary[@"action"]];
        _message = dictionary[@"message"];
        
        NSArray *rawButtons = dictionary[@"buttons"];
        NSMutableArray *finalButtons = [NSMutableArray new];
        
        for (NSDictionary *dictButton in rawButtons) {
            id<MCKillSwitchInfoButton> objButton = [[MCKillSwitchDictionaryInfoButton alloc] initWithDictionary:dictButton];
            [finalButtons addObject:objButton];
        }
        
        _buttons = finalButtons.count > 0 ? [[NSArray alloc] initWithArray:finalButtons] : nil;
    }
    
    return self;
}

- (NSString *)description
{
    NSString *strAction = [NSString stringWithFormat:@"Action: %@", [MCKillSwitchDictionaryInfo stringForAction:_action]];
    NSString *strMessage = [NSString stringWithFormat:@"Message: %@", _message];
    NSMutableString *strButtons = [NSMutableString stringWithString:@"Buttons: "];
    
    if (_buttons) {
        for (id<MCKillSwitchInfoButton> btn in _buttons) {
            if (btn.type == MCKillSwitchInfoButtonTypeURL) {
                [strButtons appendString:[NSString stringWithFormat:@"\n    • Title: %@ -> URL: %@", btn.title, btn.urlPath]];
            } else {
                [strButtons appendString:[NSString stringWithFormat:@"\n    • Title: %@", btn.title]];
            }
        }
    }
    
    return [NSMutableString stringWithFormat:@"%@\n%@\n%@", strAction, strMessage, strButtons];
}

+ (NSDictionary *)infoDictionaryFromInfo:(id<MCKillSwitchInfo>)info
{
    if (info == nil) {
        return nil;
    }
    
    NSMutableDictionary *infoDictionary = [NSMutableDictionary new];
    
    infoDictionary[@"action"] = [self stringForAction:info.action];
    
    if (info.message != nil) {
        infoDictionary[@"message"] = info.message;
    }

    NSMutableArray *infoDictionaryButtons = [NSMutableArray new];
    for (id<MCKillSwitchInfoButton> infoButton in info.buttons) {
        NSDictionary *infoButtonDictionary = [MCKillSwitchDictionaryInfoButton infoButtonDictionaryFromInfoButton:infoButton];
        if (infoButtonDictionary) {
            [infoDictionaryButtons addObject:infoButtonDictionary];
        }
    }
    if ([infoDictionaryButtons count] > 0) {
        infoDictionary[@"buttons"] = [[NSArray alloc] initWithArray:infoDictionaryButtons];
    }
    
    return infoDictionary.count > 0 ? [[NSDictionary alloc] initWithDictionary:infoDictionary] : nil;
}

+ (id<MCKillSwitchInfo>)infoFromInfoDictionary:(NSDictionary *)infoDictionary
{
    if (infoDictionary == nil) {
        return nil;
    }
    
    return [[MCKillSwitchDictionaryInfo alloc] initWithDictionary:infoDictionary];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

+ (MCKillSwitchAction)actionForString:(NSString *)string
{
    MCKillSwitchAction action = MCKillSwitchActionOK;
    
    if ([string isEqualToString:@"ok"]) {
        action = MCKillSwitchActionOK;
    } else if ([string isEqualToString:@"alert"]) {
        action = MCKillSwitchActionAlert;
    } else if ([string isEqualToString:@"kill"]) {
        action = MCKillSwitchActionKill;
    }
    
    return action;
}

+ (NSString *)stringForAction:(MCKillSwitchAction)action
{
    switch (action) {
        case MCKillSwitchActionOK:
            return @"ok";
        case MCKillSwitchActionAlert:
            return @"alert";
        case MCKillSwitchActionKill:
            return @"kill";
    }
}

@end
