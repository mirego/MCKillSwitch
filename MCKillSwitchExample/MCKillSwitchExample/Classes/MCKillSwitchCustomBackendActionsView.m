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

#import "MCKillSwitchCustomBackendActionsView.h"

NSString * const kMCKillSwitchBackendVersionCI = @"CI";
NSString * const kMCKillSwitchBackendVersionQA = @"QA";
NSString * const kMCKillSwitchBackendVersionPROD = @"PROD";
NSString * const kMCKillSwitchAppVersionLanguageDevice = @"Current Device Language";
NSString * const kMCKillSwitchAppVersionLanguageFrench = @"French";
NSString * const kMCKillSwitchAppVersionLanguageEnglish = @"English";

@interface MCKillSwitchCustomBackendActionsView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) UIView *container;
@property (nonatomic) UIPickerView *appVersionLanguagePicker;
@property (nonatomic) UIPickerView *backendVersionPicker;

@end

@implementation MCKillSwitchCustomBackendActionsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        
        _container = [[UIView alloc] init];
        _container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_container];
        
        _textFieldAPIKey = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFieldAPIKey.placeholder = @"Api Key";
        _textFieldAPIKey.borderStyle = UITextBorderStyleRoundedRect;
        [_container addSubview:_textFieldAPIKey];
        
        _textFieldAppVersionNumber = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFieldAppVersionNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textFieldAppVersionNumber.placeholder = @"App Version";
        _textFieldAppVersionNumber.borderStyle = UITextBorderStyleRoundedRect;
        [_container addSubview:_textFieldAppVersionNumber];
        
        _textFieldAppVersionLanguage = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFieldAppVersionLanguage.inputView = [self createAppVersionLanguagePicker];
        _textFieldAppVersionLanguage.placeholder = @"App Version Language";
        _textFieldAppVersionLanguage.borderStyle = UITextBorderStyleRoundedRect;
        _textFieldAppVersionLanguage.text = kMCKillSwitchAppVersionLanguageDevice;
        [_container addSubview:_textFieldAppVersionLanguage];
        
        _textFieldBackendVersion = [[UITextField alloc] initWithFrame:CGRectZero];
        _textFieldBackendVersion.inputView = [self createBackendVersionPicker];
        _textFieldBackendVersion.placeholder = @"Backend version";
        _textFieldBackendVersion.borderStyle = UITextBorderStyleRoundedRect;
        _textFieldBackendVersion.text = kMCKillSwitchBackendVersionQA;
        [_container addSubview:_textFieldBackendVersion];
        
        _buttonTestInfos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buttonTestInfos setTitle:@"Test killswitch infos" forState:UIControlStateNormal];
        [_container addSubview:_buttonTestInfos];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_container addSubview:_activityIndicatorView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (UIPickerView *)createBackendVersionPicker
{
    if (!_backendVersionPicker) {
        _backendVersionPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _backendVersionPicker.dataSource = self;
        _backendVersionPicker.delegate = self;
        _backendVersionPicker.showsSelectionIndicator = YES;
    }
    
    return _backendVersionPicker;
}

- (UIPickerView *)createAppVersionLanguagePicker
{
    if (!_appVersionLanguagePicker) {
        _appVersionLanguagePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _appVersionLanguagePicker.dataSource = self;
        _appVersionLanguagePicker.delegate = self;
        _appVersionLanguagePicker.showsSelectionIndicator = YES;
    }
    
    return _appVersionLanguagePicker;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 20.0f;
    CGFloat containerWidth = self.bounds.size.width - padding * 2;
    CGFloat textFieldsHeight = 44.0f;
    CGFloat textFieldsVerticalSpacing = 10.0f;
    CGFloat buttonMarginTop = 30.0f;
    CGFloat buttonHeight = [_buttonTestInfos sizeThatFits:CGSizeZero].height;
    CGSize activityIndicatorSize = [self.activityIndicatorView sizeThatFits:CGSizeZero];
 
    _textFieldAPIKey.frame = CGRectMake(0, 0, containerWidth, textFieldsHeight);
    _textFieldAppVersionNumber.frame = CGRectMake(0, CGRectGetMaxY(_textFieldAPIKey.frame) + textFieldsVerticalSpacing, containerWidth, textFieldsHeight);
    _textFieldAppVersionLanguage.frame = CGRectMake(0, CGRectGetMaxY(_textFieldAppVersionNumber.frame) + textFieldsVerticalSpacing, containerWidth, textFieldsHeight);
    _textFieldBackendVersion.frame = CGRectMake(0, CGRectGetMaxY(_textFieldAppVersionLanguage.frame) + textFieldsVerticalSpacing, containerWidth, textFieldsHeight);
    
    _buttonTestInfos.frame = CGRectMake(0, CGRectGetMaxY(_textFieldBackendVersion.frame) + buttonMarginTop, containerWidth, buttonHeight);
    _activityIndicatorView.frame = CGRectMake(CGRectGetMidX(_buttonTestInfos.frame), CGRectGetMidY(_buttonTestInfos.frame), activityIndicatorSize.width, activityIndicatorSize.height);
    
    CGFloat containerHeight = CGRectGetMaxY(_buttonTestInfos.frame);
    _container.frame = CGRectMake(padding, padding, containerWidth, containerHeight);
    
    if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
        self.contentSize = CGSizeMake(containerWidth, containerHeight + padding * 2);
    }
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _appVersionLanguagePicker) {
        return 3;
    }
    if (pickerView == _backendVersionPicker) {
        return 3;
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _appVersionLanguagePicker) {
        switch (row) {
            default:
            case 0:
                return kMCKillSwitchAppVersionLanguageDevice;
            case 1:
                return kMCKillSwitchAppVersionLanguageFrench;
            case 2:
                return kMCKillSwitchAppVersionLanguageEnglish;
        }
    }
    if (pickerView == _backendVersionPicker) {
        switch (row) {
            default:
            case 0:
                return kMCKillSwitchBackendVersionCI;
            case 1:
                return kMCKillSwitchBackendVersionQA;
            case 2:
                return kMCKillSwitchBackendVersionPROD;
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _appVersionLanguagePicker) {
        switch (row) {
            default:
            case 0:
                _textFieldAppVersionLanguage.text = kMCKillSwitchAppVersionLanguageDevice;
                break;
            case 1:
                _textFieldAppVersionLanguage.text = kMCKillSwitchAppVersionLanguageFrench;
                break;
            case 2:
                _textFieldAppVersionLanguage.text = kMCKillSwitchAppVersionLanguageEnglish;
                break;
        }
    }
    if (pickerView == _backendVersionPicker) {
        switch (row) {
            default:
            case 0:
                _textFieldBackendVersion.text = kMCKillSwitchBackendVersionCI;
                break;
            case 1:
                _textFieldBackendVersion.text = kMCKillSwitchBackendVersionQA;
                break;
            case 2:
                _textFieldBackendVersion.text = kMCKillSwitchBackendVersionPROD;
                break;
        }
    }
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat bottomInset = endFrame.size.height;

    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, 0, bottomInset, 0);
    self.scrollIndicatorInsets = self.contentInset;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top, 0, 0, 0);
    self.scrollIndicatorInsets = self.contentInset;
}

@end
