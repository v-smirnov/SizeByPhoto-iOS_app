//
//  HowToMeasureViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 01.08.12.
//
//

#import "HowToMeasureViewController.h"
#import "LocalyticsSession.h"

@interface HowToMeasureViewController ()

@end

@implementation HowToMeasureViewController

@synthesize clothesScrollView, figureView, backButtonNum, wardrobeView, infoButton, tableScrollView, rightArrowButton, leftArrowButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        whatWillBeMeasuredDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [clothesScrollView release];
    [figureView release];
    [tableClothesArray release];
    [imageViewsArray release];
    [clothesArray release];
    [whatWillBeMeasuredDict release];
    [wardrobeView release];
    [infoButton release];
    [tableScrollView release];
    [rightArrowButton release];
    [leftArrowButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.clothesScrollView = nil;
    self.figureView = nil;
    self.wardrobeView = nil;
    self.infoButton = nil;
    self.tableScrollView = nil;
    self.rightArrowButton = nil;
    self.leftArrowButton = nil;
    [tableClothesArray release]; tableClothesArray = nil;
    [imageViewsArray release]; imageViewsArray = nil;
    [clothesArray release]; clothesArray = nil;


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float currentY = 0;
    
      
    UITapGestureRecognizer *CSVTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CSVTwoTapDetected:)];
    CSVTapRecognizer.numberOfTapsRequired = 2;
    [self.clothesScrollView addGestureRecognizer:CSVTapRecognizer];
    [CSVTapRecognizer release];

    //99 - dont create a back button manually
    //0 - from NewProfileViewController
    if (self.backButtonNum == 0) {
        UIBarButtonItem *backToProfilesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profiles", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backToProfiles)] ;
        self.navigationItem.leftBarButtonItem = backToProfilesButton;
        [backToProfilesButton release];

    }
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Model", nil),                                                                                      NSLocalizedString(@"Table", nil), nil]];
    
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentedControl.frame = CGRectMake(0, 0, 120, 30);
    [segmentedControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];
    
    
    UIBarButtonItem *measureButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Measure", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(goToMeasureController)] ;
    self.navigationItem.rightBarButtonItem = measureButton;
    [measureButton release];

    
    NSInteger sex = [[MeasureManager sharedMeasureManager] getCurrentProfileGender];
    
    
    NSString *bodyImageName = [@"Body_" stringByAppendingString: [NSString stringWithFormat:@"%d",sex]];
    self.figureView.image = [UIImage imageNamed:bodyImageName];
    
    // table strings
    tableClothesArray  = [[[MeasureManager sharedMeasureManager] getClothesListForPersonType: sex] retain];
    
    // all image views array
    imageViewsArray = [[NSMutableArray alloc] init];
    
       
    //array with names of the wear
    clothesArray = [[NSMutableArray alloc] init];
    NSMutableArray *wardrobeClothesArray = [[NSMutableArray alloc] init];
    
    for (NSString *wearObject in tableClothesArray) {
        
        NSString *newWearObject = [[wearObject stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%d",sex]];
        
        NSString *newWardrobeWearObject = [[wearObject stringByAppendingString:@"_w_"] stringByAppendingString:[NSString stringWithFormat:@"%d",sex]];
        
        [clothesArray addObject:newWearObject];
        [wardrobeClothesArray addObject:newWardrobeWearObject];
        
        [self createCellViewWithFrame:CGRectMake(0,currentY,self.tableScrollView.frame.size.width,50) Title:wearObject andNumber:[tableClothesArray indexOfObject:wearObject]];
        currentY = currentY + 53;
        
    }
    //emulate table up-down moving effect  
    if (currentY < self.view.frame.size.height){
        currentY = self.view.frame.size.height+10;
    }
    self.tableScrollView.contentSize = CGSizeMake(self.tableScrollView.frame.size.width , currentY);
    
    self.clothesScrollView.contentSize = CGSizeMake(self.clothesScrollView.frame.size.width * [clothesArray count], self.clothesScrollView.frame.size.height);

    //filling scroll view with the wear
    
    float x = 0;
    for (NSString *imageName in clothesArray) {
        
        //NSLog(@"%@", imageName);
        
        NSString *wImageName = [wardrobeClothesArray objectAtIndex:[clothesArray indexOfObject:imageName]];
        
        [self addImage:[UIImage imageNamed:wImageName] withFrame:CGRectMake(x, 0, self.clothesScrollView.frame.size.width, self.clothesScrollView.frame.size.height) toScrollView:self.clothesScrollView];
        
        x = x + self.clothesScrollView.frame.size.width;
        
        //creating wear image views and adding them to array
        UIImageView *wearImageView = [[UIImageView alloc] init];
        wearImageView.userInteractionEnabled = YES;
        wearImageView.frame = [self getFrameOfWearImageViewsForPersonType:sex andKindOfClothes:imageName];
        //handle sorting
        if ([imageName hasPrefix:@"Underwear"]){
            wearImageView.tag = 10;
        }
        else if ([imageName hasPrefix:@"Bras"]){
            wearImageView.tag = 11;
        }
        else{
            wearImageView.tag = [clothesArray indexOfObject:imageName]+20;
        }
        //imageName = [imageName stringByAppendingString:@".png"];
        wearImageView.image = [UIImage imageNamed:imageName];
        //NSLog(@"%@", [UIImage imageNamed:imageName]);
        
        //adding gesture to image view
        UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWearImageView:)];
        [wearImageView addGestureRecognizer:swipeRecognizer];
        [swipeRecognizer release];
        
        [imageViewsArray addObject:wearImageView];
        [wearImageView release];
    }
    self.clothesScrollView.delegate = self;
    
    [wardrobeClothesArray release];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - actions

- (IBAction) showTips:sender
{
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    controller.numberOfPageToShow = 2;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}


- (void) swipeWearImageView:sender
{
    //uncheking wear at the table
    NSInteger row = [imageViewsArray indexOfObject:((UISwipeGestureRecognizer *)sender).view];
    [self _setChekmarkInRow:row withImage:nil];
    [whatWillBeMeasuredDict removeObjectForKey:[tableClothesArray objectAtIndex:row]];
    
    //remember ald center
    CGPoint oldCenter = ((UISwipeGestureRecognizer *)sender).view.center;
    
    [UIView animateWithDuration:1.5f animations:^{
        CGPoint newCenter =CGPointMake(self.clothesScrollView.center.x, self.clothesScrollView.center.y + 100 - self.clothesScrollView.frame.size.height/2);
        ((UISwipeGestureRecognizer *)sender).view.center = newCenter;
        ((UISwipeGestureRecognizer *)sender).view.alpha = 0.0f;
    }
                     completion:^(BOOL finished) {
                         ((UISwipeGestureRecognizer *)sender).view.alpha = 1.0f;
                         ((UISwipeGestureRecognizer *)sender).view.center = oldCenter;
                         [((UISwipeGestureRecognizer *)sender).view removeFromSuperview];
                        
                     }];

    
    
}

- (void)segmentControlAction:(id) sender
{
    
    if (((UISegmentedControl *)sender).selectedSegmentIndex == 0){
        for (UIImageView * imageView in imageViewsArray) {
            imageView.hidden = NO;
        }
        self.clothesScrollView.hidden = NO;
        self.figureView.hidden = NO;
        self.wardrobeView.hidden = NO;
        self.tableScrollView.hidden = YES;
        self.infoButton.hidden = NO;
        self.rightArrowButton.hidden = NO;
        self.leftArrowButton.hidden = NO;
    }
    else if (((UISegmentedControl *)sender).selectedSegmentIndex == 1){
        for (UIImageView * imageView in imageViewsArray) {
            imageView.hidden = YES;
        }
        self.clothesScrollView.hidden = YES;
        self.figureView.hidden = YES;
        self.wardrobeView.hidden = YES;
        self.tableScrollView.hidden = NO;
        self.infoButton.hidden = YES;
        self.rightArrowButton.hidden = YES;
        self.leftArrowButton.hidden = YES;
    }
}

- (void) backToProfiles
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) goToMeasureController
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        /*
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Measure with", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles: NSLocalizedString(@"One new photo", nil),
                                                        NSLocalizedString(@"Two new photos", nil),
                                                        NSLocalizedString(@"One existing photo", nil),
                                                        NSLocalizedString(@"Two existing photos", nil),
                                                        NSLocalizedString(@"Parameters", nil), nil];
        */
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Measure with", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles: NSLocalizedString(@"Two new photos", nil),
                                     NSLocalizedString(@"Two existing photos", nil),
                                     NSLocalizedString(@"Parameters", nil), nil];
        [startSheet showInView:self.view];
        [startSheet release];
    }
    else
    {
        /*
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"You can measure", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles: NSLocalizedString(@"With existing photo", nil),
                                                        NSLocalizedString(@"With 2 existing photos", nil),
                                                        NSLocalizedString(@"With parameters", nil), nil];
        */
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Measure with", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles: NSLocalizedString(@"Two existing photos", nil),
                                     NSLocalizedString(@"Parameters", nil), nil];
        [startSheet showInView:self.view];
        [startSheet release];
        
    }
    
}

-(IBAction) rightArrowBtnClick:(id)sender
{
    CGFloat pageWidth = self.clothesScrollView.frame.size.width;
    NSInteger page = floor((self.clothesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    CGRect newVisibleArea = CGRectMake(self.clothesScrollView.frame.size.width * (page+1), 0, self.clothesScrollView.frame.size.width, self.clothesScrollView.frame.size.height);
    
    [self.clothesScrollView scrollRectToVisible:newVisibleArea animated:YES];
    
}

-(IBAction) leftArrowBtnClick:(id)sender
{
    CGFloat pageWidth = self.clothesScrollView.frame.size.width;
    NSInteger page = floor((self.clothesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    CGRect newVisibleArea = CGRectMake(self.clothesScrollView.frame.size.width * (page-1), 0, self.clothesScrollView.frame.size.width, self.clothesScrollView.frame.size.height);
    
    [self.clothesScrollView scrollRectToVisible:newVisibleArea animated:YES];
}

 
#pragma mark - help functions

- (void) addImage:(UIImage*) image withFrame:(CGRect) viewFrame toScrollView:(UIScrollView *) scrollView 
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: viewFrame];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    [imageView release];
}

- (void) _setChekmarkInRow:(NSInteger) row withImage:(UIImage *) image
{
    UIButton *rowView = (UIButton *)[self.tableScrollView viewWithTag:row];
    if (rowView){
        UIImageView *checkSignImageView = (UIImageView *)[rowView viewWithTag:999];
        if (checkSignImageView){
            checkSignImageView.image = image;
        }
    }
    
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

- (CGRect) getFrameOfWearImageViewsForPersonType:(PersonType)personType andKindOfClothes:(NSString *) kindOfClothes
{
    CGRect frame = CGRectMake(0, 0, 0, 0);
    
    NSInteger yOffset = 0;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        yOffset = 88;
    }
    
    
    if (personType == Man){
        
        if ([kindOfClothes isEqualToString:@"Underwear_0"]){
            frame = CGRectMake(50, 206+yOffset, 57, 40);
        }
        //jeans
        else if ([kindOfClothes isEqualToString:@"Jeans_0"]){
            frame = CGRectMake(47, 206+yOffset, 63, 170);
        }
        //t-shirt
        else if ([kindOfClothes isEqualToString:@"T-shirt_0"]){
            frame = CGRectMake(30, 112+yOffset, 97, 103);
        }
        else if ([kindOfClothes isEqualToString:@"Shirt_0"]){
            frame = CGRectMake(26, 104+yOffset, 105, 128);
        }
        else if ([kindOfClothes isEqualToString:@"Coats & jackets_0"]){
            frame = CGRectMake(24, 106+yOffset, 109, 130);
        }
        else if ([kindOfClothes isEqualToString:@"Shoes_0"]){
            frame = CGRectMake(46, 367+yOffset, 60, 29);
        }

        else{
            frame = CGRectMake(0, 0, 0, 0);
        }
        
    }
    else if (personType == Woman){
        if ([kindOfClothes isEqualToString:@"Bras_1"]){
            frame = CGRectMake(51, 117+yOffset, 54, 45);
        }
        else if ([kindOfClothes isEqualToString:@"Underwear_1"]){
            frame = CGRectMake(47, 204+yOffset, 62, 33);
        }
        else if ([kindOfClothes isEqualToString:@"Jeans_1"]){
            frame = CGRectMake(45, 203+yOffset, 65, 169);
        }
        else if ([kindOfClothes isEqualToString:@"Skirt_1"]){
            frame = CGRectMake(45, 184+yOffset, 65, 122);
        }
        else if ([kindOfClothes isEqualToString:@"T-shirt_1"]){
            frame = CGRectMake(36, 116+yOffset, 83, 94);
        }
        else if ([kindOfClothes isEqualToString:@"Shirt_1"]){
            frame = CGRectMake(32, 107+yOffset, 92, 135);
        }
        else if ([kindOfClothes isEqualToString:@"Dress_1"]){
            frame = CGRectMake(45, 114+yOffset, 65, 203);
        }
        else if ([kindOfClothes isEqualToString:@"Coats & jackets_1"]){
            frame = CGRectMake(22, 103+yOffset, 111, 190);
        }
        else if ([kindOfClothes isEqualToString:@"Shoes_1"]){
            frame = CGRectMake(58, 384+yOffset, 37, 18);
        }
    }
    else{
        
    }
    
    return frame;
}

- (NSInteger) getIndexToInsertWearViewWithTag:(NSInteger) viewTag
{
    NSInteger retIndex = [[self.view subviews] count];
    for (UIView *tmpView in self.view.subviews) {
        if (tmpView.tag > viewTag){
            retIndex = [[self.view subviews] indexOfObject:tmpView];
            break;
        }
    }

    //NSLog(@"%d", retIndex);
    return retIndex;
}


- (void) createCellViewWithFrame:(CGRect) frame  Title:(NSString *) title andNumber:(NSInteger) number
{
    //row view
    //use button to visualize click
    UIButton *currentView = [UIButton buttonWithType:UIButtonTypeCustom];
    [currentView setTag:number];
    [currentView setFrame:frame];
    [currentView setBackgroundImage:[UIImage imageNamed:@"cell_background"] forState:UIControlStateNormal];
    [currentView addTarget:self action:@selector(cellTapDetected:) forControlEvents:UIControlEventTouchUpInside];
    
    //title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, currentView.frame.size.height/2-10, currentView.frame.size.width/2, 20)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment =UITextAlignmentLeft;
    label.text = NSLocalizedString(title, nil);
    [currentView addSubview:label];
    [label release];

    //check image view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentView.frame.size.width-30, currentView.frame.size.height-currentView.frame.size.height/2-10, 20, 20)];
    imageView.image = nil;
    imageView.tag = 999;
    [currentView addSubview:imageView];
    [imageView release];
    
    [self.tableScrollView addSubview:currentView];
    
}

- (void) checkArrowBtnsAccessibility
{
    CGFloat pageWidth = self.clothesScrollView.frame.size.width;
    NSInteger page = floor((self.clothesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page == 0){
        self.leftArrowButton.enabled = FALSE;
    }
    // table clothes array count = all stuff at wardrobe
    else if (page == [tableClothesArray count]-1){
        self.rightArrowButton.enabled = FALSE;
    }
    else{
        self.leftArrowButton.enabled = TRUE;
        self.rightArrowButton.enabled = TRUE;
    }
}



#pragma mark - Gesture Recognizers

- (void)CSVTwoTapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    CGFloat pageWidth = self.clothesScrollView.frame.size.width;
    NSInteger page = floor((self.clothesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    BOOL viewAlreadyAdded = NO;
   
    
    for (UIView *tmpView in self.view.subviews) {
        if (tmpView == [imageViewsArray objectAtIndex:page]){
            viewAlreadyAdded = YES;
        }
    }
    if (viewAlreadyAdded){
        [[imageViewsArray objectAtIndex:page] removeFromSuperview];
        [self.view insertSubview: [imageViewsArray objectAtIndex:page] atIndex:[self getIndexToInsertWearViewWithTag:[[imageViewsArray objectAtIndex:page] tag]]];
        //[self.view addSubview:[imageViewsArray objectAtIndex:page]];
    }
    else{
        //[self.view addSubview:[imageViewsArray objectAtIndex:page]];
        [self.view insertSubview: [imageViewsArray objectAtIndex:page] atIndex:[self getIndexToInsertWearViewWithTag:[[imageViewsArray objectAtIndex:page] tag]]];
    }
    
    [self _setChekmarkInRow:page withImage:[UIImage imageNamed:@"checkImage"]];
    [whatWillBeMeasuredDict setObject:[tableClothesArray objectAtIndex:page] forKey:[tableClothesArray objectAtIndex:page]];
    // NSLog(@"%d", [self.view.subviews count]);
   
}

- (void)cellTapDetected:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    // tag 999 - is constant value for check image view
    UIImageView *checkSignImageView = (UIImageView *)[senderButton viewWithTag:999];
    if (checkSignImageView){
        if (checkSignImageView.image){
            checkSignImageView.image = nil;
            [[imageViewsArray objectAtIndex:senderButton.tag]removeFromSuperview];
            
            [whatWillBeMeasuredDict removeObjectForKey:[tableClothesArray objectAtIndex:senderButton.tag]];
        }
        else{
            checkSignImageView.image = [UIImage imageNamed:@"checkImage"];
            [self.view insertSubview: [imageViewsArray objectAtIndex:senderButton.tag] atIndex:[self getIndexToInsertWearViewWithTag:[[imageViewsArray objectAtIndex:senderButton.tag] tag]]];
            [whatWillBeMeasuredDict setObject:[tableClothesArray objectAtIndex:senderButton.tag] forKey:[tableClothesArray objectAtIndex:senderButton.tag]];
        }
    }
    
    
}

#pragma mark scrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self checkArrowBtnsAccessibility];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"%f", self.clothesScrollView.contentOffset.x);
}

#pragma mark action sheet delegate methods
- (void) willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *btnView in actionSheet.subviews)
    {
        if ([btnView isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*) btnView;
            
            [btn setBackgroundImage:[UIImage imageNamed:@"asBtnBackground.png"]  forState:UIControlStateHighlighted];
        }
    }
    
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
    }
    else
    {
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        
        for (NSString *object in tableClothesArray) {
            if ([whatWillBeMeasuredDict objectForKey:object]){
                 [tmpArray addObject:object];
            }
                
        }
        
        if ([tmpArray count] == 0){
            [tmpArray release];
            [self showAlertDialogWithTitle:@"Warning" andMessage:@"Select at least one type of clothers"];
            return;
        }
        
        
        NSString *measureViewNib = nil;
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            measureViewNib = @"MeasureView568";
        }
        else{
            measureViewNib = @"MeasureView";
        }

       
        
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            /*
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = NO;
                measureController.source = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }
            if (buttonIndex == 1){
                
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = YES;
                measureController.source = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }

            else if (buttonIndex == 2){
                
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = NO;
                measureController.source = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }
            else if (buttonIndex == 3){
                
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = YES;
                measureController.source = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }

            else if (buttonIndex == 4){
                
                MeasureByParamsViewController *measureController = [[MeasureByParamsViewController alloc] initWithNibName:@"MeasureByParamsView" bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];

            }
             */
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                
                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Measure with new photos"];
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = YES;
                measureController.source = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];            }
            if (buttonIndex == 1){
                
                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Measure with 2 existing photos"];
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = YES;
                measureController.source = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
               
            }
            
            else if (buttonIndex == 2){
                
                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Measure with parameters"];
                MeasureByParamsViewController *measureController = [[MeasureByParamsViewController alloc] initWithNibName:@"MeasureByParamsView" bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }

            [tmpArray release];
        }
        else
        {/*
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = NO;
                measureController.source = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }
            if (buttonIndex == 1){
                
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = YES;
                measureController.source = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }

            else if (buttonIndex == 2){
                //measure by params
                MeasureByParamsViewController *measureController = [[MeasureByParamsViewController alloc] initWithNibName:@"MeasureByParamsView" bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }
          */
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                
                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Measure with 2 existing photos"];
                MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                measureController.makeMeasurementsUsingTwoPhotos = YES;
                measureController.source = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];
            }
            if (buttonIndex == 1){
                [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Measure with parameters"];
                //measure by params
                MeasureByParamsViewController *measureController = [[MeasureByParamsViewController alloc] initWithNibName:@"MeasureByParamsView" bundle:nil];
                measureController.whatToMeasureArray = tmpArray;
                [self.navigationController pushViewController:measureController animated:YES];
                [measureController release];

            }
            [tmpArray release];
        }
    

    }
}
@end