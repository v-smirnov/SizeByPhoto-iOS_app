//
//  ResultViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 04.08.12.
//
//

#import <UIKit/UIKit.h>
#import "HowToMeasureViewController.h"
#import "NewProfileViewController.h"
#import "MeasureManager.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MeasureView.h"
#import "TipsViewController.h"
#import "FeedbackViewController.h"
#import <MessageUI/MessageUI.h>

typedef enum
{
    standartButton,
    rootButton
    
} backButtonType;

typedef enum
{
    standartEditButton,
    noButton
    
} editButtonType;

@interface ResultViewController : UIViewController <NewProfileViewControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    UIImageView *profileImageView;
    UILabel *nameLabel;
    UILabel *sexLabel;
    UILabel *bodyParamsLabel;
    backButtonType bButtonType;
    editButtonType eButtonType;
    UIScrollView *resultScrollView;
    NSArray *resultArray;
    UIButton *fbButton;
}

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *sexLabel;
@property (nonatomic, retain) IBOutlet UILabel *bodyParamsLabel;
@property (nonatomic, assign) backButtonType bButtonType;
@property (nonatomic, assign) editButtonType eButtonType;
@property (nonatomic, retain) IBOutlet UIScrollView *resultScrollView;
@property (nonatomic, retain) NSArray *resultArray;
@property (nonatomic, retain) IBOutlet UIButton *fbButton;

-(IBAction) showTips:sender;
-(IBAction) showFeedbackOrEmailForm:sender;

@end
