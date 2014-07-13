//
//  AppDelegate.h
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateViewController.h"
#import "LocalyticsSession.h"
//#import "PushNotificationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, assign) BOOL imagePickerControllerIsActive;
@property (nonatomic, retain) RateViewController *rateController;
@property (nonatomic, retain) UIImageView *backgroundView;

@end
