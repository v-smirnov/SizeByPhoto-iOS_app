//
//  FeedbackViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 19.12.12.
//
//

#import <UIKit/UIKit.h>
#import "Types.h"
#import "Consts.h"

@interface FeedbackViewController : UIViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    UITextField *nameField;
    UILabel *nameLabel;
    UILabel *emailLabel;
    UILabel *textLabel;
    UITextField *email;
    UITextView *feedbackTextView;
    NSMutableData *recievedData;
    NSURLConnection *connection;
    UIActivityIndicatorView *activityIndicator;
    NSString *textForFeedbackLabel;
    formType form;
    UIImageView *feedbackFormImageView;
}

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UITextView *feedbackTextView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) formType form;
@property (nonatomic, retain) NSString *textForFeedbackLabel;
@property (nonatomic, retain) IBOutlet UIImageView *feedbackFormImageView;


-(IBAction)sendRequest:(id)sender;
-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) hideKeyboard:(id)sender;

@end
