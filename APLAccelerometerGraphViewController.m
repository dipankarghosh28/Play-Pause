//
//  APLUserInfoViewController.m
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
#import "APLUserInfoViewController.h"
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
- (IBAction)startUpload:(id)sender {
    
    if (startPlot) {
        NSLog(@"Hit stop first!");
        return;
    }
    
    if (fileNameWithDate ==NULL) {
        NSLog(@"No file o upload. Filepath == NULL");
        UIAlertView *noFileAlert=[[UIAlertView alloc]initWithTitle:@"Attention:" message:@"No file to upload. Hit start first!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [noFileAlert show];
        return;
    }
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    NSString *thePath = [documentsDirectory stringByAppendingPathComponent:fileNameWithDate];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:thePath]){
        //[self stopSendWithStatus:@"No file"];
        NSLog(@"No File to upload");
        UIAlertView *noFileAlert=[[UIAlertView alloc]initWithTitle:@"Attention:" message:@"No file to upload. Hit start first!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [noFileAlert show];
        return;
    }

    [self startSend:thePath];
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
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"File Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];

        }
    }
    
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
}


- (void)startSend:(NSString *)filePath
{
    BOOL                    success;
    NSURL *                 url;
    self.userName = @"andguer";
    self.password = @"andguer2014";
    self.activityIndicator.hidden = NO;
    
    assert(filePath != nil);
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [self stopSendWithStatus:@"No file"];
        return;
    }
    
    
    //assert( [filePath.pathExtension isEqual:@"csv"]);
    
    assert(self.networkStream == nil);      // don't tap send twice in a row!
    assert(self.fileStream == nil);         // ditto
    
    // First get and check the URL.
    
    //url = [[NetworkManager sharedInstance] smartURLForString:self.urlText.text];
     url = [NSURL URLWithString:@"ftp://172.24.11.61"];
    success = (url != nil);
    
    if (success) {
        // Add the last part of the file name to the end of the URL to form the final
        // URL that we're going to put to.
        
        url = CFBridgingRelease(
                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                                );
        success = (url != nil);
    }
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
       // self.statusLabel.text = @"Invalid URL";
        NSLog(@"Invalid URL");
    }
    else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        assert(self.networkStream != nil);
        
        /*
        if ([self.usernameText.text length] != 0) {
            success = [self.networkStream setProperty:self.usernameText.text forKey:(id)kCFStreamPropertyFTPUserName];
            assert(success);
            success = [self.networkStream setProperty:self.passwordText.text forKey:(id)kCFStreamPropertyFTPPassword];
            assert(success);
        }
        */
        
        success = [self.networkStream setProperty:self.userName forKey:(id)kCFStreamPropertyFTPUserName];
        assert(success);
        success = [self.networkStream setProperty:self.password forKey:(id)kCFStreamPropertyFTPPassword];
        assert(success);
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Tell the UI we're sending.
        
        [self sendDidStart];
    }
}

- (void)sendDidStart
{
    //self.statusLabel.text = @"Sending";
    NSLog(@"Sending");
    //self.cancelButton.enabled = YES;
    [self.activityIndicator startAnimating];
    //[[NetworkManager sharedInstance] didStartNetworkOperation];
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)updateStatus:(NSString *)statusString
{
    assert(statusString != nil);
    //self.statusLabel.text = statusString;
    NSLog(@"%@",statusString);
}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"Put succeeded";
        
        UIAlertView *putSuccessfulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"File Successfully uploaded" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [putSuccessfulAlert show];
        
        [self cancelUpload:@"Success"];
    }
   // self.statusLabel.text = statusString;
     NSLog(@"%@",statusString);
    //self.cancelButton.enabled = NO;
    [self.activityIndicator stopAnimating];
    //[[NetworkManager sharedInstance] didStopNetworkOperation];
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}

@end
