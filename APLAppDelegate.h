//
//  APLAppDelegate.h
//  PlayPause
//
//  Created by Dipankar Ghosh on 10/2/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//
//
/*
     File: APLAppDelegate.h
 Abstract: The app delegate that has an app-wide motion manager.
   */

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface APLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;

@end
