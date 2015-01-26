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

#import "MCKillSwitchInfo.h"

@implementation MCKillSwitchInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _action = [MCKillSwitchInfo actionForString:dictionary[@"action"]];
        _message = dictionary[@"message"];
        
        NSArray *rawButtons = dictionary[@"buttons"];
        NSMutableArray *finalButtons = [NSMutableArray new];
        
        for (NSDictionary *dictButton in rawButtons) {
            MCKillSwitchInfoButton *objButton = [[MCKillSwitchInfoButton alloc] initWithDictionary:dictButton];
            [finalButtons addObject:objButton];
        }
        
        _buttons = finalButtons.count > 0 ? [[NSArray alloc] initWithArray:finalButtons] : nil;
    }
    
    return self;
}

- (NSString *)description
{
    NSString *strAction = [NSString stringWithFormat:@"Action: %@", [MCKillSwitchInfo stringForAction:_action]];
    NSString *strMessage = [NSString stringWithFormat:@"Message: %@", _message];
    NSMutableString *strButtons = [NSMutableString stringWithString:@"Buttons: "];
    
    if (_buttons) {
        for (MCKillSwitchInfoButton *btn in _buttons) {
            [strButtons appendString:[NSString stringWithFormat:@"\n    • Title: %@ -> URL: %@", btn.title, btn.urlPath]];
        }
    }
    
    return [NSMutableString stringWithFormat:@"%@\n%@\n%@", strAction, strMessage, strButtons];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

+ (MCKillSwitchAction)actionForString:(NSString *)string
{
    MCKillSwitchAction action = MCKillSwitchActionOK;
    
    if ([string isEqualToString:@"kill"]) {
        action = MCKillSwitchActionKill;
    } else if ([string isEqualToString:@"alert"]) {
        action = MCKillSwitchActionAlert;
    } else if ([string isEqualToString:@"ok"]) {
        action = MCKillSwitchActionOK;
    }
    
    return action;
}

+ (NSString *)stringForAction:(MCKillSwitchAction)action
{
    switch (action) {
        case MCKillSwitchActionOK:
            return @"OK";
        case MCKillSwitchActionAlert:
            return @"Alert";
        case MCKillSwitchActionKill:
            return @"Kill";
    }
}

//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------

- (MCKillSwitchInfoButton *)cancelButton
{
    MCKillSwitchInfoButton *cancelButton = nil;
    
    for (MCKillSwitchInfoButton *button in _buttons) {
        if (button.type == MCKillSwitchInfoButtonTypeCancel) {
            cancelButton = button;
            break;
        }
    }
    
    return cancelButton;
}

- (NSArray *)urlButtons
{
    NSMutableArray *urlButtons = [NSMutableArray new];
    
    for (MCKillSwitchInfoButton *button in _buttons) {
        if (button.type == MCKillSwitchInfoButtonTypeURL) {
            [urlButtons addObject:button];
        }
    }
    
    return urlButtons.count > 0 ? [[NSArray alloc] initWithArray:urlButtons] : nil;
}

- (NSArray *)orderedButtons
{
    NSMutableArray *orderedButtons = [NSMutableArray new];
    
    MCKillSwitchInfoButton *cancelButton = [self cancelButton];
    NSArray *urlButtons = [self urlButtons];
    
    if (cancelButton) {
        [orderedButtons addObject:cancelButton];
    }
    if (urlButtons) {
        [orderedButtons addObjectsFromArray:urlButtons];
    }
    
    return orderedButtons.count > 0 ? [[NSArray alloc] initWithArray:urlButtons] : nil;
}

@end
