//
//  MCKillSwitchCustomBackendActionsView.m
//  MCKillSwitchExample
//
//  Created by Dany L'Hebreux on 2015-09-21.
//  Copyright © 2015 Mirego Inc. All rights reserved.
//

#import "MCKillSwitchCustomBackendActionsView.h"

NSString * const kMCKillSwitchBackendVersionCI = @"CI";
NSString * const kMCKillSwitchBackendVersionQA = @"QA";
NSString * const kMCKillSwitchBackendVersionPROD = @"PROD";
NSString * const kMCKillSwitchAppVersionLanguageAny = @"Any language";
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
        _textFieldAppVersionLanguage.text = kMCKillSwitchAppVersionLanguageAny;
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
                return kMCKillSwitchAppVersionLanguageAny;
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
                _textFieldAppVersionLanguage.text = kMCKillSwitchAppVersionLanguageAny;
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
