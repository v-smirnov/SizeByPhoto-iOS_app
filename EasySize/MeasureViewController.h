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
#import "MeasureManager.h"
#import "DataManager.h"
#import "TextFieldWithKey.h"
#import "ResultViewController.h"
#import "ImageViewWithKey.h"
#import "AppDelegate.h"
#import "OverlayViewController.h"

typedef enum
{
    main,
    side
    
} pictureMode;


@interface MeasureViewController : UIViewController <UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, OverlayViewControllerDelegate>
{
    UIImageView *sizeView;
    CGFloat currentAngle;
    UIImageView *linImageView;
    NSMutableArray *whatToMeasureArray;
    float distanceBetweenEyes;
    float distBwtEyesInSm;
    NSMutableDictionary *allStuffToMeasureDictionary;
    NSMutableArray *measureObjects;
    UIImagePickerControllerSourceType source;
    BOOL pickingCanceled;
    UIScrollView *sizesScrollView;
    UIActivityIndicatorView *activityIndicator;
    BOOL makeMeasurementsUsingTwoPhotos;
    NSMutableDictionary *photosDictionary;
    NSMutableDictionary *firstPhotoMeasuresDictionary;
    BOOL measureDidFail;
    UIButton *infoButton;
    OverlayViewController *overlayViewController; // the camera custom overlay view
    
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
- (IBAction) showTips:(id)sender;

@end
