//
//  OverlayViewController.h
//  iBoobser
//
//  Created by User on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

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
}

@property (nonatomic, assign) id <OverlayViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) IBOutlet UIButton *changeCameraButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) NSTimer *countdownTimer;
@property (nonatomic, retain) IBOutlet UILabel *delayTimeLabel;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType forPictureMode:(NSInteger) pMode;

- (IBAction)takePhoto:(id)sender;
- (IBAction)takePhotoWithDelay:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)changeCamera:(id)sender;

@end

@protocol OverlayViewControllerDelegate
- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;
- (void)didCancelWithCamera;
@end
