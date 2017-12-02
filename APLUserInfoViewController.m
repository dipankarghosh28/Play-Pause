//
//  APLUserInfoViewController.m
//  PlayPause
//
//  Created by Dipankar Ghosh on 10/3/17.
//  Copyright © 2017 Dipankar Ghosh. All rights reserved.
//

//
//

#import "APLUserInfoViewController.h"
#import "APLGraphViewController.h"
#import "APLGraphView.h"
#import "APLAppDelegate.h"
#import "APLAccelerometerGraphViewController.h"

@interface APLUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelection;

@property (weak, nonatomic) IBOutlet UISegmentedControl *fallerSelection;

@property (weak, nonatomic) IBOutlet UITextView *commentsText;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation APLUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    /*
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    */
    
    [self.nameTextField setDelegate:self];
    [self.nameTextField setReturnKeyType:UIReturnKeyDone];
    [self.nameTextField addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.ageTextField setDelegate:self];
    [self.ageTextField setReturnKeyType:UIReturnKeyDone];
    [self.ageTextField addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.commentsText setDelegate:self];
    [self.commentsText setReturnKeyType:UIReturnKeyDone];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

/*
-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}
*/
/*
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
*/


//method to dismiss the keyboard if the user touches anywhere in the view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)updateButton:(id)sender
{
    self.name = self.nameTextField.text;
    self.age = self.ageTextField.text;
    
    if (self.genderSelection.selectedSegmentIndex ==0)
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    
    if (self.fallerSelection.selectedSegmentIndex ==0)
    {
        self.faller = @"YES";
    }
    else
    {
        self.faller = @"NO";
    }
    
    self.comments = self.commentsText.text;
    
    /*
    NSLog(@"%@/n %@/n %ld/n %ld/n %@/n",_nameTextField.text,_ageTextField.text,(long)_genderSelection.selectedSegmentIndex,(long)_fallerSelection.selectedSegmentIndex,_commentsText.text);
    */
    
    // NSLog(@"%@\n %@\n %@\n %@\n %@\n", self.name, self.age, self.gender, self.faller, self.comments);
    
    NSString *userInfo = [NSString stringWithFormat:@"Name:%@\rAge:%@\rGender:%@\rFaller:%@\rComments:%@\r", self.name, self.age, self.gender, self.faller, self.comments];
    //NSLog(@"%@",userInfo);
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMddyyyyHHmmSS"];
    
    //NSDate *now = [[NSDate alloc] init];
    
    //NSString *dateString = [format stringFromDate:now];
    
    //NSLog(@"%@",dateString);
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    
    NSString *thePath = [documentsDirectory stringByAppendingPathComponent:@"userinfo.txt"];
    NSLog(@"%@",thePath);
    
    BOOL sucess = [userInfo writeToFile:thePath atomically:YES];
    
    //Testing the returned BOOL
    if (sucess)
    {
        NSLog(@"done writing %@",path);
    }
    
    else{
        NSLog(@"Failed to write %@",path);
    }
    
   /*
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:thePath])
    {
        [userInfo writeToFile:thePath atomically:YES];
        NSLog(@"creating file for user info");
    }
    */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
