//
//  ResultViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 04.08.12.
//
//

#import <UIKit/UIKit.h>
#import "NewProfileViewController.h"
#import "VSMeasureManager.h"
#import "VSProfileManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MeasureView.h"
#import "TipsViewController.h"
#import "FeedbackViewController.h"
#import <MessageUI/MessageUI.h>
#import "Types.h"
#import "BrandManager.h"
#import "StartDialogViewController.h"
#import "MeasureViewController.h"
#import "StuffCell.h"
#import "SizesViewController.h"
#import "Twitter/Twitter.h"


@interface ResultViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, StartDialogViewControllerDelegate, UIScrollViewDelegate>
{
    VSMeasureManager    *measureManager;
    BOOL userTapedOnSaveAsButton;
}

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *bodyParamsLabel;
@property (nonatomic, assign) backButtonType backButton;
@property (nonatomic, assign) editButtonType editButton;
@property (nonatomic, retain) NSArray *measuredStuff;
@property (nonatomic, retain) IBOutlet UIButton *fbButton;
@property (nonatomic, retain) IBOutlet UIImageView *genderImageView;
@property (nonatomic, retain) StartDialogViewController *startDialogController;
@property (nonatomic, retain) IBOutlet UITableView *stuffTableView;


-(IBAction) showTips:(id) sender;
-(IBAction) showFeedbackOrEmailForm:(id) sender;
-(IBAction) editProfileData:(id) sender;

@end
