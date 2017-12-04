//
//  APLAccelerometerGraphViewController.m
//  PlayPause
//
//  Created by Dipankar Ghosh on 12/2/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//

/*
     File: APLAccelerometerGraphViewController.m
 Abstract: View controller to manage display of output from the accelerometer.
 
 */

#import "APLAccelerometerGraphViewController.h"
#import "APLAppDelegate.h"
#import "APLGraphView.h"
//#import "APLUserInfoViewController.h"
#include <CFNetwork/CFNetwork.h>


enum {
    kSendBufferSize = 32768
};

static const NSTimeInterval accelerometerMin = 0.005;
BOOL startPlot = NO;
NSString *fileNameWithDate = NULL;

@interface APLAccelerometerGraphViewController ()<UITextFieldDelegate, NSStreamDelegate>

//@property (nonatomic) NSMutableArray *storageArray;
@property (nonatomic, weak) IBOutlet APLGraphView *graphView;


@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;
@property   (nonatomic) NSString    *userName;
@property   (nonatomic) NSString    *password;
//@property (nonatomic) NSString *fileNameWithDate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



@end


@implementation APLAccelerometerGraphViewController
{
    uint8_t                     _buffer[kSendBufferSize];
}



- (void)startUpdatesWithSliderValue:(int)sliderValue
{
    //self.fileNameWithDate = NULL;
    self.activityIndicator.hidden = YES;

    if (startPlot) {
        
    NSTimeInterval delta = 0.005;
    NSTimeInterval updateInterval = accelerometerMin + delta * sliderValue;

    CMMotionManager *mManager = [(APLAppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];

    APLAccelerometerGraphViewController * __weak weakSelf = self;
    if ([mManager isAccelerometerAvailable] == YES) {
        [mManager setAccelerometerUpdateInterval:updateInterval];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            [weakSelf.graphView addX:accelerometerData.acceleration.x y:accelerometerData.acceleration.y z:accelerometerData.acceleration.z];
            [weakSelf setLabelValueX:accelerometerData.acceleration.x y:accelerometerData.acceleration.y z:accelerometerData.acceleration.z];
            [weakSelf updateArrayAddX:accelerometerData.acceleration.x y:accelerometerData.acceleration.y z:accelerometerData.acceleration.z];
        }];
        //CMLogItem *ts = [[CMLogItem alloc]init];
        //NSLog(@"%f",ts.timestamp);
        NSLog(@"%@", [mManager accelerometerData]);
      
    }

    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%f", updateInterval];
    }
}


- (void)stopUpdates
{
    CMMotionManager *mManager = [(APLAppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];

    if ([mManager isAccelerometerActive] == YES) {
        [mManager stopAccelerometerUpdates];
    }
}

-(void)updateArrayAddX:(double)x y:(double)y z:(double)z
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMddyyyy-HH:mm:ss.SSS"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    
    NSString *myString = [NSString stringWithFormat:@"%@, %f, %f, %f\n",dateString, x, y, z];
    //[NSLog(@"%@",myString);

    
    
    if (fileNameWithDate == NULL) {
    
        NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory2 = [path2 objectAtIndex:0];
        NSString *infoPath = [documentsDirectory2 stringByAppendingPathComponent:@"userinfo.txt"];
        NSLog(@"%@",infoPath);
        //NSArray *userInfo = [NSArray arrayWithContentsOfFile:@"infoPath"];
        NSString *userData = [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:NULL];
        
        /*
        NSString *userData = [NSString stringWithFormat:@"Name:%@\rAge:%@\rGender:%@\rFaller:%@\rComments:%@\r\r", [userInfo objectAtIndex:0],userInfo[1],userInfo[2],userInfo[3],userInfo[4]];
         */
        
        NSLog(@"%@",userData);
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MMddyyyyHHmmss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:now];
        fileNameWithDate = [dateString stringByAppendingString:@".csv"];
    
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [path objectAtIndex:0];
        
        NSString *thePath = [documentsDirectory stringByAppendingPathComponent:fileNameWithDate];
        NSLog(@"%@",thePath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:thePath])
        {
            [userData writeToFile:thePath atomically:YES];
            NSLog(@"creating file");
        }
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    NSString *thePath = [documentsDirectory stringByAppendingPathComponent:fileNameWithDate];
    NSLog(@"%@",thePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:thePath])
    {
        [myString writeToFile:thePath atomically:YES];
        NSLog(@"creating file");
    }

    
    else
    {
         //NSLog(@"file exist");
        NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:thePath];
        [myHandle seekToEndOfFile];
       [myHandle writeData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Appending file");
    }
}

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (IBAction)startButton:(id)sender
{
    if (!startPlot){
        startPlot = YES;
        [self startUpdatesWithSliderValue:0];
    }
}

- (IBAction)stopButton:(id)sender
{
    if (startPlot) {
        startPlot = NO;
        [self stopUpdates];
    }
}

- (IBAction)cancelUpload:(id)sender {
    
    self.activityIndicator.hidden = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileNameWithDate];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    fileNameWithDate = NULL;
    
    if (![sender  isEqual: @"Success"]) {
        
        if (success) {
            UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Returning" message:@"Back to Previous screen" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [removeSuccessFulAlert show];
            
        }
    }
    
    else
    {
        NSLog(@"Could not Return",[error localizedDescription]);
    }
    
}
@end
