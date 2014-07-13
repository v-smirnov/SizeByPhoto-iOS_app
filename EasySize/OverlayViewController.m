//
//  OverlayViewController.m
//  iBoobs
//
//  Created by User on 28.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OverlayViewController.h"
#import "MeasureViewController.h"

#define FRAME_HEIGHT 44
#define FRAME_HEIGHT_568 86
#define FRAME_HEIGHT_568_v7 130

#define TAKING_PICTURE_DELAY 5

#define CONTUR_VIEW 99
#define TIPS_CONTUR_VIEW 100
#define PROCESSING_BACKGROUND_VIEW 101

@interface OverlayViewController ()

@end

@implementation OverlayViewController

@synthesize delegate, imagePickerController, changeCameraButton, cancelButton, countdownTimer, delayTimeLabel, activityIndicator, processingLabel, delayCameraButton, cameraButton, flashButton, motionManager;

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
    
    motionManager = [[CMMotionManager alloc] init];
    
    if (motionManager.gyroAvailable){
        [motionManager setGyroUpdateInterval:1.0f/10.0f];
        //[self.motionManager startGyroUpdates];
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self processMotion:motion];
        }];
    }


    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        self.changeCameraButton.enabled = NO;
    }
    else
    {
        self.changeCameraButton.enabled = YES;
    }
    
    
    [self.cancelButton setTitle: NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    //[self.cancelButton setBackgroundImage:[UIImage imageNamed:@"button_pressed.png"] forState:UIControlStateHighlighted];

    self.delayTimeLabel.text = [NSString stringWithFormat:@"%d", TAKING_PICTURE_DELAY];
    
    delayTipWasShown = NO;
    
    currentXDeviceAngle = 0.0f;
    cameraDirection = FORWARD_D;
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
    self.activityIndicator = nil;
    self.processingLabel = nil;
    self.delayCameraButton = nil;
    self.cameraButton = nil;
    self.flashButton = nil;
    self.motionManager = nil;
}


- (void)dealloc
{	
	[imagePickerController release];    
    [changeCameraButton release];
    [cancelButton release];
    [countdownTimer release];
    [delayTimeLabel release];
    [activityIndicator release];
    [processingLabel release];
    [delayCameraButton release];
    [cameraButton release];
    [flashButton release];
    [motionManager release];
    [super dealloc];
}

#pragma mark - help functions
- (BOOL) photoIsProcessing
{
    return ![self.activityIndicator isHidden];
}

- (void) sendFeaturesToDelegate:(NSArray *) features afterProcessingPhoto:(UIImage *) photo
{
    [self.activityIndicator stopAnimating];
    [self.processingLabel setHidden: YES];
    UIView *processingBGView = [self.imagePickerController.view viewWithTag:PROCESSING_BACKGROUND_VIEW];
    if (processingBGView){
        [processingBGView removeFromSuperview];
    }
    
    BOOL photoIsCorrect = false;
    
    if ([features count] == 1){
        CIFaceFeature *feature = [features objectAtIndex:0];
        if ((feature.hasRightEyePosition) && (feature.hasLeftEyePosition)){
            photoIsCorrect = true;
        }
    }
    
    if (photoIsCorrect){
        if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
        }
        [self.delegate didTakePhoto:photo withAngle:xDeviceAngleWhenUserDidTakePhoto cameraDirection:cameraDirectionWhenUserDidTakePhoto andReceiveFeatures:features];
    }
    else{
        [self.delegate didTakePhoto:photo withAngle:xDeviceAngleWhenUserDidTakePhoto cameraDirection:cameraDirectionWhenUserDidTakePhoto andReceiveFeatures:nil];;
    }
}

- (void) addTipsImageViewWithFrame:(CGRect) frame onView:(UIView *) view
{
    
    UIImageView *conturImageView = [[UIImageView alloc] initWithFrame:frame];
    conturImageView.tag = TIPS_CONTUR_VIEW;
    conturImageView.userInteractionEnabled = YES;
    /*
     if (pMode == main){ //main
     conturImageView.image = [UIImage imageNamed:@"contour.png"];
     }
     else{//side
     conturImageView.image = [UIImage imageNamed:@"side_contour.png"];
     }
    */
    conturImageView.contentMode = UIViewContentModeScaleToFill;
    
    UITapGestureRecognizer *conturIVTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onConturIVTap:)];
    conturIVTapRecognizer.numberOfTapsRequired = 1;
    [conturImageView addGestureRecognizer:conturIVTapRecognizer];
    [conturIVTapRecognizer release];
    
    [view addSubview:conturImageView];
    [conturImageView release];

    
}

- (void) addContourImageViewWithFrame:(CGRect) frame onView:(UIView *) view
{
    
    UIImageView *conturImageView = [[UIImageView alloc] initWithFrame:frame];
    conturImageView.tag = CONTUR_VIEW;
    conturImageView.userInteractionEnabled = YES;
    conturImageView.contentMode = UIViewContentModeScaleToFill;

    [view addSubview:conturImageView];
    [conturImageView release];
    
    
}


- (void) setContourImage:(UIImage*) contourImage
{
    
    UIImageView *conturImageView = (UIImageView *)[self.imagePickerController.cameraOverlayView viewWithTag:CONTUR_VIEW];
    
    if (conturImageView){
        conturImageView.image = contourImage;
    }
}


- (void) setTipsContourImage:(UIImage*) contourImage
{
    
    UIImageView *conturImageView = (UIImageView *)[self.imagePickerController.view viewWithTag:TIPS_CONTUR_VIEW];
    
    if (conturImageView){
        conturImageView.image = contourImage;
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [conturImageView setAlpha:1.0f];
            
        }
                 completion:^(BOOL finished) {
                    
                 }];

        
        
    }
    /*
    else{
        conturImageView = [[UIImageView alloc] initWithFrame:self.imagePickerController.view.frame];
        conturImageView.image = contourImage;
        conturImageView.contentMode = UIViewContentModeScaleToFill;
        [self.imagePickerController.view addSubview:conturImageView];
        [conturImageView release];

    }
    */
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
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
        
        if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ){
        //[self.imagePickerController.cameraOverlayView setFrame:CGRectMake(0, 44, self.imagePickerController.cameraOverlayView.frame.size.width, self.imagePickerController.cameraOverlayView.frame.size.height - 44)];
            
            //[self.imagePickerController.view setFrame:CGRectMake(0, 44, self.imagePickerController.view.frame.size.width, self.imagePickerController.view.frame.size.height - 44)];
            
        }
        
        self.imagePickerController.showsCameraControls = NO;
        self.imagePickerController.allowsEditing = NO;
        self.imagePickerController.toolbarHidden = YES;
        self.imagePickerController.cameraFlashMode =UIImagePickerControllerCameraFlashModeOff;
        //self.imagePickerController.cameraViewTransform = CGAffineTransformIdentity;
        //self.imagePickerController.wantsFullScreenLayout = YES;
                
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            // setup our custom overlay view for the camera
            //
            // ensure that our custom view's frame fits within the parent frame
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
            
            CGRect newFrame;
            if ([[UIScreen mainScreen] bounds].size.height == 568){
                
                if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ){
                    newFrame = CGRectMake(0.0,
                                         CGRectGetHeight(overlayViewFrame) -
                                         FRAME_HEIGHT_568 -10,
                                         CGRectGetWidth(overlayViewFrame),
                                         FRAME_HEIGHT_568 +10);
                }
                else{
                    newFrame = CGRectMake(0.0,
                                          CGRectGetHeight(overlayViewFrame) -
                                          FRAME_HEIGHT_568_v7 -10,
                                          CGRectGetWidth(overlayViewFrame),
                                          FRAME_HEIGHT_568_v7 +10);
                }
            
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
            [self addContourImageViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(overlayViewFrame), CGRectGetHeight(overlayViewFrame)-newFrame.size.height) onView:self.imagePickerController.cameraOverlayView];
            
            [self.changeCameraButton setFrame:CGRectMake(self.imagePickerController.cameraOverlayView.frame.size.width - self.changeCameraButton.frame.size.width - 10, 30, self.changeCameraButton.frame.size.width, self.changeCameraButton.frame.size.height)];
            [self.imagePickerController.cameraOverlayView addSubview:self.changeCameraButton];
            
            [self.flashButton setFrame:CGRectMake(10, 30, self.flashButton.frame.size.width, self.flashButton.frame.size.height)];
            [self.imagePickerController.cameraOverlayView addSubview:self.flashButton];
            
        }
    }
    
    [self addTipsImageViewWithFrame:self.imagePickerController.view.frame onView:self.imagePickerController.view];
    
    UIActivityIndicatorView * ai = [[UIActivityIndicatorView alloc] init];
    [ai setHidden:YES];
    [ai setHidesWhenStopped:YES];
    [ai setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ai setColor:[UIColor purpleColor]];
    self.activityIndicator = ai;
    [ai release];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, self.imagePickerController.view.frame.size.width, 30)];
    [pLabel setHidden:YES];
    [pLabel setTextColor: [UIColor purpleColor]];
    [pLabel setFont:[UIFont fontWithName:UBUNTU_FONT size:22.0f]];
    [pLabel setBackgroundColor: [UIColor clearColor]];
    [pLabel setNumberOfLines: 0];
    [pLabel setLineBreakMode: NSLineBreakByWordWrapping];
    [pLabel setTextAlignment: NSTextAlignmentCenter];
    [pLabel setText: NSLocalizedString(@"Processing...", nil)];
    [pLabel setCenter:CGPointMake(self.imagePickerController.view.center.x, self.imagePickerController.view.center.y-40)];
    self.processingLabel = pLabel;
    [pLabel release];

    [self.activityIndicator setCenter: self.imagePickerController.view.center];
    //[self.activityIndicator setHidden:NO];
    [self.imagePickerController.view addSubview: self.activityIndicator];
    [self.imagePickerController.view addSubview: self.processingLabel];

}



- (void)finishAndUpdate
{
    // tell our delegate we are done with the camera
    [self.delegate didFinishWithCamera];
    
}

- (void) timerTick:(NSTimer *)timer
{
    UILabel *label = (UILabel *)[self.imagePickerController.view viewWithTag:TAKING_PICTURE_DELAY];
    
    if (label){
        if (countdownTime < 0){
            label.text = @"";
        }
        else{
            label.text = [NSString stringWithFormat:@"%ld", (long)countdownTime];
        }
        [UIView animateWithDuration:0.5f animations:^{
            label.alpha = 1.0f;
        }
             completion:^(BOOL finished) {
                 [UIView animateWithDuration:0.5f animations:^{
                     label.alpha = 0.0f;
                 }
                      completion:^(BOOL finished) {
                          if (countdownTime == -2){
                              countdownTime = -999;
                              [self takePhotoAfterDelay];
                          }
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
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        if (countdownTime < 0){
            label.text = @"";
        }
        else{
            label.text = [NSString stringWithFormat:@"%ld", (long)countdownTime];
        }
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
                          if (countdownTime == -2){
                              countdownTime = -999;
                              [self takePhotoAfterDelay];
                          }
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
    [self.delayCameraButton setEnabled:TRUE];
}

#pragma mark - actions

-(void)processMotion:(CMDeviceMotion*)motion {
    
    if (motion.attitude.rotationMatrix.m22 < 0){
        cameraDirection = BACK_D;
    }
    else{
        cameraDirection = FORWARD_D;
    }
    currentXDeviceAngle = motion.attitude.pitch * 180 / M_PI;
    
    //NSLog(@"a - %f", currentXDeviceAngle);
}


- (void)onConturIVTap:(UITapGestureRecognizer *)tapRecognizer
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [tapRecognizer.view setAlpha:0.0f];
    }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}

- (IBAction)takePhotoWithDelay:(id)sender
{
    [self.delayCameraButton setEnabled:false];
    countdownTime = TAKING_PICTURE_DELAY;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                           target:self
                                                         selector:@selector(timerTick:)
                                                         userInfo:nil
                                                          repeats:YES];
    
    //[self performSelector:@selector(takePhotoAfterDelay) withObject:nil afterDelay:TAKING_PICTURE_DELAY+2]; //+1 - one second after countdown to avoid fast  phototaking
    
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
        [self.cameraButton setHidden:YES];
        [self.delayCameraButton setHidden:NO];
        
        if (!delayTipWasShown){
            delayTipWasShown = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.imagePickerController.view.frame.size.width-20, 80)];
            [label setCenter: self.imagePickerController.view.center];
            [label setTextColor: [UIColor whiteColor]];
            [label setFont: [UIFont systemFontOfSize:20.0f]];
            [label setBackgroundColor: [UIColor darkGrayColor]];
            [label setNumberOfLines: 0];
            [label setLineBreakMode: NSLineBreakByWordWrapping];
            [label setTextAlignment: NSTextAlignmentCenter];
            [label setAlpha:0.0f];
            [label setText:NSLocalizedString(@"5 second countdown. Place the camera and take a photo.", nil)];
            
            [self.imagePickerController.view addSubview:label];
            
            [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                label.alpha = 0.8f;
            }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationOptionCurveLinear animations:^{
                                     label.alpha = 0.0f;
                                 }
                                                completion:^(BOOL finished) {
                                                    [label removeFromSuperview];
                                                    [label release];
                                                }];
                             }];

        }
    }
    else 
    {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self.cameraButton setHidden:NO];
        [self.delayCameraButton setHidden:YES];
    }
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.imagePickerController.view cache:YES];
    [UIView commitAnimations];

}

- (void)changeFlashState
{
    if (self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff){
        [self.flashButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    else{
        [self.flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

// this get called when an image has been chosen from the library or taken from the camera
//
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self photoIsProcessing]){
        return;
    }
    
    if (self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera){
        xDeviceAngleWhenUserDidTakePhoto = currentXDeviceAngle;
        cameraDirectionWhenUserDidTakePhoto = cameraDirection;
    }
    else{
        xDeviceAngleWhenUserDidTakePhoto = 0.0f;
        cameraDirectionWhenUserDidTakePhoto = 0.0f;
    }
    
    UIImage *picture = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CGRect delegateViewFrame = ((MeasureViewController *)self.delegate).sizeView.frame;
    
    CGSize newSize = CGSizeMake(delegateViewFrame.size.width, delegateViewFrame.size.height);
    
    //UIImage *picture = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (picture.size.width > picture.size.height) //landscape
    {
        // koef - special koefficient, that allows to crop the landscape photo properly
        
        
        CGFloat koef = self.view.frame.size.height / self.view.frame.size.width;
        //NSLog(@"koef - %f", koef);
        CGRect cropRect = CGRectMake(((picture.size.width - picture.size.height)/2)*koef, 0, picture.size.height/koef, picture.size.height);
        picture = [picture croppedAndRotadedImage:cropRect];
    }
    else
    {
        CGFloat koef = picture.size.height/picture.size.width;
        
        // 1.34 - iphone photo height / iPhone photo width
        // used for cropping photos from other sources
        if (koef > 1.34f)
        {
            //CGFloat newHeight = picture.size.width*1.34f;
            CGFloat newWidth = picture.size.height/1.34f;
            
            //NSLog(@"%f", newHeight);
            
            //CGRect cropRect = CGRectMake(0, (picture.size.height - newHeight)/2, picture.size.width, newHeight);
            CGRect cropRect = CGRectMake((picture.size.width-newWidth)/2, 0, newWidth, picture.size.height);
            picture = [picture croppedAndRotadedImage:cropRect];
        }
        else if ((koef < 1.3f) && (koef > 1.0f))
        {
            CGFloat newHeight = picture.size.width*1.34f;
            
            //NSLog(@"%f", newHeight);
            
            CGRect cropRect = CGRectMake(0, 0, picture.size.width, newHeight);
            picture = [picture croppedAndRotadedImage:cropRect];
            
        }
        else if (koef <= 1.0f){
            CGFloat newWidth = picture.size.width/1.34f;
            
            //NSLog(@"%f", newHeight);
            
            CGRect cropRect = CGRectMake(picture.size.width/2 - newWidth/2, 0 , newWidth, picture.size.height);
            picture = [picture croppedAndRotadedImage:cropRect];
            
        }
    }
    UIImage *shrunkenImage = [picture resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
    //UIImage *shrunkenImage = picture;
    
    /*
    //saving new picture to the library
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(picture, nil, nil, nil);
    }
     */
    
    //BOOL photoIsCorrect = false;
    UIView *processingBGView = [[UIView alloc] initWithFrame:self.imagePickerController.view.frame];
    [processingBGView setTag:PROCESSING_BACKGROUND_VIEW];
    [processingBGView setBackgroundColor:[UIColor colorWithRed:0.765f green:0.765f blue:0.765f alpha:1.00f]];
    [processingBGView setAlpha:0.9f];
    [self.imagePickerController.view insertSubview: processingBGView atIndex:1];
    
    [processingBGView release];
    
    [self.activityIndicator setHidden: NO];
    [self.processingLabel setHidden: NO];
    [self.activityIndicator startAnimating];
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
     
         CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
         
         NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage: shrunkenImage.CGImage]];
         
        dispatch_async(dispatch_get_main_queue(), ^{[self sendFeaturesToDelegate:features afterProcessingPhoto:shrunkenImage];});
     });
     
     
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
