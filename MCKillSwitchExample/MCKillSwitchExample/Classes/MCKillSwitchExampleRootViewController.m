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

#import "MCKillSwitchExampleRootViewController.h"
#import "MCKillSwitchExampleRootView.h"

#import "MCKillSwitch.h"
#import "MCKillSwitchAlert.h"
#import "MCMockKillSwitchAPIOK.h"
#import "MCMockKillSwitchAPIAlert.h"
#import "MCMockKillSwitchAPIKill.h"

@interface MCKillSwitchExampleRootViewController ()

@property (nonatomic, readonly, weak) MCKillSwitchExampleRootView *rootView;
@property (nonatomic, readonly) MCKillSwitchAlert *killSwitchAlert;
@end

@implementation MCKillSwitchExampleRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _killSwitchAlert = [[MCKillSwitchAlert alloc] init];
    }
    
    return self;
}

- (void)loadView
{
    MCKillSwitchExampleRootView *rootView = [[MCKillSwitchExampleRootView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.view = rootView;
    _rootView = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rootView.buttonClearSavedInfo addTarget:self action:@selector(selectedClearSavedInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.buttonTestActionOK addTarget:self action:@selector(selectedTestActionOkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.buttonTestActionAlert addTarget:self action:@selector(selectedTestActionAlertButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.buttonTestActionKill addTarget:self action:@selector(selectedTestActionKillButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootView.buttonTestUseStaticKillSwitch addTarget:self action:@selector(useTestStaticKillSwitch) forControlEvents:UIControlEventTouchUpInside];
}

//------------------------------------------------------------------------------
#pragma mark - Control Events
//------------------------------------------------------------------------------

- (void)selectedClearSavedInfoButton:(UIButton *)button
{
    [MCKillSwitch clearSavedInfo];
}

- (void)selectedTestActionOkButton:(UIButton *)button
{
    MCKillSwitch *killSwitch = [self killSwitchWithAPIClass:[MCMockKillSwitchAPIOK class]];
    [killSwitch execute];
}

- (void)selectedTestActionAlertButton:(UIButton *)button
{
    MCKillSwitch *killSwitch = [self killSwitchWithAPIClass:[MCMockKillSwitchAPIAlert class]];
    [killSwitch execute];
}

- (void)selectedTestActionKillButton:(UIButton *)button
{
    MCKillSwitch *killSwitch = [self killSwitchWithAPIClass:[MCMockKillSwitchAPIKill class]];
    [killSwitch execute];
}

- (void)useTestStaticKillSwitch
{
    // FIXME Change HOST to a better one
    [MCKillSwitch configureStaticJSONFileKillSwitchWithURL:[NSURL URLWithString:@"http://lefrancois-test.s3.amazonaws.com/1.0.0.json"]];
}

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (MCKillSwitch *)killSwitchWithAPIClass:(Class)apiClass
{
    MCKillSwitch *killSwitch = nil;
    
    BOOL isAPIKillSwitchClass = [apiClass isSubclassOfClass:[MCKillSwitchDynamicAPI class]];
    if (isAPIKillSwitchClass) {
        killSwitch = [[MCKillSwitch alloc] initWithAPI:[[apiClass alloc] init]]; // Tests with local JSON.
        killSwitch.delegate = _killSwitchAlert;
    }
    
    return killSwitch;
}

@end
