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
    [super viewDidLoad];
    self.play = 0;
    self.rate = 1;
    [self initAudio];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"violin.jpg"]];
    [self.view setBackgroundColor:color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; //This is general warning.
}
-(void) initAudio
{
    NSURL *myUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TestMusic"ofType:@"mp3"]];
        
        self->audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: myUrl error:nil];
}

- (IBAction)playButton:(id)sender
{
    self.play = 1;
    self.rate = 5;
    self->audioPlayer.numberOfLoops = -1;
    _playLabel.text =@"Music is being played";
    [audioPlayer rate];
    [audioPlayer play];
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
    if (shakeCount % 2 == 0) //shakeCount % 2 determines the shake frequency.
    {
        [audioPlayer stop];
        [audioPlayer play];
        shakeCount = 0;
        _playLabel.text =@"Restarted the music";
    }
    else
    {
        if(self.play == 0){
            self.play = 1;
            [audioPlayer play];
            _playLabel.text =@"Music is being played";
        } else {
            self.play = 0;
            [audioPlayer pause];
            _playLabel.text =@"Music has stopped";
        }
        shakeCount = 0;
    }

}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        shakeCount++;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector: @selector(normalShake) userInfo:nil repeats:NO];
    }
}

@end
