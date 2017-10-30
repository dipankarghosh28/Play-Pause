//
//  ViewController.h
//  PlayPause
//
//  Created by Dipankar Ghosh on 10/3/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
{
    AVAudioPlayer *audioPlayer;
    int shakeCount;
}
@end
