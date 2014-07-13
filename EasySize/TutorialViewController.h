//
//  TutorialViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 16.09.13.
//
//

#import <UIKit/UIKit.h>
#import "Types.h"
#import "Consts.h"
//#import <QuartzCore/QuartzCore.h>

@class TutorialViewController;

@protocol TutorialViewControllerDelegate
- (void)TutorialViewControllerDidFinish:(TutorialViewController *)controller;
@end

@interface TutorialViewController : UIViewController
{
    BOOL animationAlreadyStopedByUser;
}

@property (nonatomic, assign) id <TutorialViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *tImageView;
@property (nonatomic ,retain) NSString *bodyPartForAnimation;
@property (nonatomic, assign) PersonKind personKind;
@property (nonatomic, assign) pictureMode pictureMode;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, assign) BOOL closeViewWhenAminationEnds;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;

-(IBAction) playAnimation:(id)sender;
-(IBAction) done:(id)sender;

@end
