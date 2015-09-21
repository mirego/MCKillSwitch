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

#import "MCKillSwitchExampleRootView.h"

@implementation MCKillSwitchExampleRootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat margin = 20.0;
        
        UIView *container = [[UIView alloc] init];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        _buttonClearSavedInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonClearSavedInfo setTitle:NSLocalizedString(@"BTN_CLEAR_INFO", nil) forState:UIControlStateNormal];
        [_buttonClearSavedInfo sizeToFit];
        _buttonClearSavedInfo.frame = CGRectIntegral(CGRectMake([self originXForView:_buttonClearSavedInfo], 0.0, _buttonClearSavedInfo.frame.size.width, _buttonClearSavedInfo.frame.size.height));
        [container addSubview:_buttonClearSavedInfo];
        
        UILabel *instruction = [[UILabel alloc] init];
        instruction.backgroundColor = [UIColor clearColor];
        instruction.text = NSLocalizedString(@"TEST_ACTIONS", nil);
        instruction.textAlignment = NSTextAlignmentCenter;
        [instruction sizeToFit];
        instruction.frame = CGRectIntegral(CGRectMake([self originXForView:instruction], CGRectGetMaxY(_buttonClearSavedInfo.frame) + (margin*1.5), instruction.frame.size.width, instruction.frame.size.height));
        [container addSubview:instruction];
        
        _buttonTestActionOK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonTestActionOK setTitle:NSLocalizedString(@"BTN_ACTION_OK", nil) forState:UIControlStateNormal];
        [_buttonTestActionOK sizeToFit];
        _buttonTestActionOK.frame = CGRectIntegral(CGRectMake([self originXForView:_buttonTestActionOK], CGRectGetMaxY(instruction.frame) + (margin/2), _buttonTestActionOK.frame.size.width, _buttonTestActionOK.frame.size.height));
        [container addSubview:_buttonTestActionOK];
        
        _buttonTestActionAlert = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonTestActionAlert setTitle:NSLocalizedString(@"BTN_ACTION_ALERT", nil) forState:UIControlStateNormal];
        [_buttonTestActionAlert sizeToFit];
        _buttonTestActionAlert.frame = CGRectIntegral(CGRectMake([self originXForView:_buttonTestActionAlert], CGRectGetMaxY(_buttonTestActionOK.frame) + margin, _buttonTestActionAlert.frame.size.width, _buttonTestActionAlert.frame.size.height));
        [container addSubview:_buttonTestActionAlert];
        
        _buttonTestActionKill = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonTestActionKill setTitle:NSLocalizedString(@"BTN_ACTION_KILL", nil) forState:UIControlStateNormal];
        [_buttonTestActionKill sizeToFit];
        _buttonTestActionKill.frame = CGRectIntegral(CGRectMake([self originXForView:_buttonTestActionKill], CGRectGetMaxY(_buttonTestActionAlert.frame) + margin, _buttonTestActionKill.frame.size.width, _buttonTestActionKill.frame.size.height));
        [container addSubview:_buttonTestActionKill];


        _buttonTestUseStaticKillSwitch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonTestUseStaticKillSwitch setTitle:@"Use static JSON" forState:UIControlStateNormal];
        [_buttonTestUseStaticKillSwitch sizeToFit];
        _buttonTestUseStaticKillSwitch.frame = CGRectIntegral(CGRectMake([self originXForView:_buttonTestUseStaticKillSwitch], CGRectGetMaxY(_buttonTestActionKill.frame) + margin, _buttonTestUseStaticKillSwitch.frame.size.width, _buttonTestUseStaticKillSwitch.frame.size.height));
        [container addSubview:_buttonTestUseStaticKillSwitch];
        
        _buttonCustomBackendActions = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonCustomBackendActions setTitle:@"Custom backend actions" forState:UIControlStateNormal];
        [_buttonCustomBackendActions sizeToFit];
        _buttonCustomBackendActions.frame = CGRectIntegral(CGRectMake([self originXForView:_buttonCustomBackendActions], CGRectGetMaxY(_buttonTestUseStaticKillSwitch.frame) + margin, _buttonCustomBackendActions.frame.size.width, _buttonCustomBackendActions.frame.size.height));
        [container addSubview:_buttonCustomBackendActions];

        CGFloat heightContainer = CGRectGetMaxY(_buttonCustomBackendActions.frame);
        container.frame = CGRectIntegral(CGRectMake(0.0, (self.bounds.size.height - heightContainer) / 2, self.bounds.size.width, heightContainer));
        [self addSubview:container];
    }
    
    return self;
}

- (CGFloat)originXForView:(UIView *)view
{
    CGRect rect = self.bounds;
    return (rect.size.width - view.frame.size.width)/2;
}

@end
