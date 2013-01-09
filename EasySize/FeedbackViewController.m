//
//  FeedbackViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 19.12.12.
//
//

#import "FeedbackViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define GENERAL_API_KEY @"67af906bbcdf4ccb9d948f6f7f41cdf3"
#define RESULT_API_KEY @"7428cec26b3d41988a333da404b4d3a7"


@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize email, feedbackTextView, nameField, nameLabel, emailLabel, textLabel, sendButton,activityIndicator, form, textForFeedbackLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [email release];
    [feedbackTextView release];
    [activityIndicator release];
    [nameField release];
    [nameLabel release];
    [emailLabel release];
    [textLabel release];
    [sendButton release];
    [textForFeedbackLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.email = nil;
    self.feedbackTextView = nil;
    self.activityIndicator = nil;
    self.nameField = nil;
    self.nameLabel = nil;
    self.emailLabel = nil;
    self.textLabel = nil;
    self.sendButton = nil;
    self.textForFeedbackLabel = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Feedback", nil);
    // Do any additional setup after loading the view from its nib.
    self.nameLabel.text = NSLocalizedString(@"Your name", nil);
    self.emailLabel.text = NSLocalizedString(@"Your e-mail", nil);
    self.textLabel.text = NSLocalizedString(self.textForFeedbackLabel, nil);
    self.nameField.placeholder = NSLocalizedString(@"Your name", nil);
    [self.sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    self.feedbackTextView.layer.cornerRadius = 10.0f;
    self.feedbackTextView.delegate = self;
    [self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions&selectors
- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)hideKeyboard:(id)sender
{
    [self.email resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.feedbackTextView resignFirstResponder];
}


- (IBAction)sendRequest:(id)sender
{
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    if (self.form == result){
       [dataDict setObject:RESULT_API_KEY forKey:@"api_key"];
    }
    else{
        [dataDict setObject:GENERAL_API_KEY forKey:@"api_key"];
    }
    [dataDict setObject:self.email.text forKey:@"email"];
    [dataDict setObject:self.nameField.text forKey:@"name"];
    [dataDict setObject:self.feedbackTextView.text forKey:@"text"];
    [dataDict setObject:@"subject" forKey:@"subject"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                            @"OS", @"name",
                                            @"OS Type", @"display_name",
                 [UIDevice currentDevice].systemVersion, @"value",
                                            @"Enviroment", @"group", nil]];
    [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                            @"Device", @"name",
                                            @"Device Type", @"display_name",
                           [UIDevice currentDevice].model, @"value",
                                            @"Enviroment", @"group", nil]];
    
    
    [dataDict setObject:dataArray forKey:@"data"];
    
    [dataArray release];
    
    //convert object to data
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dataDict
                                                       options:0 error:&error];

    
    
    [dataDict release];
    if (jsonData)
    {
        NSURL *url = [NSURL URLWithString:@"http://api.inventarium.mobi/v1/feedback"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: jsonData];
        
        connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if (!connection) {
            [self showAlertDialogWithTitle:@"Warning" andMessage:@"Connection failed!"];
        }
        else{
            self.navigationController.navigationItem.backBarButtonItem.enabled = false;
            [self.activityIndicator startAnimating];
            //recievedData = [[NSMutableData alloc] init];
        }
    }
    else{
        [self showAlertDialogWithTitle:@"Warning" andMessage:[error localizedDescription]];
    }

    
}

#pragma mark - help functiond
- (void) showAlertDialogWithTitle:(NSString *) title andMessage:(NSString *) message{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(title, nil)
                          message:NSLocalizedString(message, nil)
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#pragma mark - NSURLConnection delegate methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //[recievedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)local_connection
{
    //NSError* error;
    //NSDictionary* json = [NSJSONSerialization
    //                      JSONObjectWithData:recievedData //1
    //
    //                      options:kNilOptions
    //                      error:&error];
    
    //NSLog(@"%@", json);
    [self.activityIndicator stopAnimating];
    [self showAlertDialogWithTitle:@"" andMessage:@"Thank you for your feedback!"];
    //[recievedData release];
    [connection release];
}

-(void)connection:(NSURLConnection *)local_connection didFailWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    //Lf [recievedData release];
    [connection release];
    [self showAlertDialogWithTitle:@"Warning" andMessage:[error localizedDescription]];
}
#pragma mark - Text view delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect newFrame;
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        newFrame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 125);
    }
    else{
        newFrame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 45);
    }
    
    textView.frame = newFrame;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    CGRect newFrame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 207);
    
    textView.frame = newFrame;
}

@end
