//
//  MeasureViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 05.08.12.
//
//

#import "MeasureViewController.h"

@interface MeasureViewController ()

@end

@implementation MeasureViewController

@synthesize sizeView, linImageView, whatToMeasureArray, source, pickingCanceled, sizesScrollView, activityIndicator, makeMeasurementsUsingTwoPhotos, infoButton, overlayViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.sizeView = nil;
    self.linImageView = nil;
    self.whatToMeasureArray = nil;
    self.sizesScrollView = nil;
    self.activityIndicator = nil;
    self.infoButton = nil;
    self.overlayViewController = nil;
    [photosDictionary release]; photosDictionary = nil;
    [firstPhotoMeasuresDictionary release]; firstPhotoMeasuresDictionary = nil;
    [measureManager release]; measureManager = nil;
    [featuresOnPhotos release]; featuresOnPhotos = nil;
    
}

- (void) dealloc
{
    [sizeView release];
    [linImageView release];
    [whatToMeasureArray release];
    [sizesScrollView release];
    [infoButton release];
    [activityIndicator release];
    [photosDictionary release];
    [firstPhotoMeasuresDictionary release];
    [overlayViewController release];
    [measureManager release];
    [featuresOnPhotos release];
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pickingCanceled = NO;
    
    PersonKind pKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
    measureManager = [[VSMeasureManager alloc] initWithPersonKind:pKind];
    
    /*
    UIBarButtonItem *resultButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Result", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(viewResults)] ;
    self.navigationItem.rightBarButtonItem = resultButton;
    [resultButton release];
     */
    
    self.title = NSLocalizedString(@"Measuring", nil);
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.sizeView addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
    [panRecognizer release];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.sizeView addGestureRecognizer:pinchRecognizer];
    pinchRecognizer.delegate = self;
    [pinchRecognizer release];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)] ;
    [self.sizeView addGestureRecognizer:rotationRecognizer];
    rotationRecognizer.delegate = self;
    [rotationRecognizer release];
    
    
    
    // initializing overlay view controller (custom camera)
    if (self.overlayViewController == nil)
    {
        NSString *nibName = nil;
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            nibName = @"ImageOverlayView568";
        }
        else{
            nibName = @"ImageOverlayView";
        }
        
        OverlayViewController *overlayController = [[OverlayViewController alloc] initWithNibName:nibName bundle:nil];
        self.overlayViewController = overlayController;
        self.overlayViewController.delegate = self;
        [overlayController release];
    }


    // preparing all human body parts to measure
    NSMutableDictionary *unsortedMeasureParams = [[NSMutableDictionary alloc] init];
    
    if (!self.whatToMeasureArray){
        NSMutableArray *stuffToFindOutSize = [[NSMutableArray alloc] initWithArray:[measureManager getStuffForSizeDefining]];
        self.whatToMeasureArray = stuffToFindOutSize;
        [stuffToFindOutSize release];
    }
    
    for (NSString *stuff in self.whatToMeasureArray) {
        NSArray *measureParams = [measureManager getMeasureParamsForStuffType:stuff];
        for (NSMutableArray *param in measureParams) {
            if ([unsortedMeasureParams objectForKey:param] == nil){
                [unsortedMeasureParams setObject:param forKey:param];
            }
        }
    }
    
    NSMutableArray *sortedMeasureParams = [[NSMutableArray alloc] init];
    //sorting measure params
    NSArray *orderedMeasureParams = [measureManager getOrderedMeasureParams];
    for (NSString *param in orderedMeasureParams) {
        if ([unsortedMeasureParams objectForKey:param] != nil){
            [sortedMeasureParams addObject:param];
        }
            
    }
    
    [unsortedMeasureParams release];
    //
    
    self.sizesScrollView.contentSize = CGSizeMake(self.sizesScrollView.frame.size.width , self.sizesScrollView.frame.size.height * [sortedMeasureParams count]);
    
        
    //self.sizesScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photo_screen_size_area.png"]];
    self.sizesScrollView.delegate = self;


    for (int i = 0; i < [sortedMeasureParams count]; i++) {
        
        [self createScrollViewScreenWithTag:i key:[sortedMeasureParams objectAtIndex:i] andMeasureParamsCount:[sortedMeasureParams count]];
    }
    
    [sortedMeasureParams release];
    
    photosDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
    firstPhotoMeasuresDictionary = [[NSMutableDictionary alloc] init];
    featuresOnPhotos = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    currentAngle = 0.0f;
    distanceBetweenEyes = -1.0f;
    
    distBwtEyesInSm  = 6.5f;
    
    currentPictureMode = main;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ((self.sizeView.image == nil) && (self.pickingCanceled == NO) && (![photosDictionary objectForKey:@"firstPhoto"]))
    {
        [self showImagePicker:self.source];
    }
    else
    {
        if (self.pickingCanceled == YES)
        {
            self.pickingCanceled = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.pickingCanceled = NO;
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark help funtions

-(float) getMeasureAdjustmentForPersonKind:(PersonKind) personKind bodyPart:(NSString *) bodyPart angle:(float) angle cameraDirection:(NSInteger) cDirection
{
    NSInteger intAngle = roundf(angle);
    
    if (intAngle > angle){
        intAngle = intAngle - 1;
    }
    
    float delta = 5 - (intAngle % 5)+ angle - intAngle;
    
    float adjustment = 0;
    
    if (personKind == Man){
        if ([bodyPart  isEqual: CHEST]){
            if (cDirection == FORWARD_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = (0.001f * delta) + 1.0f;
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = (0.0016f * delta) + 1.005f;
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = (0.01f * delta) + 1.013f;
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = (0.004f * delta) + 1.063f;
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = (0.004f * delta) + 1.083f;
                }
            }
            else if (cDirection == BACK_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = 1 - (0.002f * delta);
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = 0.990f - (0.004f * delta);
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = 0.970f - (0.006f * delta);
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = 0.940f - (0.008f * delta);
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = 0.900f - (0.01f * delta);
                }
                else if ((angle < 65) && (angle >=60)) {
                    adjustment = 0.850f - (0.012f * delta);
                }
                
            }
        }
        else if ([bodyPart  isEqual: WAIST]){
            if (cDirection == FORWARD_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = (0.006f * delta) + 1.0f;
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = (0.004f * delta) + 1.03f;
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = (0.01f * delta) + 1.05f;
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = (0.01f * delta) + 1.1f;
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = (0.01f * delta) + 1.15f;
                }
            }
            else if (cDirection == BACK_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = 1 - (0.0045f * delta);
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = 0.9775f - (0.006f * delta);
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = 0.9475f - (0.008f * delta);
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = 0.9075f - (0.0095f * delta);
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = 0.86f - (0.011f * delta);
                }
                else if ((angle < 65) && (angle >=60)) {
                    adjustment = 0.805f - (0.012f * delta);
                }
                
            }
            
        }

        else if ([bodyPart  isEqual: HIPS]){
            if (cDirection == FORWARD_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = (0.011f * delta) + 1.0f;
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = (0.004f * delta) + 1.055f;
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = (0.015f * delta) + 1.077f;
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = (0.011f * delta) + 1.152f;
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = (0.008f * delta) + 1.207f;
                }
            }
            else if (cDirection == BACK_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = 1 - (0.006f * delta);
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = 0.97f - (0.009f * delta);
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = 0.925f - (0.012f * delta);
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = 0.875f - (0.014f * delta);
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = 0.805f - (0.015f * delta);
                }
            }
        }
        
    }
    else if (personKind == Woman){
        
        if ([bodyPart  isEqual: CHEST]){
            if (cDirection == FORWARD_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = (0.001f * delta) + 1.0f;
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = (0.0016f * delta) + 1.005f;
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = (0.01f * delta) + 1.013f;
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = (0.004f * delta) + 1.063f;
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = (0.004f * delta) + 1.083f;
                }
            }
            else if (cDirection == BACK_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = 1 - (0.002f * delta);
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = 0.990f - (0.004f * delta);
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = 0.970f - (0.006f * delta);
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = 0.940f - (0.008f * delta);
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = 0.900f - (0.01f * delta);
                }
                else if ((angle < 65) && (angle >=60)) {
                    adjustment = 0.850f - (0.012f * delta);
                }
                
            }
        }
        else if ([bodyPart  isEqual: WAIST]){
            if (cDirection == FORWARD_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = (0.006f * delta) + 1.0f;
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = (0.004f * delta) + 1.03f;
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = (0.01f * delta) + 1.05f;
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = (0.01f * delta) + 1.1f;
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = (0.01f * delta) + 1.15f;
                }
            }
            else if (cDirection == BACK_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = 1 - (0.0045f * delta);
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = 0.9775f - (0.006f * delta);
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = 0.9475f - (0.008f * delta);
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = 0.9075f - (0.0095f * delta);
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = 0.86f - (0.011f * delta);
                }
                else if ((angle < 65) && (angle >=60)) {
                    adjustment = 0.805f - (0.012f * delta);
                }
                
            }
            
        }
        
        else if ([bodyPart  isEqual: HIPS]){
            if (cDirection == FORWARD_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = (0.011f * delta) + 1.0f;
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = (0.004f * delta) + 1.055f;
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = (0.015f * delta) + 1.077f;
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = (0.011f * delta) + 1.152f;
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = (0.008f * delta) + 1.207f;
                }
            }
            else if (cDirection == BACK_D){
                if ((angle < 90) && (angle >=85)){
                    adjustment = 1 - (0.006f * delta);
                }
                else if ((angle < 85) && (angle >=80)) {
                    adjustment = 0.97f - (0.009f * delta);
                }
                else if ((angle < 80) && (angle >=75)) {
                    adjustment = 0.925f - (0.012f * delta);
                }
                else if ((angle < 75) && (angle >=70)) {
                    adjustment = 0.875f - (0.014f * delta);
                }
                else if ((angle < 70) && (angle >=65)) {
                    adjustment = 0.805f - (0.015f * delta);
                }
            }
        }
        
        
    }
    
    return adjustment;
}



 - (void) showAndHideCurrentTip
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_TIPS_LAUNCHES]){
        
        NSInteger num = [[[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_TIPS_LAUNCHES] integerValue];
        if (num >= 3){
            return;
        }
        
    }
    
    NSInteger page = [self getScrollViewCurrentPage:self.sizesScrollView];
    
    TextFieldWithKey *currentView = (TextFieldWithKey *)[self.view viewWithTag:50+page];
    
    TutorialViewController *controller = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
    //controller.delegate = self;
    controller.bodyPartForAnimation = currentView.key;
    controller.personKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
    controller.pictureMode = currentPictureMode;
    controller.closeViewWhenAminationEnds = YES;
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:NULL];
    [controller release];
    
   
}


- (NSString *) getTipsImageNameForBodyPart:(NSString *)bodyPart mode:(pictureMode) mode
{
    NSString *imageName = @"";
    if (mode == main)
    {
        imageName = [bodyPart stringByAppendingString:@"_"];
        imageName = [imageName  stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]]];
    }
    else if (mode == side) 
    {
        imageName = [bodyPart stringByAppendingString:@"_side_"];
        imageName = [imageName  stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]]];

    }

    return imageName;
}

- (void) createScrollViewScreenWithTag:(NSInteger ) tag key:(NSString *) key andMeasureParamsCount:(NSInteger) count
{
    
    /*
    //info image
    ImageViewWithKey *infoImageView = [[ImageViewWithKey alloc] initWithFrame:CGRectMake(5, self.sizesScrollView.frame.size.height*tag+7, 40, 40)];
    infoImageView.contentMode = UIViewContentModeScaleToFill;
    //infoImageView.layer.masksToBounds = YES;
    //infoImageView.layer.cornerRadius = 5.0f;
    infoImageView.key = key;
    infoImageView.imageName = [self getTipsImageNameForBodyPart:key mode:main];
    infoImageView.userInteractionEnabled = YES;
    infoImageView.image = [UIImage imageNamed:@"infoBtn"];//[UIImage imageNamed:@"front_small_body.png"];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoImageTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [infoImageView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    [self.sizesScrollView addSubview:infoImageView];
    [infoImageView release];
     */

    //button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"photo_screen_btn.png"] forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(10, self.sizesScrollView.frame.size.height*tag+15, 70, self.sizesScrollView.frame.size.height-22)];
    backButton.titleLabel.font = [UIFont fontWithName:BUTTON_FONT size:PHOTO_SCREEN_BUTTON_FONT_SIZE];
    [backButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(scrollToPreviousStuff) forControlEvents:UIControlEventTouchUpInside];
    [self.sizesScrollView addSubview:backButton];

    
    
    UIImageView *placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.sizesScrollView.frame.size.height*tag+15, self.sizesScrollView.frame.size.width-80-50-10, self.sizesScrollView.frame.size.height-22)];
    //placeholderImageView.image = [UIImage imageNamed: @"photo_screen_measurement area.png"];
    placeholderImageView.contentMode = UIViewContentModeScaleToFill;
    
    
    // label
    //UILabel *hintLabel = [[UILabel alloc] initWithFrame: CGRectMake(55, self.sizesScrollView.frame.size.height*tag+15, placeholderImageView.frame.size.width/2+placeholderImageView.frame.size.width/4-10, self.sizesScrollView.frame.size.height-22)];
    UILabel *hintLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.sizesScrollView.frame.size.height*tag+15, self.sizesScrollView.frame.size.width, self.sizesScrollView.frame.size.height-22)];
    hintLabel.textColor = [UIColor darkGrayColor];
    hintLabel.font = [UIFont systemFontOfSize:20.0f];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.numberOfLines = 0;
    hintLabel.lineBreakMode = NSLineBreakByWordWrapping;
    hintLabel.textAlignment =NSTextAlignmentCenter;
    //hintLabel.text = [NSString stringWithFormat:@"(%d %@ %d) %@", tag+1, NSLocalizedString(@"of", nil), count, NSLocalizedString(key, nil)];
    hintLabel.text = NSLocalizedString(key, nil);
    
    [self.sizesScrollView addSubview:hintLabel];
    [hintLabel release];
    
    //label that show number of measures
    UILabel *countInfoLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.sizesScrollView.frame.size.height*tag+3, self.sizesScrollView.frame.size.width, 13)];
    countInfoLabel.textColor = MAIN_THEME_COLOR;
    countInfoLabel.font = [UIFont systemFontOfSize:11.0f];
    countInfoLabel.backgroundColor = [UIColor clearColor];
    countInfoLabel.numberOfLines = 0;
    countInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    countInfoLabel.textAlignment =NSTextAlignmentCenter;
    countInfoLabel.text = [NSString stringWithFormat:@"%ld %@ %ld", (long)tag+1, NSLocalizedString(@"of", nil), (long)count];
    
    [self.sizesScrollView addSubview:countInfoLabel];
    [countInfoLabel release];

    
    //text view
    TextFieldWithKey *tmpTextField = [[TextFieldWithKey alloc] initWithFrame: CGRectMake(55+placeholderImageView.frame.size.width - placeholderImageView.frame.size.width/4-10, self.sizesScrollView.frame.size.height*tag+15, placeholderImageView.frame.size.width/4, self.sizesScrollView.frame.size.height-22)];
    tmpTextField.tag = tag + 50;
    tmpTextField.backgroundColor = [UIColor clearColor];
    tmpTextField.borderStyle = UITextBorderStyleNone;
    tmpTextField.enabled = NO;
    tmpTextField.hidden = YES;
    tmpTextField.textAlignment = NSTextAlignmentCenter;
    //tmpTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    tmpTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tmpTextField.font = [UIFont fontWithName:MEASURE_VALUE_TEXT_FONT size:MEASURE_VALUE_TEXT_FONT_SIZE];
    [tmpTextField setTextColor:[UIColor colorWithRed:0.4f green:0.0f blue:0.6f alpha:1.0f]];
    tmpTextField.key = key;
    [self.sizesScrollView addSubview:tmpTextField];
    
    [tmpTextField release];
    
    
    [self.sizesScrollView addSubview:placeholderImageView];
    [placeholderImageView release];
    
    //button
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"photo_screen_btn.png"] forState:UIControlStateNormal];
    [tmpButton setFrame:CGRectMake(self.sizesScrollView.frame.size.width-80, self.sizesScrollView.frame.size.height*tag+15, 70, self.sizesScrollView.frame.size.height-22)];
    tmpButton.titleLabel.font = [UIFont fontWithName:BUTTON_FONT size:PHOTO_SCREEN_BUTTON_FONT_SIZE];
    [tmpButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [tmpButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [tmpButton addTarget:self action:@selector(addMeasure) forControlEvents:UIControlEventTouchUpInside];
    [self.sizesScrollView addSubview:tmpButton];

}

- (void) showAlertDialogWithTitle:(NSString *) title andMessage:(NSString *) message
{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(title, nil)
                          message:NSLocalizedString(message, nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK",nil)
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate setImagePickerControllerIsActive:TRUE];
    
    [self.overlayViewController setupImagePicker:sourceType];
    [self presentViewController:self.overlayViewController.imagePickerController animated:YES completion:NULL];
    
    NSString *imageName = @"";
    if (sourceType == UIImagePickerControllerSourceTypeCamera){
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            imageName = @"contour568_new.png";
        }
        else{
            imageName = @"contour_new.png";
        }
        
        [self.overlayViewController setContourImage:[UIImage imageNamed:@"contour"]];
    }
    else{
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            imageName = @"contour568_existing.png";
        }
        else{
            imageName = @"contour_existing.png";
        }
    }
    
    [self.overlayViewController setTipsContourImage:[UIImage imageNamed:imageName]];
    
}


- (void) processFeatures:(NSArray *) features
{
    self.linImageView.image = nil;
    self.linImageView = nil;
    currentAngle = 0.0f;
    leftEyePosition = CGPointMake(0.0f, 0.0f);
    
    CIFaceFeature *feature = [features objectAtIndex:0];
    
    distanceBetweenEyes = feature.rightEyePosition.x-feature.leftEyePosition.x;
    leftEyePosition     = CGPointMake(feature.leftEyePosition.x, self.sizeView.frame.size.height - feature.leftEyePosition.y);
                
    float rulerWidth = distanceBetweenEyes*4.0f;
    float rulerHeight = distanceBetweenEyes/2.5f;
               
    CGPoint rulerCenter = CGPointMake(self.view.center.x, self.view.center.y);
    
    CGRect rulerRect = CGRectMake(rulerCenter.x-rulerWidth/2, rulerCenter.y-rulerHeight/2, rulerWidth, rulerHeight);
    
    
    
    if (self.linImageView == nil)
    {
        
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:rulerRect];
        self.linImageView = tmpImageView;
        [tmpImageView release];
        [self.linImageView setCenter:rulerCenter];
        self.linImageView.image = [UIImage imageNamed:@"ruler.png"];
        self.linImageView.alpha = 0;
        [self.sizeView addSubview:self.linImageView];
        
    }
    else
    {
        if (self.linImageView.image  == nil)
        {
            self.linImageView.image = [UIImage imageNamed:@"ruler.png"];
        }
        self.linImageView.alpha = 0;
        [self.linImageView setFrame:rulerRect];
        [self.linImageView setCenter:rulerCenter];
        if (self.linImageView.superview == nil)
        {
            [self.sizeView addSubview:self.linImageView];
        }
    }
    
    
    
    /*
    UIView *eyeView = [self.sizeView viewWithTag:100];
    if (!eyeView){
        eyeView = [[UIView alloc] init];
        eyeView.frame = CGRectMake(0, 0, (distanceBetweenEyes/2) * 0.373f, (distanceBetweenEyes/2) * 0.373f);
        eyeView.center = leftEyePosition;
        eyeView.alpha = 0.3f;
        eyeView.tag = 100;
        eyeView.backgroundColor =[UIColor whiteColor];
        [self.sizeView addSubview:eyeView];
    }
    else{
        eyeView.frame = CGRectMake(0, 0, (distanceBetweenEyes/2) * 0.373f, (distanceBetweenEyes/2) * 0.373f);
        eyeView.center = leftEyePosition;
    }
    */
    
    
    self.sizesScrollView.hidden = NO;
    self.infoButton.hidden = NO;
    
    [UIView animateWithDuration:1.2f animations:^{
        self.linImageView.alpha = 0.6;
        self.sizesScrollView.alpha = 0.8f;
        self.infoButton.alpha = 1.0f;
        
    }
    completion:^(BOOL finished) {
        //[self setRulerPosition:self.linImageView];
    }];
    

}

- (float) getValueFromTextFieldWithKey:(NSString *) key
{
    for (UIView *tmpView in self.sizesScrollView.subviews) {
        if ([tmpView isKindOfClass:[TextFieldWithKey class]]){
            NSString *textFieldKey = ((TextFieldWithKey *)tmpView).key;
            if ([textFieldKey isEqualToString:key]){
                return [((TextFieldWithKey *)tmpView).text floatValue];
            }
        }
    }

    return 0.0f;
}

- (NSInteger) getScrollViewCurrentPage:(UIScrollView *) scrollView
{
    CGFloat pageHeight = scrollView.frame.size.height;
    return  floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
}

- (void) setRulerPosition:(UIImageView *) ruler
{
    NSInteger page = [self getScrollViewCurrentPage:self.sizesScrollView];
    TextFieldWithKey *currentView = (TextFieldWithKey *)[self.view viewWithTag:50+page];
    NSString *currentBodyPart = currentView.key;
    
    CGPoint newRulerCenter = CGPointMake(self.view.center.x, self.view.center.y);
    
    if ([currentBodyPart isEqualToString:CHEST]){
        newRulerCenter = CGPointMake(leftEyePosition.x+distanceBetweenEyes/2, leftEyePosition.y+distanceBetweenEyes*5.5f);
    }
    else if ([currentBodyPart isEqualToString:UNDER_CHEST]){
        newRulerCenter = CGPointMake(leftEyePosition.x+distanceBetweenEyes/2, leftEyePosition.y+distanceBetweenEyes*6.5f);
    }
    else if ([currentBodyPart isEqualToString:WAIST]){
        newRulerCenter = CGPointMake(leftEyePosition.x+distanceBetweenEyes/2, leftEyePosition.y+distanceBetweenEyes*8.0f);
    }
    else if ([currentBodyPart isEqualToString:HIPS]){
        newRulerCenter = CGPointMake(leftEyePosition.x+distanceBetweenEyes/2, leftEyePosition.y+distanceBetweenEyes*11.0f);
    }
    
    [UIView animateWithDuration:1.2f animations:^{
        ruler.center = newRulerCenter;
    }
         completion:^(BOOL finished) {
             
         }];
    
}

#pragma mark actions


- (void) scrollToPreviousStuff
{
    NSInteger page = [self getScrollViewCurrentPage:self.sizesScrollView];
    if (page > 0) {
        CGRect currentFrame = self.sizesScrollView.frame;
        currentFrame.origin.y = currentFrame.size.height * (page-1);
        [self.sizesScrollView scrollRectToVisible:currentFrame animated:YES];
    }
    else if ((page == 0) && (self.sizeView.image == [photosDictionary objectForKey:@"secondPhoto"])){
        self.sizeView.image = [photosDictionary objectForKey:@"firstPhoto"];
        [self processFeatures:[featuresOnPhotos objectForKey:@"featuresOnFirstPhoto"]];
    }
  

    
}

- (IBAction) showTips:sender
{
    /*
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    controller.numberOfPageToShow = 3;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    */
    
    
    NSInteger currentPage = [self getScrollViewCurrentPage:self.sizesScrollView];
    TextFieldWithKey *currentField = (TextFieldWithKey *)[self.sizesScrollView viewWithTag:50+currentPage];
    
    if (currentField){
        [[LocalyticsSession shared] tagEvent:@"Photo tip tapped"];

        TutorialViewController *controller = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
        //controller.delegate = self;
        controller.bodyPartForAnimation = currentField.key;
        controller.personKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
        controller.pictureMode = currentPictureMode;
        controller.closeViewWhenAminationEnds = NO;
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:controller animated:YES completion:NULL];
        [controller release];
    }
}

- (void)infoImageTap:(UITapGestureRecognizer *)tapRecognizer
{
    
    [[LocalyticsSession shared] tagEvent:@"Photo tip tapped"];
    
    ImageViewWithKey *tappedImageView = (ImageViewWithKey *)tapRecognizer.view;
   
    TutorialViewController *controller = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
    //controller.delegate = self;
    controller.bodyPartForAnimation = tappedImageView.key;
    controller.personKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
    controller.pictureMode = currentPictureMode;
    controller.closeViewWhenAminationEnds = NO;
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:NULL];
    [controller release];


}



- (void)viewResults
{
    [[LocalyticsSession shared] tagEvent:@"Results before saving"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_TIPS_LAUNCHES]){
        
        NSInteger num = [[[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_TIPS_LAUNCHES] integerValue];
        if (num < 4){
            
            num = num + 1;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:num] forKey:NUMBER_OF_TIPS_LAUNCHES];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:NUMBER_OF_TIPS_LAUNCHES];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    for (NSString *object in self.whatToMeasureArray) {
        
        NSMutableArray *results = [[NSMutableArray alloc] init];
        //adding main size
        [results addObject:[NSNumber numberWithInteger: SIZE_DEFINED]];
        //saving data in current profile
        [[[VSProfileManager sharedProfileManager] currentProfile] setObject:results forKey: object];
        
        //saving body params
        for (UIView *tmpView in self.sizesScrollView.subviews) {
            if ([tmpView isKindOfClass:[TextFieldWithKey class]]){
                [[[VSProfileManager sharedProfileManager] currentProfile] setObject:[NSNumber numberWithFloat: [((TextFieldWithKey *)tmpView).text floatValue]] forKey: ((TextFieldWithKey *)tmpView).key];
                                   
            }
        }

        [results release];
    }
    
    //saving profile
    [[VSProfileManager sharedProfileManager] saveDataWithKey:[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:@"searchingKey"]
                                              oldKey:[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:@"searchingKey"]
                                       andDictionary:[[VSProfileManager sharedProfileManager] currentProfile]];
    //updating profile
    [[VSProfileManager sharedProfileManager] getProfilesList];
    

    ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
    //resultController.backButton = rootButton;
    resultController.backButton = standartButton;
    resultController.editButton = saveAsButton;
    //resultController.measuredStuff = self.whatToMeasureArray;
    //resultController.measuredStuff = [measureManager getAllStuffWithTheSameMeasureParams:self.whatToMeasureArray];
    [self.navigationController pushViewController:resultController animated:YES];
    [resultController release];


}


-(void)addMeasure
{
    
    NSInteger page = [self getScrollViewCurrentPage:self.sizesScrollView];
    
    TextFieldWithKey *currentView = (TextFieldWithKey *)[self.view viewWithTag:50+page];
    
    
    CGFloat measure = 0.0f;
    
    CGFloat rAngle = fabs(currentAngle) * 180 / M_PI;
    
    if (rAngle > 360){
        CGFloat n = round(rAngle/360);
        rAngle = rAngle - n*360;
    }
    
    CGFloat linWidth = self.linImageView.frame.size.width;
    CGFloat linHeight = self.linImageView.frame.size.height;
    
    if (rAngle < 90)  {
        
    }
    else if (rAngle < 180)  {
        rAngle = 180 - rAngle;
    }
    else if (rAngle < 270)  {
        rAngle = rAngle-180;
    }
    else if (rAngle < 360)  {
        rAngle = 360 - rAngle;
    }
    
    
    rAngle = rAngle * M_PI/180;
    
    measure = (linWidth*cosf(rAngle) - linHeight*sinf(rAngle))/cosf(rAngle*2);
    
    float koef = 1;
    
    if (!makeMeasurementsUsingTwoPhotos){
        
        koef = [measureManager getMeasureCoefficientForBodyParam:currentView.key];
        //koef = 1;
    }
  
    //NSLog(@"dbe - %f", distanceBetweenEyes);
    measure = measure/((distanceBetweenEyes/2) * 0.374f) * 1.2f; // 1.2 - diameter zrachka
    
    
    if (makeMeasurementsUsingTwoPhotos){
        if (([firstPhotoMeasuresDictionary objectForKey:[self getStringKeyFromTag:50+page]]) && (self.sizeView.image == [photosDictionary objectForKey:@"secondPhoto"])){
            
            PersonKind pKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
            
            float adjustment = [self getMeasureAdjustmentForPersonKind:pKind bodyPart:currentView.key angle:angleWhenUserTookSecondPhoto cameraDirection:cameraDirectionWhenUserTookSecondPhoto];
            
            //NSLog(@"sadj - %f", adjustment);
            //NSLog(@"sang - %f", angleWhenUserTookSecondPhoto);
            if (adjustment != 0){
                measure = measure * adjustment;
            }
            
            if (([currentView.key isEqualToString:FOOT]) || ([currentView.key isEqualToString:INSIDE_LEG])){
                //don't calculate ellipse length 
            }
            else{
                
                float firstMeasure = [[firstPhotoMeasuresDictionary objectForKey:[self getStringKeyFromTag:50+page]] floatValue];
                //priamougolnik perimetr
                float perimetrPr = (firstMeasure*2) + (measure*2);
                
                float frontProection = firstMeasure;
                float sideProection = measure;
                
                measure = measure / 2;
                firstMeasure = firstMeasure/2;
                //ellipse
                float ellipsePer = 4*((M_PI * firstMeasure * measure+((firstMeasure - measure)*(firstMeasure - measure)))/(firstMeasure + measure));
                
                measure = (0.2f * perimetrPr) + (0.8f * ellipsePer);
                
                
                if ([[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind] == Woman){
                    if ([currentView.key isEqualToString:CHEST]){
                        measure = (0.25f * perimetrPr) + (0.75f * ellipsePer);
                    }
                    else if ([currentView.key isEqualToString:WAIST]){
                        measure = M_PI_2*(frontProection + sideProection);
                    }
                    else if ([currentView.key isEqualToString:HIPS]){
                        measure = (0.2f * perimetrPr) + (0.8f * ellipsePer);
                    }

                }
                else if ([[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind] == Man){
                    if ([currentView.key isEqualToString:CHEST]){
                        measure = (0.35f * perimetrPr) + (0.65f * ellipsePer);
                    }
                    else if ([currentView.key isEqualToString:WAIST]){
                        measure = (0.1f * perimetrPr) + (0.9f * ellipsePer);
                    }
                    else if ([currentView.key isEqualToString:HIPS]){
                        measure = (0.12f * perimetrPr) + (0.88f * ellipsePer);
                    }
                }
                
                
                //before
                //measure = 4*((M_PI * firstMeasure * measure+((firstMeasure - measure)*(firstMeasure - measure)))/(firstMeasure + measure));

                
            }
        }
        else{
            
            PersonKind pKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
            
            float adjustment = [self getMeasureAdjustmentForPersonKind:pKind bodyPart:currentView.key angle:angleWhenUserTookFirstPhoto cameraDirection:cameraDirectionWhenUserTookFirstPhoto];
            
            //NSLog(@"fadj - %f", adjustment);
            //NSLog(@"fang - %f", angleWhenUserTookFirstPhoto);
            
            if (adjustment != 0){
                measure = measure * adjustment;
            }
            
            [firstPhotoMeasuresDictionary setObject:[NSNumber numberWithFloat:measure] forKey:[self getStringKeyFromTag:50+page]];
        }
    }
    
    if (currentView){
       currentView.text = [NSString stringWithFormat:@"%.2f", measure*koef];
    }
    
    if (self.sizesScrollView.contentSize.height == self.sizesScrollView.frame.size.height * (page+1)){
        if (makeMeasurementsUsingTwoPhotos){
            [self performSelector:@selector(prepareSecondPhoto) withObject:nil afterDelay:0.3f];
        }
    }
    else{
        [self performSelector:@selector(scrollViewToNewPos) withObject:nil afterDelay:0.3f];
    }
}

- (void) scrollViewToNewPos
{
   
    NSInteger page = [self getScrollViewCurrentPage:self.sizesScrollView];
    CGRect currentFrame = self.sizesScrollView.frame;
    currentFrame.origin.y = currentFrame.size.height * (page+1);
    [self.sizesScrollView scrollRectToVisible:currentFrame animated:YES];
    
    //[self showAndHideCurrentTip];
    //[self setRulerPosition:self.linImageView];
    [self performSelector:@selector(showAndHideCurrentTip) withObject:nil afterDelay:1.0f];
}


- (void) prepareSecondPhoto
{
    
    // version without rotated head on the second photo
    /*
    if (self.sizeView.image != [photosDictionary objectForKey:@"secondPhoto"]){
        self.sizeView.image = [photosDictionary objectForKey:@"secondPhoto"];
        [self.sizesScrollView scrollRectToVisible:self.sizesScrollView.frame animated:YES];
        
    }
     */
    
    if (self.sizeView.image != [photosDictionary objectForKey:@"secondPhoto"]){
        self.sizeView.image = [photosDictionary objectForKey:@"secondPhoto"];
        if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ){
            [self.sizesScrollView scrollRectToVisible:self.sizesScrollView.frame animated:YES];
        }
        else{
            [self.sizesScrollView scrollRectToVisible:CGRectMake(0, 0, self.sizesScrollView.frame.size.width, self.sizesScrollView.frame.size.height) animated:YES];
        }
        [self processFeatures:[featuresOnPhotos objectForKey:@"featuresOnSecondPhoto"]];
        currentPictureMode = side;
        //[self showAndHideCurrentTip];
        [self performSelector:@selector(showAndHideCurrentTip) withObject:nil afterDelay:1.0f];
        //changing images to side
        for (UIView *tmpView in self.sizesScrollView.subviews) {
            if ([tmpView isKindOfClass:[ImageViewWithKey class]]){
                ImageViewWithKey *imageView = (ImageViewWithKey *)tmpView;
                imageView.imageName = [self getTipsImageNameForBodyPart:imageView.key mode:side];
                imageView.image = [UIImage imageNamed:@"infoBtn"];//[UIImage imageNamed:[self getTipsImageNameForBodyPart:imageView.key mode:side]];
            }
        }

    }
    else{
        [self viewResults];
    }
    
    
        
}

- (NSString *) getStringKeyFromTag:(NSInteger) tag
{
    return [NSString stringWithFormat:@"%ld", (long)tag ];
}



#pragma mark - Gesture Recognizers


- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    CGPoint translation = [panRecognizer translationInView:self.sizeView];
    translation.x = translation.x/2; // /2 - to decrease the speed of paning
    translation.y = translation.y/2;
    
    CGPoint lineImageViewPosition = self.linImageView.center;
    lineImageViewPosition.x += translation.x;
    lineImageViewPosition.y += translation.y;
    
    self.linImageView.center = lineImageViewPosition;
    
    
    [panRecognizer setTranslation:CGPointZero inView:self.sizeView];
    
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    CGFloat scale = pinchRecognizer.scale-1;
    //CGFloat scale = pinchRecognizer.scale;
    scale = scale/3+1;
    
    self.linImageView.transform = CGAffineTransformScale(self.linImageView.transform, scale, scale);
    
    pinchRecognizer.scale = 1.0f;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    CGFloat angle = rotationRecognizer.rotation;
    
    // to avoid angle changing more than 1
    if (angle < 0) {
        angle = angle*(-1);
        if (angle > 1){
            while (angle > 1) {
                angle = angle-1;
            }
        }
        angle = angle*(-1);
    }
    else {
        if (angle > 1){
            while (angle > 1) {
                angle = angle-1;
            }
        }
    }
    //decreasing speed of rotation
    angle = angle/6;
    
    
    currentAngle = currentAngle + angle;
    //doesn't allow to rotate ruler more than 10 degrees
    if ((currentAngle > 0.17f) || (currentAngle < -0.17f)) {
        if (currentAngle > 0.17f){
            currentAngle = 0.17f;
        }
        else if (currentAngle < -0.17f){
            currentAngle = -0.17f;
        }
    }
    else{
        self.linImageView.transform = CGAffineTransformRotate(self.linImageView.transform, angle);
    }
       
    rotationRecognizer.rotation = 0.0f;
   
}

#pragma mark OverlayViewControllerDelegate

-(void) didTakePhoto:(UIImage *)photo withAngle:(float)angle cameraDirection:(NSInteger)cDirection andReceiveFeatures:(NSArray *)features
{
    if (makeMeasurementsUsingTwoPhotos)  {
        
        if (![photosDictionary objectForKey:@"firstPhoto"]){
            
            if (!features){
                if (self.source == UIImagePickerControllerSourceTypeCamera){
                    [self showAlertDialogWithTitle:@"" andMessage:@"CantFindBodyOnNewPictureFailMessage"];
                }
                else{
                    [self showAlertDialogWithTitle:@"" andMessage:@"CantFindBodyOnExistingPictureFailMessage"];
                }
                
                [[LocalyticsSession shared] tagEvent:@"Human not detected"];
            }
            else{
                [photosDictionary setObject:photo forKey:@"firstPhoto"];
                [featuresOnPhotos setObject:features forKey:@"featuresOnFirstPhoto"];
                angleWhenUserTookFirstPhoto = angle;
                cameraDirectionWhenUserTookFirstPhoto = cDirection;
                
                NSString *imageName = @"";
                if (self.source == UIImagePickerControllerSourceTypeCamera){
                    if ([[UIScreen mainScreen] bounds].size.height == 568){
                        imageName = @"contour_side568_new.png";
                    }
                    else{
                        imageName = @"contour_side_new.png";
                    }
                    [self.overlayViewController setContourImage:[UIImage imageNamed:@"side_contour"]];
                }
                else{
                    if ([[UIScreen mainScreen] bounds].size.height == 568){
                        imageName = @"contour_side568_existing.png";
                    }
                    else{
                        imageName = @"contour_side_existing.png";
                    }
                }
                [self.overlayViewController setTipsContourImage:[UIImage imageNamed:imageName]];
            }
            
        }
        else{
            /*
            //version without rotated head on the second photo
            [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
            [photosDictionary setObject:photo forKey:@"secondPhoto"];
            self.sizeView.image = [photosDictionary objectForKey:@"firstPhoto"];
            [self processFeatures:[featuresOnPhotos objectForKey:@"featuresOnFirstPhoto"]];
            */
            

            if (!features){
                if (self.source == UIImagePickerControllerSourceTypeCamera){
                    [self showAlertDialogWithTitle:@"" andMessage:@"CantFindBodyOnNewPictureFailMessage"];
                }
                else{
                    [self showAlertDialogWithTitle:@"" andMessage:@"CantFindBodyOnExistingPictureFailMessage"];
                }
                
                [[LocalyticsSession shared] tagEvent:@"Human not detected"];
            }
            else{
                [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
                //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                //[appDelegate setImagePickerControllerIsActive:FALSE];
                angleWhenUserTookSecondPhoto = angle;
                cameraDirectionWhenUserTookSecondPhoto = cDirection;
                [photosDictionary setObject:photo forKey:@"secondPhoto"];
                [featuresOnPhotos setObject:features forKey:@"featuresOnSecondPhoto"];
                self.sizeView.image = [photosDictionary objectForKey:@"firstPhoto"];
                [self processFeatures:[featuresOnPhotos objectForKey:@"featuresOnFirstPhoto"]];
                [self performSelector:@selector(showAndHideCurrentTip) withObject:nil afterDelay:1.0f];
                
                
                if (self.source == UIImagePickerControllerSourceTypeCamera){
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 60)];
                    [label setCenter: self.view.center];
                    [label setTextColor: [UIColor whiteColor]];
                    [label setFont: [UIFont systemFontOfSize:16.0f]];
                    [label setBackgroundColor: [UIColor darkGrayColor]];
                    [label setNumberOfLines: 0];
                    [label setLineBreakMode: NSLineBreakByWordWrapping];
                    [label setTextAlignment: NSTextAlignmentCenter];
                    [label setAlpha:0.0f];
                    [label setText:NSLocalizedString(@"Photos have been saved", nil)];
                    
                    [self.view addSubview:label];
                    
                    [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                        label.alpha = 0.8f;
                    }
                                     completion:^(BOOL finished) {
                                         [UIView animateWithDuration:1.0f delay:1.5f options:UIViewAnimationOptionCurveLinear animations:^{
                                             label.alpha = 0.0f;
                                         }
                                                          completion:^(BOOL finished) {
                                                              [label removeFromSuperview];
                                                              [label release];
                                                          }];
                                     }];
                    
                }

                
                [[LocalyticsSession shared] tagEvent:@"Measuring starts"];
             }
            
        }
    }
    else{
        if (!features){
            [self showAlertDialogWithTitle:@"" andMessage:@"Bad photo!"];
            [[LocalyticsSession shared] tagEvent:@"Human not detected"];
        }
        else{
            [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
            self.sizeView.image = photo;
            [self processFeatures:features];
            [[LocalyticsSession shared] tagEvent:@"Measuring starts"];
        }
        
    }
}


// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate setImagePickerControllerIsActive:FALSE];
    [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
   
}

- (void)didCancelWithCamera
{
    self.pickingCanceled = YES;
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate setImagePickerControllerIsActive:FALSE];

    [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    
    [[VSProfileManager sharedProfileManager] deleteTempProfile];
    [[VSProfileManager sharedProfileManager] getProfilesList];
}



- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.pickingCanceled = YES;
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate setImagePickerControllerIsActive:FALSE];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



#pragma mark alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
#pragma mark tutorial view delegate methods
- (void)TutorialViewControllerDidFinish:(TutorialViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];

}



@end
