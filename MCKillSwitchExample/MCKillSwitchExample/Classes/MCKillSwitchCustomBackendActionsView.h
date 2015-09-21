//
//  MCKillSwitchCustomBackendActionsView.h
//  MCKillSwitchExample
//
//  Created by Dany L'Hebreux on 2015-09-21.
//  Copyright © 2015 Mirego Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kMCKillSwitchBackendVersionCI;
extern NSString * const kMCKillSwitchBackendVersionQA;
extern NSString * const kMCKillSwitchBackendVersionPROD;
extern NSString * const kMCKillSwitchAppVersionLanguageAny;
extern NSString * const kMCKillSwitchAppVersionLanguageFrench;
extern NSString * const kMCKillSwitchAppVersionLanguageEnglish;

@interface MCKillSwitchCustomBackendActionsView : UIScrollView

@property (nonatomic, readonly) UITextField *textFieldAPIKey;
@property (nonatomic, readonly) UITextField *textFieldAppVersionNumber;
@property (nonatomic, readonly) UITextField *textFieldAppVersionLanguage;
@property (nonatomic, readonly) UITextField *textFieldBackendVersion;
@property (nonatomic, readonly) UIButton *buttonTestInfos;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
