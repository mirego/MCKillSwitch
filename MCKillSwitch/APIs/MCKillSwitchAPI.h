//
//  MCKillSwitchAPI
//  MCKillSwitchExample
//
//  Created by mlefrancois on 2013-08-12
//  Copyright (c) 2013 Mirego Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol MCKillSwitchAPIDelegate;

@protocol MCKillSwitchAPI <NSObject>
- (void)cancel;
- (void)startWithParameters:(NSDictionary *)parameters;
@property (nonatomic, weak) id <MCKillSwitchAPIDelegate> delegate;
@end

@protocol MCKillSwitchAPIDelegate <NSObject>

- (void)killSwitchAPI:(id<MCKillSwitchAPI>)killSwitchAPI didLoadInfoDictionary:(NSDictionary *)infoDictionary;
- (void)killSwitchAPI:(id<MCKillSwitchAPI>)killSwitchAPI didFailWithError:(NSError *)error;

@end