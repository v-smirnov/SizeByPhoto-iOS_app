//
//  OverlayViewController.m
//  iBoobs
//
//  Created by User on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverlayViewController.h"

#define FRAME_HEIGHT 44
#define FRAME_HEIGHT_568 86

#define TAKING_PICTURE_DELAY 5

@interface OverlayViewController ()

@end

@implementation OverlayViewController

@synthesize delegate, imagePickerController, changeCameraButton, cancelButton, countdownTimer, delayTimeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        self.changeCameraButton.enabled = NO;
    }
    else
    {
        self.changeCameraButton.enabled = YES;
    }
    
    
    [self.cancelButton setTitle: NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button_pressed.png"] forState:UIControlStateHighlighted];

    self.delayTimeLabel.text = [NSString stringWithFormat:@"%d", TAKING_PICTURE_DELAY];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.changeCameraButton = nil;
    self.cancelButton = nil;
    self.imagePickerController = nil;
    self.countdownTimer = nil;
    self.delayTimeLabel = nil;
}


- (void)dealloc
{	
	[imagePickerController release];    
    [changeCameraButton release];
    [cancelButton release];
    [countdownTimer release];
    [delayTimeLabel release];
    [super dealloc];
}

#pragma mark - help functions

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType forPictureMode:(NSInteger) pMode
{
    
    UIImagePickerController  *tmpImagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController = tmpImagePickerController;
    self.imagePickerController.delegate = self;
    [tmpImagePickerController release];
    
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // user wants to use the camera interface
        //
        self.imagePickerController.showsCameraControls = NO;
        self.imagePickerController.allowsEditing = YES;
        self.imagePickerController.toolbarHidden = YES;
        
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            // setup our custom overlay view for the camera
            //
            // ensure that our custom view's frame fits within the parent frame
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
            
            CGRect newFrame;
            if ([[UIScreen mainScreen] bounds].size.height == 568){
                newFrame = CGRectMake(0.0,
                                             CGRectGetHeight(overlayViewFrame) -
                                             FRAME_HEIGHT_568 -10,
                                             CGRectGetWidth(overlayViewFrame),
                                             FRAME_HEIGHT_568 +10);
                
            }
            else{
                newFrame = CGRectMake(0.0,
                                      CGRectGetHeight(overlayViewFrame) -
                                      FRAME_HEIGHT -10,
                                      CGRectGetWidth(overlayViewFrame),
                                      FRAME_HEIGHT +10);
            }
            
            self.view.frame = newFrame;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
            
            UIImageView *conturImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(overlayViewFrame), CGRectGetHeight(overlayViewFrame)-newFrame.size.height)];
            if (pMode == 0){ //main
                conturImageView.image = [UIImage imageNamed:@"Contour"];
            }
            else{//side
                conturImageView.image = [UIImage imageNamed:@"SideContour"];
            }
            conturImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.imagePickerController.cameraOverlayView addSubview:conturImageView];
            [conturImageView release];

            
        }
    }
    else{
        UIImageView *conturImageView = [[UIImageView alloc] initWithFrame:self.imagePickerController.view.frame];
        if (pMode == 0){ //main
            conturImageView.image = [UIImage imageNamed:@"Contour"];
        }
        else{//side
            conturImageView.image = [UIImage imageNamed:@"SideContour"];
        }
        conturImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imagePickerController.view addSubview:conturImageView];
        [conturImageView release];

    }
    
 
}



- (void)finishAndUpdate
{
    // tell our delegate we are done with the camera
    [self.delegate didFinishWithCamera];
    
}

- (void) timerTick:(NSTimer *)timer
{
    UILabel *label = (UILabel *)[self.view viewWithTag:TAKING_PICTURE_DELAY];
    
    if (label){
        label.text = [NSString stringWithFormat:@"%d", countdownTime];
        [UIView animateWithDuration:0.5f animations:^{
            label.alpha = 1.0f;
        }
             completion:^(BOOL finished) {
                 [UIView animateWithDuration:0.5f animations:^{
                     label.alpha = 0.0f;
                 }
                      completion:^(BOOL finished) {
                          
                      }];
             }];

    }
    else{
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        label.center = self.imagePickerController.view.center;
        label.tag = TAKING_PICTURE_DELAY;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:176.0f];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.textAlignment =UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d", countdownTime];
        label.alpha = 0.0f;
        [self.imagePickerController.view addSubview:label];
               
        [UIView animateWithDuration:0.5f animations:^{
           label.alpha = 1.0f;
        }
             completion:^(BOOL finished) {
                 [UIView animateWithDuration:0.5f animations:^{
                     label.alpha = 0.0f;
                 }
                      completion:^(BOOL finished) {
                          
                      }];
             }];
        [label release];

    }
    
    
    countdownTime--;
}

- (void) takePhotoAfterDelay
{
    [self.countdownTimer invalidate];
    [self takePhoto:nil];
}

#pragma mark - actions

- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}

- (IBAction)takePhotoWithDelay:(id)sender
{
    countdownTime = TAKING_PICTURE_DELAY;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                           target:self
                                                         selector:@selector(timerTick:)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [self performSelector:@selector(takePhotoAfterDelay) withObject:nil afterDelay:TAKING_PICTURE_DELAY+1];
    
    //[self.imagePickerController takePicture];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate didCancelWithCamera];
}

- (IBAction)changeCamera:(id)sender
{
    [UIView beginAnimations:@"Flip view" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
    
    if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else 
    {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.imagePickerController.view cache:YES];
    [UIView commitAnimations];

}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    // give the taken picture to our delegate
    if (self.delegate){
        [self.delegate didTakePicture:image];
    }
    
    //[self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [self.delegate didCancelWithCamera];    // tell our delegate we are finished with the picker
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
