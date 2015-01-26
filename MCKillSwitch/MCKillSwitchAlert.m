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

#import "MCKillSwitchAlert.h"

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitchAlert ()

@property (nonatomic, readonly) MCKillSwitchInfo *killSwitchInfo;
@property (nonatomic, readonly) UIAlertView *alertView;
@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitchAlert

- (instancetype)init
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
    
    [_delegate killSwitchAlertDidShow:self];
}

- (void)hideAlert
{
    if (_showing) {
        [_alertView dismissWithClickedButtonIndex:-1 animated:YES];
        _alertView = nil;
        
        _showing = NO;
        
        if ([self shouldHideAlertAfterButtonAction]) {
            // Call the delegate if the alert will be hidden completely, not when the alert is hidden to be shown right afterwards
            
            [_delegate killSwitchAlertDidHide:self];
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
    } else {
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
