//
//  DetailViewController.h
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "UIImageResize.h"
#import "MeasureManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@class NewProfileViewController;


@protocol NewProfileViewControllerDelegate
- (void)newProfileViewControllerDidFinish:(NewProfileViewController *)controller;
@optional
- (void)newProfileViewControllerUpdateData:(NSMutableDictionary *)dataDictionary;
@end


@interface NewProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate, UIScrollViewDelegate>
{
    UIImageView *profileImageView;
    UITextField *nameField;
    UITextField *surnameField;
    UITextField *ageField;
    UILabel *nameLabel;
    UILabel *surnameLabel;
    UILabel *ageLabel;
    UILabel *sexLabel;
    NSInteger saveButtonAction;
    UIScrollView *sexScrollView;
    UISegmentedControl *genderSegmentedControl;
}

@property (nonatomic, assign) id <NewProfileViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *surnameField;
@property (nonatomic, retain) IBOutlet UITextField *ageField;
@property (nonatomic, assign) NSInteger saveButtonAction;
@property (nonatomic, retain) IBOutlet UIScrollView *sexScrollView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *surnameLabel;
@property (nonatomic, retain) IBOutlet UILabel *ageLabel;
@property (nonatomic, retain) IBOutlet UILabel *sexLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderSegmentedControl;

-(IBAction) selectProfileImage;
-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) hideKeyboard:(id)sender;
-(IBAction) onAgeFieldValueChanged:(id)sender;


@end
