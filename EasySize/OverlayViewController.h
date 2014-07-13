//
//  OverlayViewController.h
//  iBoobser
//
//  Created by User on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"
#import "Consts.h"
#import "UIImageResize.h"
#import <CoreMotion/CoreMotion.h>


@protocol OverlayViewControllerDelegate;

@interface OverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id <OverlayViewControllerDelegate> delegate;
    UIImagePickerController *imagePickerController;
    UIButton *changeCameraButton;
    UIButton *cancelButton;
    NSTimer *countdownTimer;
    NSInteger countdownTime;
    UILabel *delayTimeLabel;
    BOOL delayTipWasShown;
    float currentXDeviceAngle;
    float xDeviceAngleWhenUserDidTakePhoto;
    NSInteger cameraDirection;
    NSInteger cameraDirectionWhenUserDidTakePhoto;
}

@property (nonatomic, assign) id <OverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) IBOutlet UIButton *changeCameraButton;
@property (nonatomic, retain) IBOutlet UIButton *flashButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *delayCameraButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) NSTimer *countdownTimer;
@property (nonatomic, retain) IBOutlet UILabel *delayTimeLabel;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *processingLabel;
@property (nonatomic, retain) CMMotionManager *motionManager;


- (void) setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (void) setTipsContourImage:(UIImage*) contourImage;
- (void) setContourImage:(UIImage*) contourImage;

- (IBAction)takePhoto:(id)sender;
- (IBAction)takePhotoWithDelay:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changeCamera:(id)sender;
- (IBAction)changeFlashState;

@end

@protocol OverlayViewControllerDelegate
- (void)didTakePhoto: (UIImage *) photo withAngle:(float) angle cameraDirection:(NSInteger) cDirection andReceiveFeatures:(NSArray *) features;
- (void)didFinishWithCamera;
- (void)didCancelWithCamera;
@optional
- (void)didTakePicture:(UIImage *)picture;
@end
