//
//  APLGraphViewController.h
//  PlayPause
//
//  Created by Dipankar Ghosh on 12/2/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//

//
/*
     File: APLGraphViewController.h
 Abstract: Superclass for the view controllers responsible for all UI interactions with the user and the sensors.
  */

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface APLGraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *updateIntervalLabel;

- (void)setLabelValueX:(double)x y:(double)y z:(double)z;
- (void)setLabelValueRoll:(double)roll pitch:(double)pitch yaw:(double)yaw;
- (void)startUpdatesWithSliderValue:(int)sliderValue;

@end
