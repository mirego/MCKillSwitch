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

#import "MCKillSwitchCustomBackendActionsViewController.h"
#import "MCKillSwitchCustomBackendActionsView.h"
#import "MCKillSwitch.h"
#import "MCKillSwitchDynamicAPI.h"
#import "MCKillSwitchAlert.h"

NSString * const kMCKillSwitchBackendCI = @"https://mirego-killswitch-ci.herokuapp.com";
NSString * const kMCKillSwitchBackendQA = @"https://mirego-killswitch-qa.herokuapp.com";
NSString * const kMCKillSwitchBackendKey = @"backend";

@interface MCKillSwitchCustomBackendActionsViewController () <MCKillSwitchAPIDelegate>

@property (nonatomic) MCKillSwitchCustomBackendActionsView *rootView;
@property (nonatomic) MCKillSwitchAlert *alert;

@end

@implementation MCKillSwitchCustomBackendActionsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"Custom Backend Actions";
    }
    
    return self;
}

- (void)loadView
{
    MCKillSwitchCustomBackendActionsView *rootView = [[MCKillSwitchCustomBackendActionsView alloc] initWithFrame:CGRectZero];
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view = rootView;
    _rootView = rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _alert = [[MCKillSwitchAlert alloc] init];
    [_rootView.buttonTestInfos addTarget:self action:@selector(testInfos:) forControlEvents:UIControlEventTouchUpInside];
    [self restoreSavedValueFromUserDefault];
}

- (void)testInfos:(UIButton *)button
{
    [_rootView endEditing:YES];
    if ([self isAllFieldsFilled]) {
        [self saveInfosInUserDefault];
        MCKillSwitchDynamicAPI *dynamicAPI = [[MCKillSwitchDynamicAPI alloc] initWithBaseURL:[self createURLFromField] URLIsStatic:NO];
        dynamicAPI.delegate = self;
        [dynamicAPI startWithParameters:[self createParametersFromFields]];
        [self showLoading:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"All fields must be filled." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }
}

- (void)restoreSavedValueFromUserDefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _rootView.textFieldAPIKey.text = [userDefaults stringForKey:kMCKillDefaultAPIKeyParameterName];
    _rootView.textFieldAppVersionNumber.text = [userDefaults stringForKey:kMCKillSwitchAPIAppVersion];
    
    NSString *language = [userDefaults stringForKey:kMCKillSwitchAPILanguage];
    if (language.length > 0) {
        _rootView.textFieldAppVersionLanguage.text = language;
    }
    
    NSString *backend = [userDefaults stringForKey:kMCKillSwitchBackendKey];
    if (backend.length > 0) {
        _rootView.textFieldBackendVersion.text = backend;
    }
}

- (void)saveInfosInUserDefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_rootView.textFieldAPIKey.text forKey:kMCKillDefaultAPIKeyParameterName];
    [userDefaults setObject:_rootView.textFieldAppVersionNumber.text forKey:kMCKillSwitchAPIAppVersion];
    [userDefaults setObject:_rootView.textFieldAppVersionLanguage.text forKey:kMCKillSwitchAPILanguage];
    [userDefaults setObject:_rootView.textFieldBackendVersion.text forKey:kMCKillSwitchBackendKey];
    [userDefaults synchronize];
}

- (NSURL *)createURLFromField
{
    NSString *rawValue = _rootView.textFieldBackendVersion.text;
    if ([rawValue isEqualToString:kMCKillSwitchBackendVersionCI]) {
        return [NSURL URLWithString:kMCKillSwitchBackendCI];
    } else if ([rawValue isEqualToString:kMCKillSwitchBackendVersionPROD]) {
        return [NSURL URLWithString:kMCKillSwitchAPIDefaultAPIBaseURL];
    }
    return [NSURL URLWithString:kMCKillSwitchBackendQA];
}

- (NSDictionary *)createParametersFromFields
{
    return @{ kMCKillDefaultAPIKeyParameterName: _rootView.textFieldAPIKey.text, kMCKillSwitchAPIAppVersion: _rootView.textFieldAppVersionNumber.text, kMCKillSwitchAPILanguage: [self convertedLanguageValueFromField] };
}

- (NSString *)convertedLanguageValueFromField
{
    NSString *rawValue = _rootView.textFieldAppVersionLanguage.text;
    if ([rawValue isEqualToString:kMCKillSwitchAppVersionLanguageFrench]) {
        return @"fr";
    } else if ([rawValue isEqualToString:kMCKillSwitchAppVersionLanguageEnglish]) {
        return @"en";
    }
    return @"";
}

- (BOOL)isAllFieldsFilled
{
    return _rootView.textFieldAPIKey.text.length > 0 && _rootView.textFieldAppVersionNumber.text.length > 0 && _rootView.textFieldAppVersionLanguage.text.length > 0 && _rootView.textFieldBackendVersion.text.length > 0;
}

- (void)showLoading:(BOOL)showLoading
{
    _rootView.buttonTestInfos.hidden = showLoading;
    showLoading ? [_rootView.activityIndicatorView startAnimating] : [_rootView.activityIndicatorView stopAnimating];
}

#pragma mark - MCKillSwitchAPIDelegate

- (void)killSwitchAPI:(id<MCKillSwitchAPI>)killSwitchAPI didLoadInfo:(id<MCKillSwitchInfo>)info
{
    [self showLoading:NO];
    BOOL shouldShowInfo = info && (info.action != MCKillSwitchActionOK);
    if (shouldShowInfo) {
        [_alert showAlertForKillSwitchInfo:info];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"All good" message:@"These parameters are fine, no alert will be shown in real application." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }
}

- (void)killSwitchAPI:(id<MCKillSwitchAPI>)killSwitchAPI didFailWithError:(NSError *)error
{
    [self showLoading:NO];
    [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
}

@end
