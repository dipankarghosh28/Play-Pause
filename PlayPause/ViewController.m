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
    // Do any additional setup after loading the view, typically from a nib.
    self.play = 0;
    self.rate = 1;
    [self initAudio];
    //  UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"music.jpg"]];
    //   [self.view setBackgroundColor:color];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //This is general warning.
}
-(void) initAudio
{
    NSURL *myUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Secret"ofType:@"mp3"]];
        
        self->audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: myUrl error:nil];
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
    if (shakeCount % 2 == 0)
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
            _playLabel.text =@"Dipankar played his first music";
        } else {
            self.play = 0;
            [audioPlayer pause];
            _playLabel.text =@"Dipankar Stopped the music";
        }
        shakeCount = 0;
    }

}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

@end
