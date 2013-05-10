//
//  MCKillSwitchInfo.m
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchInfo.h"

@implementation MCKillSwitchInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _action = [MCKillSwitchInfo actionForString:dictionary[@"action"]];
        _message = dictionary[@"message"];
        
        NSArray *rawButtons = dictionary[@"buttons"];
        NSMutableArray *finalButtons = [NSMutableArray array];
        
        for (NSDictionary *dictButton in rawButtons) {
            MCKillSwitchInfoButton *objButton = [[MCKillSwitchInfoButton alloc] initWithDictionary:dictButton];
            [finalButtons addObject:objButton];
        }
        
        _buttons = finalButtons.count > 0 ? finalButtons : nil;
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
    }
    else if ([string isEqualToString:@"alert"]) {
        action = MCKillSwitchActionAlert;
    }
    else if ([string isEqualToString:@"ok"]) {
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
    NSMutableArray *urlButtons = nil;
    
    for (MCKillSwitchInfoButton *button in _buttons) {
        if (button.type == MCKillSwitchInfoButtonTypeURL) {
            if (!urlButtons) {
                urlButtons = [NSMutableArray array];
            }
            [urlButtons addObject:button];
        }
    }
    
    return urlButtons;
}

- (NSArray *)orderedButtons
{
    NSMutableArray *orderedButtons = [NSMutableArray array];
    MCKillSwitchInfoButton *cancelButton = [self cancelButton];
    NSArray *otherButtons = [self urlButtons];
    
    if (cancelButton) {
        [orderedButtons addObject:cancelButton];
    }
    if (otherButtons) {
        [orderedButtons addObjectsFromArray:otherButtons];
    }
    
    return orderedButtons.count > 0 ? orderedButtons : nil;
}

@end
