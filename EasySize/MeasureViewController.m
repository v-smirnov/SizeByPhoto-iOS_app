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
    [allStuffToMeasureDictionary release]; allStuffToMeasureDictionary = nil;
    [measureObjects release]; measureObjects = nil;
    [photosDictionary release]; photosDictionary = nil;
    [firstPhotoMeasuresDictionary release]; firstPhotoMeasuresDictionary = nil;
    
}

- (void) dealloc
{
    [sizeView release];
    [linImageView release];
    [whatToMeasureArray release];
    [allStuffToMeasureDictionary release];
    [measureObjects release];
    [sizesScrollView release];
    [infoButton release];
    [activityIndicator release];
    [photosDictionary release];
    [firstPhotoMeasuresDictionary release];
    [overlayViewController release];
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pickingCanceled = NO;
    measureDidFail = NO;
      
    UIBarButtonItem *resultButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Result", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(viewResults)] ;
    self.navigationItem.rightBarButtonItem = resultButton;
    [resultButton release];


    
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

    
    allStuffToMeasureDictionary = [[[MeasureManager sharedMeasureManager] getClothesMeasureParamsForPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]] retain];
    
    // preparing all human body parts to measure
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    for (NSString *object in self.whatToMeasureArray) {
        NSMutableArray *tmpArray = [allStuffToMeasureDictionary objectForKey:object];
        for (NSMutableArray *mArray in tmpArray) {
            if ([tempDict objectForKey:[mArray objectAtIndex:0]] == nil){
                [tempDict setObject:[mArray objectAtIndex:0] forKey:[mArray objectAtIndex:0]];
            }
        }
    }
    
    measureObjects = [[NSMutableArray alloc] init];
    //sorting measure params
    NSArray *orderedMeasureParams = [[MeasureManager sharedMeasureManager] getOrderedMeasureParams];
    for (NSString *param in orderedMeasureParams) {
        if ([tempDict objectForKey:param] != nil){
            [measureObjects addObject:param];
        }
            
    }
    
    [tempDict release];
    //
    
    self.sizesScrollView.contentSize = CGSizeMake(self.sizesScrollView.frame.size.width , self.sizesScrollView.frame.size.height * [measureObjects count]);
    
        
    self.sizesScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.sizesScrollView.delegate = self;


    for (int i = 0; i < [measureObjects count]; i++) {
        
        [self createScrollViewScreenWithTag:i andKey:[measureObjects objectAtIndex:i]];
    }
    
    photosDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
    firstPhotoMeasuresDictionary = [[NSMutableDictionary alloc] init];
    
    currentAngle = 0.0f;
    distanceBetweenEyes = -1.0f;
    
    distBwtEyesInSm  = 6.5f;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ((self.sizeView.image == nil) && (self.pickingCanceled == NO) && (![photosDictionary objectForKey:@"firstPhoto"]))
    {
        [self showImagePicker:self.source forPictureMode:0]; //0 - main mode 
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

#pragma mark selectors
- (void) performActionFromTheList
{
    /*
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"Take a new photo", nil),
                                     NSLocalizedString(@"Choose existing photo", nil), NSLocalizedString(@"View result", nil), nil];
        
        [startSheet showInView:self.view];
        [startSheet release];
    }
    else
    {
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"Choose existing photo", nil), NSLocalizedString(@"View result", nil), nil];
        
        [startSheet showInView:self.view];
        [startSheet release];
        
    }
     */
    UIActionSheet *startSheet = [[UIActionSheet alloc]
                                 initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:NSLocalizedString(@"View result", nil), nil];
    
    [startSheet showInView:self.view];
    [startSheet release];

}


#pragma mark help funtions

- (NSString *) getTipsImageNameForBodyPart:(NSString *)bodyPart mode:(NSInteger) mode
{
    NSString *imageName = @"";
    if (mode == 0) // main
    {
        imageName = [bodyPart stringByAppendingString:@"_"];
        imageName = [imageName  stringByAppendingString:[NSString stringWithFormat:@"%d", [[MeasureManager sharedMeasureManager] getCurrentProfileGender]]];
    }
    else if (mode == 1) //side
    {
        imageName = [bodyPart stringByAppendingString:@"_side_"];
        imageName = [imageName  stringByAppendingString:[NSString stringWithFormat:@"%d", [[MeasureManager sharedMeasureManager] getCurrentProfileGender]]];

    }
    
    //NSLog(@"%@", imageName);
    return imageName;
}

- (void) createScrollViewScreenWithTag:(NSInteger ) tag andKey:(NSString *) key
{
    
    // label
    UILabel *hintLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.sizesScrollView.frame.size.height*tag+5, 110, self.sizesScrollView.frame.size.height-10)];
    hintLabel.textColor = [UIColor blackColor];
    hintLabel.font = [UIFont systemFontOfSize:13.0f];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.numberOfLines = 0;
    hintLabel.lineBreakMode = UILineBreakModeWordWrap;
    hintLabel.textAlignment =UITextAlignmentCenter;
    hintLabel.text = [NSString stringWithFormat:@"(%d %@ %d) %@", tag+1, NSLocalizedString(@"of", nil), [measureObjects count], NSLocalizedString(key, nil)];
    
    [self.sizesScrollView addSubview:hintLabel];
    [hintLabel release];

    //text view
    TextFieldWithKey *tmpTextField = [[TextFieldWithKey alloc] initWithFrame: CGRectMake(115, self.sizesScrollView.frame.size.height*tag+5, 70, self.sizesScrollView.frame.size.height-10)];
    tmpTextField.tag = tag + 50;
    tmpTextField.backgroundColor = [UIColor whiteColor];
    tmpTextField.borderStyle = UITextBorderStyleLine;
    tmpTextField.enabled = NO;
    tmpTextField.textAlignment = UITextAlignmentCenter;
    //tmpTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    tmpTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tmpTextField.font = [UIFont systemFontOfSize:14.0f];
    tmpTextField.key = key;
    [self.sizesScrollView addSubview:tmpTextField];
    
    [tmpTextField release];
    
    //info image
    ImageViewWithKey *infoImageView = [[ImageViewWithKey alloc] initWithFrame:CGRectMake(195, self.sizesScrollView.frame.size.height*tag+5, 30, self.sizesScrollView.frame.size.height-10)];
    infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    //infoImageView.layer.masksToBounds = YES;
    //infoImageView.layer.cornerRadius = 5.0f;
    infoImageView.key = key;
    infoImageView.userInteractionEnabled = YES;
    infoImageView.image = [UIImage imageNamed:[self getTipsImageNameForBodyPart:key mode:0]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoImageTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [infoImageView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    [self.sizesScrollView addSubview:infoImageView];
    [infoImageView release];

    //button
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setBackgroundImage:[UIImage imageNamed:@"grayBtnBackground.png"] forState:UIControlStateNormal];
    [tmpButton setFrame:CGRectMake(self.sizesScrollView.frame.size.width-60, self.sizesScrollView.frame.size.height*tag+5, 50, self.sizesScrollView.frame.size.height-10)];
    tmpButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [tmpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tmpButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [tmpButton addTarget:self action:@selector(addMeasure) forControlEvents:UIControlEventTouchUpInside];
    [self.sizesScrollView addSubview:tmpButton];
}

- (void) showAlertDialogWithTitle:(NSString *) title andMessage:(NSString *) message{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(title, nil)
                          message:NSLocalizedString(message, nil)
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType forPictureMode:(NSInteger) pMode
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setImagePickerControllerIsActive:TRUE];
    
    [self.overlayViewController setupImagePicker:sourceType forPictureMode:(NSInteger) pMode];
    [self presentViewController:self.overlayViewController.imagePickerController animated:YES completion:NULL];
    
}


- (void) processPhoto:(NSArray *) features
{
    self.linImageView.image = nil;
    self.linImageView = nil;
    currentAngle = 0.0f;
    
    BOOL eyesRecognized = NO;
    
    NSString *failMessage = nil;
    
    if ([features count] > 1)
    {
        failMessage = @"There are too many people on the photo or bad conditions!";
    }
    else
    {
        for (CIFaceFeature *feature in features)
        {
            
            if ((feature.hasRightEyePosition) & (feature.hasLeftEyePosition) & (feature.hasMouthPosition))
            {
                
                eyesRecognized = YES;
                distanceBetweenEyes = feature.rightEyePosition.x-feature.leftEyePosition.x;
                
                
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
                
                
                
            }
        }
    }
    
    [self.activityIndicator stopAnimating];
    // eyes don't recognized
    if (eyesRecognized == NO)
    {
        self.sizeView.image = nil;
        self.linImageView.image = nil;
        measureDidFail = YES;
        
        if (!failMessage)
        {
            failMessage = @"Can't see the body";
        }

        [self showAlertDialogWithTitle:@"Warning" andMessage:failMessage];
    }
    else {
        measureDidFail = NO;
        /*
        UIView *eyeView = [self.sizeView viewWithTag:100];
        if (!eyeView){
            eyeView = [[UIView alloc] init];
            eyeView.frame = CGRectMake(0, 0, (distanceBetweenEyes/2) * 0.373f, (distanceBetweenEyes/2) * 0.373f);
            eyeView.center = leftEyePos;
            eyeView.alpha = 0.3f;
            eyeView.tag = 100;
            eyeView.backgroundColor =[UIColor whiteColor];
            [self.sizeView addSubview:eyeView];
        }
        else{
            eyeView.frame = CGRectMake(0, 0, (distanceBetweenEyes/2) * 0.373f, (distanceBetweenEyes/2) * 0.373f);
            eyeView.center = leftEyePos;
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
             
        }];
        
    }
    
}

- (float) getValueFromTextFieldWithKey:(NSString *) key
{
    for (UIView *tmpView in self.sizesScrollView.subviews) {
        if ([tmpView isKindOfClass:[TextFieldWithKey class]]){
            NSString *textFieldKey = ((TextFieldWithKey *)tmpView).key;
            if ([textFieldKey isEqualToString:key]){
                //NSLog(@"View key - %@, value - %f", ((TextFieldWithKey *)tmpView).key, [((TextFieldWithKey *)tmpView).text floatValue]);
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

#pragma mark actions
- (IBAction) showTips:sender
{
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    controller.numberOfPageToShow = 3;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)infoImageTap:(UITapGestureRecognizer *)tapRecognizer
{
    UIImageView *tappedImageView = (UIImageView *)tapRecognizer.view;
    
    CGRect newFrame = CGRectMake(0, 0, self.sizeView.frame.size.width, self.sizeView.frame.size.height);
    
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:newFrame];
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else{
        bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    bigImageView.userInteractionEnabled = YES;
    bigImageView.center = self.sizeView.center;
    bigImageView.image = tappedImageView.image;
    bigImageView.alpha = 0.0f;
    
    UITapGestureRecognizer *tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageTap:)];
    tapRecognizer_.numberOfTapsRequired = 1;
    [bigImageView addGestureRecognizer:tapRecognizer_];
    [tapRecognizer_ release];
    
    [self.view addSubview:bigImageView];
    
    
    [UIView animateWithDuration:1.0f animations:^{
        bigImageView.alpha = 1.0f;
    }
                     completion:^(BOOL finished) {
                     }];
    
    [bigImageView release];
    
}
- (void)bigImageTap:(UITapGestureRecognizer *)tapRecognizer
{
    [UIView animateWithDuration:1.0f animations:^{
        tapRecognizer.view.alpha = 0.0f;
    }
                     completion:^(BOOL finished) {
                         [tapRecognizer.view removeFromSuperview];
                     }];
}


- (void)viewResults
{
    
    // if was not measured all stuff we ask user about updating sizes for other clothes
    // else just showing the result
    //if ([[[MeasureManager sharedMeasureManager] getClothesListForPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]] count] != [self.whatToMeasureArray count]){
    if ([[MeasureManager sharedMeasureManager] needToUpdateSizesForClothesWithTheSameParameters:self.whatToMeasureArray forPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]]){
        
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"", nil)
                              message:NSLocalizedString(@"updateMessage", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"No",nil)
                              otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
        [alert show];
        [alert release];
        
    }
    else{

        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        for (NSString *object in self.whatToMeasureArray) {
            NSMutableArray *tmpArray = [allStuffToMeasureDictionary objectForKey:object];
            for (NSMutableArray *mArray in tmpArray) {
                //we don't need chest to define number size for bra
                //we need it to define letter
                if (([object isEqualToString:@"Bras"]) && ([[mArray objectAtIndex:0] isEqualToString:@"Chest"])){
                    continue;
                }
                [tempDict setObject:[NSNumber numberWithFloat:[self getValueFromTextFieldWithKey:[mArray objectAtIndex:0]]] forKey:[mArray objectAtIndex:0]];
            }
            // finding pointer to sizes string in array
            NSInteger numberInSizesArray = [[MeasureManager sharedMeasureManager] findSizeForKeysAndValues:tempDict andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
            
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            //adding main size
            [resultsArray addObject:[NSNumber numberWithInteger: numberInSizesArray]];
            //adding additional size
            if ([object isEqualToString:@"Trousers & jeans"]){
                [resultsArray addObject:[NSNumber numberWithFloat:[self getValueFromTextFieldWithKey:@"Inside leg"]]];
            }
            //definig and savin bra letter
            if ([object isEqualToString:@"Bras"]){
                [resultsArray addObject:[[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:[self getValueFromTextFieldWithKey:@"Chest"] andUnderChest:[self getValueFromTextFieldWithKey:@"Under chest"]]];
            }
            //saving data in current profile
            [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey: object];
            
            //saving body params
            for (UIView *tmpView in self.sizesScrollView.subviews) {
                if ([tmpView isKindOfClass:[TextFieldWithKey class]]){
                    [[[DataManager sharedDataManager] currentProfile] setObject:[NSNumber numberWithFloat: [((TextFieldWithKey *)tmpView).text floatValue]] forKey: ((TextFieldWithKey *)tmpView).key];
                                       
                }
            }

            
            [resultsArray release];
            [tempDict removeAllObjects];
        }
        
        //saving profile
        [[DataManager sharedDataManager] saveDataWithKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                                  oldKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                           andDictionary:[[DataManager sharedDataManager] currentProfile]];
        //updating profile
        [[DataManager sharedDataManager] getProfileList];
        
        [tempDict release];
        
        
        ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
        resultController.bButtonType = rootButton;
        resultController.eButtonType = noButton;
        resultController.resultArray = self.whatToMeasureArray;
        [self.navigationController pushViewController:resultController animated:YES];
        [resultController release];
    }

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
        koef = [[MeasureManager sharedMeasureManager] getMeasureKoefForKey:currentView.key personType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
        //koef = 1;
    }
  
    //NSLog(@"dbe - %f", distanceBetweenEyes);
    measure = measure/((distanceBetweenEyes/2) * 0.374f) * 1.2f; // 1.2 - diameter zrachka
    
    
    if (makeMeasurementsUsingTwoPhotos){
        if (([firstPhotoMeasuresDictionary objectForKey:[self getStringKeyFromTag:50+page]]) && (self.sizeView.image == [photosDictionary objectForKey:@"secondPhoto"])){
            
            if (([currentView.key isEqualToString:@"Foot"]) || ([currentView.key isEqualToString:@"Inside leg"])){
                //don't calculate ellipse length 
            }
            else{
                float firstMeasure = [[firstPhotoMeasuresDictionary objectForKey:[self getStringKeyFromTag:50+page]] floatValue];
                //priamougolnik perimetr
                float perimetrPr = (firstMeasure*2) + (measure*2);
                
                measure = measure / 2;
                firstMeasure = firstMeasure/2;
                //ellipse
                float ellipsePer = 4*((M_PI * firstMeasure * measure+((firstMeasure - measure)*(firstMeasure - measure)))/(firstMeasure + measure));
                measure = (0.2f * perimetrPr) + (0.8f * ellipsePer);
                
                //before
                //measure = 4*((M_PI * firstMeasure * measure+((firstMeasure - measure)*(firstMeasure - measure)))/(firstMeasure + measure));
                
            }
        }
        else{
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
}

- (void) prepareSecondPhoto
{
    /*
    // version without rotated head on the second photo
    if (self.sizeView.image != [photosDictionary objectForKey:@"secondPhoto"]){
        self.sizeView.image = [photosDictionary objectForKey:@"secondPhoto"];
        [self.sizesScrollView scrollRectToVisible:self.sizesScrollView.frame animated:YES];
    }
    */
    
    if (self.sizeView.image != [photosDictionary objectForKey:@"secondPhoto"]){
        self.sizeView.image = [photosDictionary objectForKey:@"secondPhoto"];
        self.linImageView.image = nil;
        self.linImageView = nil;
        [self.sizesScrollView scrollRectToVisible:self.sizesScrollView.frame animated:YES];
        //changing images to side
        for (UIView *tmpView in self.sizesScrollView.subviews) {
            if ([tmpView isKindOfClass:[ImageViewWithKey class]]){
                ImageViewWithKey *imageView = (ImageViewWithKey *)tmpView;
                imageView.image = [UIImage imageNamed:[self getTipsImageNameForBodyPart:imageView.key mode:1]];
            }
        }

        
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           //eye detector block
                           CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
                           
                           
                           
                           NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage: self.sizeView.image.CGImage]];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{[self processPhoto: features];});
                       });
    }

     
}

- (NSString *) getStringKeyFromTag:(NSInteger) tag
{
    return [NSString stringWithFormat:@"%d", tag ];
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
    angle = angle/3;
    
    
    currentAngle = currentAngle + angle;
    self.linImageView.transform = CGAffineTransformRotate(self.linImageView.transform, angle);
    rotationRecognizer.rotation = 0.0f;
    
    
    /*
    UIView *tmp = [self.view viewWithTag:33];
    
    if (tmp) {
               
        tmp.frame = self.linImageView.frame;
        
    }
    else{
        tmp = [[UIView alloc] initWithFrame:self.linImageView.frame];
        tmp.backgroundColor = [UIColor whiteColor];
        tmp.tag = 33;
        tmp.alpha = 0.3f;
        [self.view insertSubview:tmp belowSubview:self.linImageView];
        [tmp release];
    }
*/
    
}

#pragma mark OverlayViewControllerDelegate


- (void)didTakePicture:(UIImage *)picture
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setImagePickerControllerIsActive:FALSE];
    
    CGSize newSize = CGSizeMake(self.sizeView.frame.size.width, self.sizeView.frame.size.height);
    
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
            CGFloat newHeight = picture.size.width*1.34f;
            
            //NSLog(@"%f", newHeight);
            
            CGRect cropRect = CGRectMake(0, (picture.size.height - newHeight)/2, picture.size.width, newHeight - ((picture.size.height - newHeight)/2));
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
    
    
    if (makeMeasurementsUsingTwoPhotos){
        
        if (![photosDictionary objectForKey:@"firstPhoto"]){
            //self.sizeView.image = shrunkenImage;
            [photosDictionary setObject:shrunkenImage forKey:@"firstPhoto"];
            [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:^{[self showImagePicker:self.source forPictureMode:1];}]; // side mode
        }
        else{
            [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
            [photosDictionary setObject:shrunkenImage forKey:@"secondPhoto"];
            
            self.sizeView.image = [photosDictionary objectForKey:@"firstPhoto"];
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^{
                               
                               //eye detector block
                               CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
                               
                               
                               
                               NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage: self.sizeView.image.CGImage]];
                               
                               dispatch_async(dispatch_get_main_queue(), ^{[self processPhoto: features];});
                           });

        }
    }
    else{
        
        [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
        self.sizeView.image = shrunkenImage;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           //eye detector block
                           CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
                           
                           
                           
                           NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage: self.sizeView.image.CGImage]];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{[self processPhoto: features];});
                       });

        
    }
    
  
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setImagePickerControllerIsActive:FALSE];

     [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:^{
        //;
    //}];
}

- (void)didCancelWithCamera
{
    self.pickingCanceled = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setImagePickerControllerIsActive:FALSE];

    
     [self.overlayViewController.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    //[self dismissViewControllerAnimated:YES completion:^{
        //;
    //}];
}






- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.pickingCanceled = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setImagePickerControllerIsActive:FALSE];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark action sheet delegate methods
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
    }
    else
    {
        
    }
}

#pragma mark alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (measureDidFail)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
       
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        
        BOOL updateSizeForOtherClothes = NO;
        
        //YES
        if (buttonIndex == 1){
            updateSizeForOtherClothes = YES;
        }
        
        if (updateSizeForOtherClothes){
           
            for (NSString *object in self.whatToMeasureArray) {
                NSMutableArray *tmpArray = [allStuffToMeasureDictionary objectForKey:object];
                for (NSMutableArray *mArray in tmpArray) {
                    if (([object isEqualToString:@"Bras"]) && ([[mArray objectAtIndex:0] isEqualToString:@"Chest"])){
                        continue;
                    }
                    [tempDict setObject:[NSNumber numberWithFloat:[self getValueFromTextFieldWithKey:[mArray objectAtIndex:0]]] forKey:[mArray objectAtIndex:0]];
                }
                // finding pointer to sizes string in array
                NSInteger numberInSizesArray = [[MeasureManager sharedMeasureManager] findSizeForKeysAndValues:tempDict andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
                
                NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: numberInSizesArray]];
                
                           
                //getting  dictionaty to change the size for the clothes with the same params
                NSArray *clothesWithTheSameSize = [[MeasureManager sharedMeasureManager] getClothesWithTheSameSizeForChoosenOne:object andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
                
                for (NSString *wear in clothesWithTheSameSize) {
                    // TODO: think about saving the additional info!!!
                    
                    //if wear in main array we don't need to update size
                    //if ([self.whatToMeasureArray indexOfObject:wear] == NSNotFound){
                    [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey:wear];
                    //}
                }
                [resultsArray release];
                
                resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: numberInSizesArray]];
                //adding additional size
                if ([object isEqualToString:@"Trousers & jeans"]){
                    [resultsArray addObject:[NSNumber numberWithFloat:[self getValueFromTextFieldWithKey:@"Inside leg"]]];
                }
                //definig and savin bra letter
                if ([object isEqualToString:@"Bras"]){
                    [resultsArray addObject:[[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:[self getValueFromTextFieldWithKey:@"Chest"] andUnderChest:[self getValueFromTextFieldWithKey:@"Under chest"]]];
                }
                //saving data in current profile
                [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey: object];
                
                //saving body params
                for (UIView *tmpView in self.sizesScrollView.subviews) {
                    if ([tmpView isKindOfClass:[TextFieldWithKey class]]){
                        [[[DataManager sharedDataManager] currentProfile] setObject:[NSNumber numberWithFloat: [((TextFieldWithKey *)tmpView).text floatValue]] forKey: ((TextFieldWithKey *)tmpView).key];
                        
                    }
                }

                [resultsArray release];
                [tempDict removeAllObjects];
            }

            
        }
        else{
            
            for (NSString *object in self.whatToMeasureArray) {
                NSMutableArray *tmpArray = [allStuffToMeasureDictionary objectForKey:object];
                for (NSMutableArray *mArray in tmpArray) {
                    if (([object isEqualToString:@"Bras"]) && ([[mArray objectAtIndex:0] isEqualToString:@"Chest"])){
                        continue;
                    }
                    [tempDict setObject:[NSNumber numberWithFloat:[self getValueFromTextFieldWithKey:[mArray objectAtIndex:0]]] forKey:[mArray objectAtIndex:0]];
                }
                // finding pointer to sizes string in array
                NSInteger numberInSizesArray = [[MeasureManager sharedMeasureManager] findSizeForKeysAndValues:tempDict andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
                
                NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: numberInSizesArray]];
                //adding additional size
                if ([object isEqualToString:@"Trousers & jeans"]){
                    [resultsArray addObject:[NSNumber numberWithFloat:[self getValueFromTextFieldWithKey:@"Inside leg"]]];
                }
                //definig and savin bra letter
                if ([object isEqualToString:@"Bras"]){
                    [resultsArray addObject:[[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:[self getValueFromTextFieldWithKey:@"Chest"] andUnderChest:[self getValueFromTextFieldWithKey:@"Under chest"]]];
                }
                //saving data in current profile
                [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey: object];
                
                //saving body params
                for (UIView *tmpView in self.sizesScrollView.subviews) {
                    if ([tmpView isKindOfClass:[TextFieldWithKey class]]){
                        [[[DataManager sharedDataManager] currentProfile] setObject:[NSNumber numberWithFloat: [((TextFieldWithKey *)tmpView).text floatValue]] forKey: ((TextFieldWithKey *)tmpView).key];
                        
                    }
                }            
                [resultsArray release];
                [tempDict removeAllObjects];
            }

            
        
        }
        
        
            
        //saving profile
        [[DataManager sharedDataManager] saveDataWithKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                                  oldKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                           andDictionary:[[DataManager sharedDataManager] currentProfile]];
        //updating profile
        [[DataManager sharedDataManager] getProfileList];
        
        [tempDict release];
        
        
        ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
        resultController.bButtonType = rootButton;
        resultController.eButtonType = noButton;
        resultController.resultArray = self.whatToMeasureArray;
        [self.navigationController pushViewController:resultController animated:YES];
        [resultController release];

    }
    
}



@end
