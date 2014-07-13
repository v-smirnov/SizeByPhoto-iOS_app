//
//  MasterViewController.h
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSProfileManager.h"
#import "NewProfileViewController.h"
#import "ResultViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "TipsViewController.h"
#import "FeedbackViewController.h"
#import "StartDialogViewController.h"
#import "VSMeasureManager.h"
#import "TutorialViewController.h"



@interface MasterViewController : UITableViewController <StartDialogViewControllerDelegate>
{
    NSMutableDictionary *selectedCells;
    VSMeasureManager *measureManager;
}

@property (nonatomic, retain) IBOutlet UIView *deleteView;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain)  StartDialogViewController *startDialogController;



-(IBAction)deleteSelectedCells;
-(IBAction)onCameraButtonTap;
@end
