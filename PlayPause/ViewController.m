//
//  ViewController.m
//  PlayPause
//
//  Created by Dipankar Ghosh on 10/3/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
- (IBAction)playButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *isPlaying;
@property(nonatomic) float rate;

@property (nonatomic) NSInteger play;

@end

@implementation ViewController

- (void)viewDidLoad
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //This is general warning.
}
-(void) initAudio
{
   
}

- (IBAction)playButton:(id)sender
{
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self becomeFirstResponder];
}

-(void) normalShake
{
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

@end
