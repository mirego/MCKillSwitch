//
//  MCKillSwitchAlert.m
//  MCKillSwitch
//
//  Created by Stéphanie Paquet on 2013-04-24.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchAlert.h"

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitchAlert () 
@property (nonatomic, strong) MCKillSwitchInfo *killSwitchInfo;
@property (nonatomic, strong) UIAlertView *alertView;
@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitchAlert

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------

- (void)showAlertForKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo
{
    _killSwitchInfo = killSwitchInfo;
    
    MCKillSwitchInfoButton *cancelButton = [_killSwitchInfo cancelButton];
    NSArray *otherButtons = [_killSwitchInfo urlButtons];
    
    [self hideAlert]; // If an alert is currently displayed, hide it.
    
    _alertView = [[UIAlertView alloc] initWithTitle:@""
                                            message:_killSwitchInfo.message
                                           delegate:self
                                  cancelButtonTitle:cancelButton.title
                                  otherButtonTitles:nil];
    
    for (MCKillSwitchInfoButton *button in otherButtons) {
        [_alertView addButtonWithTitle:button.title];
    }
    
    [_alertView show];
    
    _showing = YES;
    if ([_delegate respondsToSelector:@selector(killSwitchAlertDidShow:)]) {
        [_delegate killSwitchAlertDidShow:self];
    }
}

- (void)hideAlert
{
    if (_showing) {
        [_alertView dismissWithClickedButtonIndex:-1 animated:YES];
        _alertView = nil;
        
        _showing = NO;
        
        if ([self shouldHideAlertAfterButtonAction]) {
            // Call the delegate if the alert will be hidden completely, not when the alert is hidden to be shown right afterwards
            
            if ([_delegate respondsToSelector:@selector(killSwitchAlertDidHide:)]) {
                [_delegate killSwitchAlertDidHide:self];
            }
        }
    }
}

- (BOOL)shouldHideAlertAfterButtonAction
{
    return (_killSwitchInfo.action != MCKillSwitchActionKill);
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (BOOL)openURLForButtonAtIndex:(NSInteger)index
{
    BOOL canOpenURL = NO;
    NSArray *orderedButtons = [_killSwitchInfo orderedButtons]; // To ensure that the cancel button is at index 0 and the other buttons are following
    
    if (index < orderedButtons.count) {
        MCKillSwitchInfoButton *button = orderedButtons[index];
        BOOL pathExists = button.urlPath && button.urlPath.length > 0;
        
        if (pathExists) {
            NSURL *url = [NSURL URLWithString:button.urlPath];
            canOpenURL = [[UIApplication sharedApplication] canOpenURL:url];
            
            if (canOpenURL) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
    [self determineAlertDisplayState];
    
    return canOpenURL;
}

- (void)determineAlertDisplayState
{
    if ([self shouldHideAlertAfterButtonAction]) {
        [self hideAlert];
    }
    else {
        [self showAlertForKillSwitchInfo:_killSwitchInfo];
    }
}

//------------------------------------------------------------------------------
#pragma mark - MCKillSwitchDelegate
//------------------------------------------------------------------------------

- (void)killSwitch:(MCKillSwitch *)killSwitch shouldShowKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo
{
    [self showAlertForKillSwitchInfo:killSwitchInfo];
}

- (void)killSwitch:(MCKillSwitch *)killSwitch didNotNeedToShowKillSwitchInfo:(MCKillSwitchInfo *)killSwitchInfo
{
    [self hideAlert];
}

//------------------------------------------------------------------------------
#pragma mark - UIAlertViewDelegate
//------------------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    [self openURLForButtonAtIndex:buttonIndex];
}

@end
