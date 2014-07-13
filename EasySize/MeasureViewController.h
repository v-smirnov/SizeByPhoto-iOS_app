//
//  MeasureViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 05.08.12.
//
//

#import <UIKit/UIKit.h>
#import "UIImageResize.h"
#import <CoreImage/CoreImage.h>
#import "VSProfileManager.h"
#import "VSMeasureManager.h"
#import "TextFieldWithKey.h"
#import "ResultViewController.h"
#import "ImageViewWithKey.h"
#import "AppDelegate.h"
#import "OverlayViewController.h"
#import "Types.h"
#import "Consts.h"
#import "TutorialViewController.h"




@interface MeasureViewController : UIViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate, OverlayViewControllerDelegate, TutorialViewControllerDelegate>
{
    UIImageView *sizeView;
    CGFloat currentAngle;
    UIImageView *linImageView;
    NSMutableArray *whatToMeasureArray;
    float distanceBetweenEyes;
    float distBwtEyesInSm;
    UIImagePickerControllerSourceType source;
    UIScrollView *sizesScrollView;
    UIActivityIndicatorView *activityIndicator;
    BOOL makeMeasurementsUsingTwoPhotos;
    BOOL pickingCanceled;
    NSMutableDictionary *photosDictionary;
    NSMutableDictionary *firstPhotoMeasuresDictionary;
    UIButton *infoButton;
    OverlayViewController *overlayViewController; // the camera custom overlay view
    VSMeasureManager *measureManager;
    CGPoint leftEyePosition;
    NSMutableDictionary *featuresOnPhotos;
    pictureMode currentPictureMode;
    float angleWhenUserTookFirstPhoto;
    float angleWhenUserTookSecondPhoto;
    NSInteger cameraDirectionWhenUserTookFirstPhoto;
    NSInteger cameraDirectionWhenUserTookSecondPhoto;
}

@property (nonatomic, retain) IBOutlet UIImageView *sizeView;
@property (nonatomic, retain) UIImageView *linImageView;
@property (nonatomic, retain) NSMutableArray *whatToMeasureArray;
@property (nonatomic, assign) BOOL pickingCanceled;
@property (nonatomic, assign) UIImagePickerControllerSourceType source;
@property (nonatomic, retain) IBOutlet UIScrollView *sizesScrollView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL makeMeasurementsUsingTwoPhotos;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) OverlayViewController *overlayViewController;



-(void)addMeasure;
-(IBAction) showTips:(id)sender;

@end
