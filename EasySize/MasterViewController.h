//
//  MasterViewController.h
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "NewProfileViewController.h"
#import "ResultViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "TipsViewController.h"
#import "FeedbackViewController.h"


@interface MasterViewController : UITableViewController
{
    UIView *deleteView;
    UIButton *deleteButton;
}

@property (nonatomic, retain) IBOutlet UIView *deleteView;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;


-(IBAction)deleteSelectedCells;
@end
