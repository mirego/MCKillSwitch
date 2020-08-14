//
// Copyright (c) 2013-2019, Mirego
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

#import <StoreKit/StoreKit.h>

#define STORE_PREFIX @"store:"

typedef void(^MCKillSwitchAlertBlock)(void);

//------------------------------------------------------------------------------
#pragma mark - Private interface
//------------------------------------------------------------------------------

@interface MCKillSwitchAlertController : UIAlertController
@end

@implementation MCKillSwitchAlertController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    @throw [NSException exceptionWithName:NSGenericException
                                   reason:[NSString stringWithFormat:@"Trying to present a view controller on top of the Kill Switch: %@", viewControllerToPresent]
                                 userInfo:nil];
}

@end

@interface MCKillSwitchAlert () <SKStoreProductViewControllerDelegate>

@property (nonatomic) id<MCKillSwitchInfo> killSwitchInfo;
@end

//------------------------------------------------------------------------------
#pragma mark - Implementation
//------------------------------------------------------------------------------

@implementation MCKillSwitchAlert

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Public methods
//------------------------------------------------------------------------------

- (BOOL)shouldHideAlertAfterButtonAction {
    return (self.killSwitchInfo.action != MCKillSwitchActionKill);
}

- (BOOL)isShowing {
    UIViewController *topMostViewController = MCKillSwitchAlert.topMostViewController;
    return [topMostViewController isKindOfClass:MCKillSwitchAlertController.class];
}

- (void)showAlertForKillSwitchInfo:(id<MCKillSwitchInfo>)killSwitchInfo {
    self.killSwitchInfo = killSwitchInfo;
    
    [self hideAlertWithCompletion:^{
        MCKillSwitchAlertController* alertController =
        [MCKillSwitchAlertController alertControllerWithTitle:@""
                                                      message:killSwitchInfo.message
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        NSArray *orderedButtons = [MCKillSwitchAlert orderedButtonsForButtons:killSwitchInfo.buttons];
        [orderedButtons enumerateObjectsUsingBlock:^(id<MCKillSwitchInfoButton> button, NSUInteger idx, BOOL *stop) {
            [alertController addAction:
             [UIAlertAction actionWithTitle:button.title
                                      style:[MCKillSwitchAlert styleForButton:button]
                                    handler:^(UIAlertAction * _Nonnull action) {
                [self performActionForButton:button];
            }]];
        }];
        
        UIViewController *topMostViewController = MCKillSwitchAlert.topMostViewController;
        [topMostViewController presentViewController:alertController animated:YES completion:^{
            [self.delegate killSwitchAlertDidShow:self];
        }];
    }];
}

- (void)hideAlert {
    [self hideAlertWithCompletion:nil];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (void)hideAlertWithCompletion:(MCKillSwitchAlertBlock)completion {
    UIViewController *topMostViewController = MCKillSwitchAlert.topMostViewController;
    if ([topMostViewController isKindOfClass:MCKillSwitchAlertController.class]
#if !TARGET_OS_TV
        || [topMostViewController isKindOfClass:SKStoreProductViewController.class]
#endif
        ) {
        UIViewController *presentingViewController = topMostViewController.presentingViewController;
        [presentingViewController dismissViewControllerAnimated:YES completion:^{
            UIViewController *topMostViewController = MCKillSwitchAlert.topMostViewController;
            if ([topMostViewController isKindOfClass:MCKillSwitchAlertController.class]) {
                [self hideAlertWithCompletion:completion];
                
            } else {
                // Call the delegate if the alert will be hidden completely, not when the alert is hidden to be shown right afterwards
                if ([self shouldHideAlertAfterButtonAction]) {
                    [self.delegate killSwitchAlertDidHide:self];
                }
                
                if (completion) {
                    completion();
                }
            }
        }];
        
    } else {
        if (completion) {
            completion();
        }
    }
}

+ (UIViewController *)topMostViewController {
    UIViewController *topMostViewController = [self rootViewController];
    while (topMostViewController.presentedViewController != nil) {
        topMostViewController = topMostViewController.presentedViewController;
    }
    
    return topMostViewController;
}

+ (UIViewController *)rootViewController {
    UIViewController *rootViewController;
    if (@available(iOS 13.0, tvOS 13.0, *)) {
        UIScene *scene = UIApplication.sharedApplication.connectedScenes.allObjects.firstObject;
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            id<UIWindowSceneDelegate> windowSceneDelegate = (id <UIWindowSceneDelegate>)windowScene.delegate;
            rootViewController = windowSceneDelegate.window.rootViewController;
        }
    }

    if (rootViewController == nil) {
        rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    }

    return rootViewController;
}

+ (UIAlertActionStyle)styleForButton:(id<MCKillSwitchInfoButton>)button {
    switch (button.type) {
        case MCKillSwitchInfoButtonTypeURL:
            return UIAlertActionStyleDefault;
        case MCKillSwitchInfoButtonTypeCancel:
            return UIAlertActionStyleCancel;
    }
}

+ (id<MCKillSwitchInfoButton>)cancelButtonForButtons:(NSArray *)buttons {
    for (id<MCKillSwitchInfoButton> button in buttons) {
        if (button.type == MCKillSwitchInfoButtonTypeCancel) {
            return button;
        }
    }
    
    return nil;
}

+ (NSArray *)urlButtonsForButtons:(NSArray *)buttons {
    NSMutableArray *urlButtons = [NSMutableArray new];
    
    for (id<MCKillSwitchInfoButton> button in buttons) {
        if (button.type == MCKillSwitchInfoButtonTypeURL) {
            [urlButtons addObject:button];
        }
    }
    
    return urlButtons.copy;
}

+ (NSArray *)orderedButtonsForButtons:(NSArray *)buttons {
    NSMutableArray *orderedButtons = [NSMutableArray new];
    
    id<MCKillSwitchInfoButton> cancelButton = [self cancelButtonForButtons:buttons];
    if ((cancelButton != nil)) {
        [orderedButtons addObject:cancelButton];
    }
    
    NSArray *urlButtons = [self urlButtonsForButtons:buttons];
    if ((urlButtons.count > 0)) {
        [orderedButtons addObjectsFromArray:urlButtons];
    }
    
    return orderedButtons.copy;
}

- (BOOL)openUrl:(NSString *)url {
    BOOL didOpenUrl = NO;
    
    if (url.length > 0) {
#if !TARGET_OS_TV
        // If the URL begins with "store:", this is an ID to open the store
        if ([url hasPrefix:STORE_PREFIX]) {
            [self showStoreViewForUrl:url];
            return YES;
        }
#endif
        
        didOpenUrl = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    [self determineAlertDisplayState];
    return didOpenUrl;
}

#if !TARGET_OS_TV

- (void)showStoreViewForUrl:(NSString *)url {
    SKStoreProductViewController *storeViewController = [SKStoreProductViewController new];
    storeViewController.delegate = self;
    
    UIViewController *topMostViewController = MCKillSwitchAlert.topMostViewController;
    [topMostViewController presentViewController:storeViewController animated:YES completion:^{
        NSString *storeNumber = [url substringFromIndex:STORE_PREFIX.length];
        
        [storeViewController loadProductWithParameters:@{
            SKStoreProductParameterITunesItemIdentifier:@(storeNumber.integerValue)
        } completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (!result) {
                [self determineAlertDisplayState];
            }
        }];
    }];
}

#endif

- (void)performActionForButton:(id<MCKillSwitchInfoButton>)button {
    switch (button.type) {
        case MCKillSwitchInfoButtonTypeURL:
            [self openUrl:button.urlPath];
            break;
            
        case MCKillSwitchInfoButtonTypeCancel:
            [self determineAlertDisplayState];
            break;
    }
}

- (void)determineAlertDisplayState {
    if ([self shouldHideAlertAfterButtonAction]) {
        [self hideAlert];
    } else {
        [self showAlertForKillSwitchInfo:self.killSwitchInfo];
    }
}

//------------------------------------------------------------------------------
#pragma mark - SKStoreProductViewControllerDelegate
//------------------------------------------------------------------------------

#if !TARGET_OS_TV

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    UIViewController *presentingViewController = viewController.presentingViewController;
    if ((presentingViewController != nil)) {
        [presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self determineAlertDisplayState];
        }];
        
    } else {
        [self determineAlertDisplayState];
    }
}

#endif

//------------------------------------------------------------------------------
#pragma mark - MCKillSwitchDelegate
//------------------------------------------------------------------------------

- (void)killSwitch:(MCKillSwitch *)killSwitch shouldShowKillSwitchInfo:(id<MCKillSwitchInfo>)info {
    [self showAlertForKillSwitchInfo:info];
}

- (void)killSwitch:(MCKillSwitch *)killSwitch didNotNeedToShowKillSwitchInfo:(id<MCKillSwitchInfo>)info {
    [self hideAlert];
}

@end
