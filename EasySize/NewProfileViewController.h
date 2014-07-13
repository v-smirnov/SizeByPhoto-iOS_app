//
//  DetailViewController.h
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSProfileManager.h"
#import "UIImageResize.h"
#import "VSMeasureManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "StartDialogViewController.h"
#import "AppDelegate.h"
#import "MeasureViewController.h"
#import "Consts.h"
#import "Types.h"

@class NewProfileViewController;




@interface NewProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, UIScrollViewDelegate, StartDialogViewControllerDelegate>
{
    UIImageView *profileImageView;
    UITextField *nameField;
    UITextField *surnameField;
    UITextField *ageField;
    saveButtonActionType saveButtonAction;
    UIScrollView *sexScrollView;
    UISegmentedControl *genderSegmentedControl;
    VSMeasureManager *measureManager;
    BOOL userMakeCurrentProfileMain;
    BOOL userSelectedNewPhoto;
}

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *surnameField;
@property (nonatomic, retain) IBOutlet UITextField *ageField;
@property (nonatomic, assign) saveButtonActionType saveButtonAction;
@property (nonatomic, retain) IBOutlet UIScrollView *sexScrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (nonatomic, retain)  StartDialogViewController *startDialogController;
@property (nonatomic, retain) IBOutlet UIButton *mainProfileButton;
@property (nonatomic, assign) BOOL createdMainProfile;
@property (nonatomic, retain) IBOutlet UILabel *mainProfileLabel;


-(IBAction) selectProfileImage;
-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) hideKeyboard:(id)sender;
-(IBAction) onAgeFieldValueChanged:(id)sender;
-(IBAction) onMainProfileButtonTap:(id)sender;

@end
