//
//  MCKillSwitchExampleRootViewController.m
//  MCKillSwitchExample
//
//  Created by Stéphanie Paquet on 2013-05-10.
//  Copyright (c) 2013 Mirego. All rights reserved.
//

#import "MCKillSwitchExampleRootViewController.h"
#import "MCKillSwitchExampleRootView.h"
#import "MCKillSwitch.h"
#import "MCKillSwitchAlert.h"
#import "MCMockKillSwitchAPIOK.h"
#import "MCMockKillSwitchAPIAlert.h"
#import "MCMockKillSwitchAPIKill.h"

@interface MCKillSwitchExampleRootViewController ()

@property (nonatomic, strong) MCKillSwitchAlert *killSwitchAlert;

@end

@implementation MCKillSwitchExampleRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        _killSwitchAlert = [[MCKillSwitchAlert alloc] init];
    }
    return self;
}

- (void)loadView
{
    MCKillSwitchExampleRootView *rootView = [[MCKillSwitchExampleRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [rootView.buttonClearSavedInfo addTarget:self action:@selector(selectedClearSavedInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [rootView.buttonTestActionOK addTarget:self action:@selector(selectedTestActionOkButton:) forControlEvents:UIControlEventTouchUpInside];
    [rootView.buttonTestActionAlert addTarget:self action:@selector(selectedTestActionAlertButton:) forControlEvents:UIControlEventTouchUpInside];
    [rootView.buttonTestActionKill addTarget:self action:@selector(selectedTestActionKillButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = rootView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

//------------------------------------------------------------------------------
#pragma mark - Private methods
//------------------------------------------------------------------------------

- (MCKillSwitch *)killSwitchWithAPIClass:(Class)apiClass
{
    MCKillSwitch *killSwitch = nil;
    BOOL isAPIKillSwitchClass = [apiClass isSubclassOfClass:[MCKillSwitchAPI class]];
    
    if (isAPIKillSwitchClass) {
        killSwitch = [[MCKillSwitch alloc] initWithAPI:[[apiClass alloc] init]]; // Tests with local JSON.
        killSwitch.delegate = _killSwitchAlert;
    }
    
    return killSwitch;
}


@end
