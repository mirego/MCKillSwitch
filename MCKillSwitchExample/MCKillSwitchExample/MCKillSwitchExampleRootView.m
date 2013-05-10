//
//  MCKillSwitchExampleRootView.m
//  MCKillSwitchExample
//
//  Created by Stéphanie Paquet on 2013-05-10.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchExampleRootView.h"

@implementation MCKillSwitchExampleRootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
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
        instruction.textAlignment = UITextAlignmentCenter;
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
        
        CGFloat heightContainer = CGRectGetMaxY(_buttonTestActionKill.frame);
        container.frame = CGRectIntegral(CGRectMake(0.0, (frame.size.height - heightContainer)/2, frame.size.width, heightContainer));
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
