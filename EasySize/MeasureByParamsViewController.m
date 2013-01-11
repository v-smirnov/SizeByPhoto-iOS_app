//
//  MeasureByParamsViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 26.08.12.
//
//

#import "MeasureByParamsViewController.h"

@interface MeasureByParamsViewController ()

@end

@implementation MeasureByParamsViewController

@synthesize whatToMeasureArray, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [viewsStateArray release];
    [whatToMeasureArray release];
    [scrollView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [viewsStateArray release];
    self.whatToMeasureArray = nil;
    self.scrollView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    inchesSelected = NO;
    
    UIImage *currentBG = nil;
    float currentY = 0;
    
    // 0 - closed
    // 1 - opened
    viewsStateArray = [[NSMutableArray alloc] init];
    
    
    NSMutableDictionary *allStuffToMeasureDictionary = [[[MeasureManager sharedMeasureManager] getClothesMeasureParamsForPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]] retain];


    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"cm", nil),                                                                                      NSLocalizedString(@"inch", nil), nil]];
    
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentedControl.frame = CGRectMake(0, 0, 100, 30);
    [segmentedControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];

    
    UIBarButtonItem *resultButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Result", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(viewResults)] ;
    self.navigationItem.rightBarButtonItem = resultButton;
    [resultButton release];

    
    // prepearing views
    if (self.whatToMeasureArray){
        for (NSInteger i = 0; i < [self.whatToMeasureArray count]; i++) {
            currentBG = [UIImage imageNamed:@"cell_background.png"];
            
            CGRect currentFrame = CGRectMake(0, currentY, self.scrollView.frame.size.width, 147);
            [self createSizeViewWithFrame:currentFrame Background:currentBG Tag:i+1 Title:[self.whatToMeasureArray objectAtIndex:i] SlidersArray:[allStuffToMeasureDictionary objectForKey:[self.whatToMeasureArray objectAtIndex:i]]];
            currentY = currentY + 147;
            [viewsStateArray addObject:@"0"];
        }
    }
    //setting sizes in scroll views if body params already measured
    [self setSizesInScrollViews];
    
    //because tag starts from 1
    [viewsStateArray addObject:@"0"];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, currentY);
    
    [allStuffToMeasureDictionary release];
    
    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark help functions

- (void) updateSizesWhereSliderHasTheSameName:(LabeledSlider *) currentSlider
{
    MeasureView *mView = (MeasureView *)currentSlider.viewThatOwnsScrollView;
    UIScrollView *sView = mView.sizesScrollView;
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:[mView.slidersArray count]];
    
    for (LabeledSlider *slider in mView.slidersArray) {
        
        if (([mView.viewKey isEqualToString:@"Bras"]) && ([slider.sliderKey isEqualToString:@"Chest"])){
            float underChestValue = 0.0f;
            for (LabeledSlider *sl in mView.slidersArray) {
                if ([sl.sliderKey isEqualToString:@"Under chest"]){
                    underChestValue = sl.value;
                    break;
                }
            }
            
            mView.additionalInfoLabel.text = [[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:slider.value andUnderChest:underChestValue];
            
            continue;
        }
        [tempDict setObject:[NSNumber numberWithFloat:slider.value] forKey:slider.sliderKey];
    }
    
    //CGFloat pageHeight = sView.frame.size.height;
    //NSInteger page = roundf((currentSlider.value - currentSlider.minimumValue)/currentSlider.step);
    NSInteger page = [[MeasureManager sharedMeasureManager] findSizeForKeysAndValues:tempDict andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
    CGRect currentFrame = sView.frame;
    currentFrame.origin.y = currentFrame.size.height * (page);
    [sView scrollRectToVisible:currentFrame animated:YES];
    
    [tempDict release];
}

- (void) setSizesInScrollViews
{
    for (id currentView in [self.scrollView subviews]) {
        if ([currentView isKindOfClass:[MeasureView class]]){
            
            MeasureView *mView =  (MeasureView *)currentView;;
            UIScrollView *sView = mView.sizesScrollView;

            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:[mView.slidersArray count]];

            for (LabeledSlider *slider in mView.slidersArray) {
                if (([mView.viewKey isEqualToString:@"Bras"]) && ([slider.sliderKey isEqualToString:@"Chest"])){
                    
                    float underChestValue = 0.0f;
                    for (LabeledSlider *sl in mView.slidersArray) {
                        if ([sl.sliderKey isEqualToString:@"Under chest"]){
                            underChestValue = sl.value;
                            break;
                        }
                    }
                    
                    mView.additionalInfoLabel.text = [[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:slider.value andUnderChest:underChestValue];

                    continue;
                }
                [tempDict setObject:[NSNumber numberWithFloat:slider.value] forKey:slider.sliderKey];
            }

            //CGFloat pageHeight = sView.frame.size.height;
            //NSInteger page = roundf((currentSlider.value - currentSlider.minimumValue)/currentSlider.step);
            NSInteger page = [[MeasureManager sharedMeasureManager] findSizeForKeysAndValues:tempDict andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
            CGRect currentFrame = sView.frame;
            currentFrame.origin.y = currentFrame.size.height * (page);
            [sView scrollRectToVisible:currentFrame animated:NO];

            [tempDict release];
        }
    }
}



- (void) updateSlidersLabelsValueForMeasureSystem:(BOOL) system
{
    for (id currentView in [self.scrollView subviews]) {
        if ([currentView isKindOfClass:[MeasureView class]]){
            
            MeasureView * tmpView = (MeasureView *)currentView;
            
            for (LabeledSlider *lSlider in tmpView.slidersArray) {
                if (system){
                    float slValue = lSlider.value/2.54f;
                    lSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", slValue];
                }
                else{
                    lSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", lSlider.value];
                }
                
            }
            
        }
    }

    
}

- (void) createSizeViewWithFrame:(CGRect) frame Background:(UIImage *) bg Tag:(NSInteger) tag Title:(NSString *) title SlidersArray:(NSArray *) slidersArray
{
    
    MeasureView *currentView = [[MeasureView alloc] initWithFrame:frame];
    currentView.viewKey = title;
    NSMutableArray * tmpSlidersArray = [[NSMutableArray alloc] init];
    currentView.slidersArray = tmpSlidersArray;
    [tmpSlidersArray release];
    
    currentView.userInteractionEnabled = YES;
    currentView.image = bg;
    currentView.tag = tag;
    //title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, currentView.frame.size.width/2, 20)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment =UITextAlignmentLeft;
    label.text = NSLocalizedString(title, nil);
    [currentView addSubview:label];
    [label release];
    //action button
    //UIButton *button =[[UIButton alloc] initWithFrame:CGRectMake(currentView.frame.size.width-100, 10, 90, 20)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(currentView.frame.size.width-90, currentView.frame.size.height-37, 80, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"grayBtnBackground.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [button setTitle:NSLocalizedString(@"Expand", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [currentView addSubview:button];
    
    //additional info label
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentView.frame.size.height-37, currentView.frame.size.width/2, 25)];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:16.0f];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment =UITextAlignmentLeft;
    infoLabel.text = @"";
    [currentView addSubview:infoLabel];
    currentView.additionalInfoLabel = infoLabel;
    [infoLabel release];

    
    //flags view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 40, 35)];
    imageView.image = [UIImage imageNamed:@"EU_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 40, 40, 35)];
    imageView.image = [UIImage imageNamed:@"RUS_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 40, 40, 35)];
    imageView.image = [UIImage imageNamed:@"US_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(205, 40, 40, 35)];
    imageView.image = [UIImage imageNamed:@"UK_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 40, 40, 35)];
    imageView.image = [UIImage imageNamed:@"World_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    //creating sizes scrollView
    
    NSArray *sizesArray = [[MeasureManager sharedMeasureManager] getSizesTableForClothesType:currentView.viewKey andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
    
    
    UIScrollView *sizesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 75, frame.size.width-10, 35)];
    sizesScrollView.delegate = self;
    sizesScrollView.pagingEnabled = YES;
    sizesScrollView.userInteractionEnabled = YES;
    sizesScrollView.showsHorizontalScrollIndicator = NO;
    sizesScrollView.showsVerticalScrollIndicator = NO;
    sizesScrollView.backgroundColor = [UIColor clearColor];
    sizesScrollView.contentSize = CGSizeMake(sizesScrollView.frame.size.width, sizesScrollView.frame.size.height * [sizesArray count]);
    
    NSInteger heightKoef = 0;
    for (NSArray *tmpArray in sizesArray) {
        float xPoint = 0.0f;
        for (NSString *sizeString in tmpArray) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, sizesScrollView.frame.size.height * heightKoef, 40, 30)];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15.0f];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.textAlignment =UITextAlignmentCenter;
            label.text = sizeString;
            [sizesScrollView addSubview:label];
            [label release];
            xPoint = xPoint+40+25;
        }
        heightKoef++;
    }
    currentView.sizesScrollView = sizesScrollView;
    [currentView addSubview:sizesScrollView];
    [sizesScrollView release];
    /*
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, currentView.frame.size.width/2, 10)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment =UITextAlignmentLeft;
    label.text = NSLocalizedString(@"111", nil);
    [currentView addSubview:label];
    [label release];

     */
    //creating sliders
    
    //slidersArray - just array of names of future sliders
    // number of is equal to the array count(number of params to measure)
    for (NSArray *object in slidersArray) {
        
        
        LabeledSlider *currentSlider = [[LabeledSlider alloc] init];
        currentSlider.minimumValue = [[MeasureManager sharedMeasureManager] getMinSizeForClothesType:[object objectAtIndex:0] andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
        currentSlider.maximumValue = [[MeasureManager sharedMeasureManager] getMaxSizeForClothesType:[object objectAtIndex:0] andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
        //currentSlider.step = [[MeasureManager sharedMeasureManager] getStepSliderValueForKey:[object objectAtIndex:0] andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
        currentSlider.sliderKey = [object objectAtIndex:0];
        currentSlider.continuous = YES;
        currentSlider.value = currentSlider.minimumValue;
        //setup body params if exist
        if ([[[DataManager sharedDataManager] currentProfile] objectForKey:currentSlider.sliderKey])
        {
            currentSlider.value = [[[[DataManager sharedDataManager] currentProfile] objectForKey:currentSlider.sliderKey] floatValue];
        }
        
        UILabel *sliderNameLabel = [[UILabel alloc] init];
        sliderNameLabel.textColor = [UIColor blackColor];
        sliderNameLabel.font = [UIFont systemFontOfSize:12.0f];
        sliderNameLabel.backgroundColor = [UIColor clearColor];
        sliderNameLabel.numberOfLines = 0;
        sliderNameLabel.lineBreakMode = UILineBreakModeWordWrap;
        sliderNameLabel.textAlignment =UITextAlignmentLeft;
        sliderNameLabel.text = NSLocalizedString([object objectAtIndex:0], nil);
        currentSlider.nameLabel = sliderNameLabel;
        [sliderNameLabel release];
        
        UILabel *sliderValueLabel = [[UILabel alloc] init];
        sliderValueLabel.textColor = [UIColor blackColor];
        sliderValueLabel.font = [UIFont systemFontOfSize:12.0f];
        sliderValueLabel.backgroundColor = [UIColor clearColor];
        sliderValueLabel.numberOfLines = 0;
        sliderValueLabel.lineBreakMode = UILineBreakModeWordWrap;
        sliderValueLabel.textAlignment =UITextAlignmentRight;
        sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", currentSlider.minimumValue];
        if ([[[DataManager sharedDataManager] currentProfile] objectForKey:currentSlider.sliderKey])
        {
            sliderValueLabel.text = [NSString stringWithFormat:@"%.2f", [[[[DataManager sharedDataManager] currentProfile] objectForKey:currentSlider.sliderKey] floatValue]];
        }

        currentSlider.valueLabel = sliderValueLabel;
        [sliderValueLabel release];
        
        currentSlider.viewThatOwnsScrollView = currentView;
        
        [currentSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [currentSlider addTarget:self action:@selector(sliderStopped:) forControlEvents:UIControlEventTouchUpInside];
        
        [currentView.slidersArray addObject:currentSlider];
        [currentSlider release];
    }
    
    
    [self.scrollView addSubview:currentView];
    [currentView release];
}




#pragma mark actions

- (IBAction) showTips:sender
{
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    controller.numberOfPageToShow = 4;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
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
    
        for (id currentView in [self.scrollView subviews]) {
            if ([currentView isKindOfClass:[MeasureView class]]){
                
                MeasureView * tmpView = (MeasureView *)currentView;
                NSInteger positionInSizesArray = roundf(tmpView.sizesScrollView.contentOffset.y/tmpView.sizesScrollView.frame.size.height);
                
                NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: positionInSizesArray]];
                //adding additional info
                if ([tmpView.viewKey isEqualToString:@"Jeans"]){
                    for (LabeledSlider *currentSlider in tmpView.slidersArray) {
                        if ([currentSlider.sliderKey isEqualToString:@"Inside leg"]){
                            [resultsArray addObject:[NSNumber numberWithFloat:currentSlider.value]];
                            break;
                        }
                    }
                    
                }
                if ([tmpView.viewKey isEqualToString:@"Bras"]){
                    [resultsArray addObject:tmpView.additionalInfoLabel.text];
                }
               
                [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey:tmpView.viewKey];
                
                //saving body params
                for (LabeledSlider *currentSlider in tmpView.slidersArray) {
                    
                    [[[DataManager sharedDataManager] currentProfile] setObject:[NSNumber numberWithFloat:currentSlider.value] forKey:currentSlider.sliderKey];
                }
                
                [resultsArray release];
                
            }
        }
        //saving profile 
        [[DataManager sharedDataManager] saveDataWithKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                                  oldKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                           andDictionary:[[DataManager sharedDataManager] currentProfile]];
        
        //updating profile list
        [[DataManager sharedDataManager] getProfileList];
        
        ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
        resultController.bButtonType = rootButton;
        resultController.eButtonType = noButton;
        resultController.resultArray = self.whatToMeasureArray;
        [self.navigationController pushViewController:resultController animated:YES];
        [resultController release];

    }
}

- (void)segmentControlAction:(id) sender
{
    if (((UISegmentedControl *)sender).selectedSegmentIndex == 0){
        inchesSelected = NO;
        [self updateSlidersLabelsValueForMeasureSystem:inchesSelected];
    }
    else if (((UISegmentedControl *)sender).selectedSegmentIndex == 1){
        inchesSelected = YES;
        [self updateSlidersLabelsValueForMeasureSystem:inchesSelected];
    }

}

- (void) sliderStopped:(id)sender
{
    
    LabeledSlider *currentSlider = (LabeledSlider *)sender;
    MeasureView *mView = (MeasureView *)currentSlider.viewThatOwnsScrollView;
    UIScrollView *sView = mView.sizesScrollView;
    
    if ([currentSlider.sliderKey isEqualToString:@"Inside leg"]){
        mView.additionalInfoLabel.text = [[MeasureManager sharedMeasureManager] getLegLengthDescriptionForValue:currentSlider.value andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
        //there is possibility 
    }
    else if (([mView.viewKey isEqualToString:@"Bras"]) && ([currentSlider.sliderKey isEqualToString:@"Chest"])){
        float underChestValue = 0.0f;
        for (LabeledSlider *sl in mView.slidersArray) {
            if ([sl.sliderKey isEqualToString:@"Under chest"]){
                underChestValue = sl.value;
                break;
            }
        }
        
        mView.additionalInfoLabel.text = [[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:currentSlider.value andUnderChest:underChestValue];
        
        for (id currentObject in [self.scrollView subviews]) {
            if ([currentObject isKindOfClass:[MeasureView class]]){
                
                NSArray *tmpSlidersArray = ((MeasureView *)currentObject).slidersArray;
                for (LabeledSlider *lSlider in tmpSlidersArray) {
                    if (lSlider != currentSlider){
                        if ([lSlider.nameLabel.text isEqualToString:currentSlider.nameLabel.text]){
                            lSlider.value = currentSlider.value;
                            lSlider.valueLabel.text = currentSlider.valueLabel.text;
                            [self updateSizesWhereSliderHasTheSameName:lSlider];
                        }
                    }
                    
                }
            }
        }

    }
    else{
    
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:[mView.slidersArray count]];
        
        for (LabeledSlider *slider in mView.slidersArray) {
            //missing if moving chest slider for bra
            if (([mView.viewKey isEqualToString:@"Bras"]) && ([slider.sliderKey isEqualToString:@"Chest"])){
                continue;
            }
            //defining letter for bra
            if (([mView.viewKey isEqualToString:@"Bras"]) && ([slider.sliderKey isEqualToString:@"Under chest"])){
                float chestValue = 0.0f;
                
                for (LabeledSlider *sl in mView.slidersArray) {
                    if ([sl.sliderKey isEqualToString:@"Chest"]){
                        chestValue = sl.value;
                        break;
                    }
                }
                
                mView.additionalInfoLabel.text = [[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:chestValue andUnderChest:slider.value];
            }

            
            [tempDict setObject:[NSNumber numberWithFloat:slider.value] forKey:slider.sliderKey];
        }
        
        
        NSInteger page = [[MeasureManager sharedMeasureManager] findSizeForKeysAndValues:tempDict andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
        CGRect currentFrame = sView.frame;
        currentFrame.origin.y = currentFrame.size.height * (page);
        [sView scrollRectToVisible:currentFrame animated:YES];

        [tempDict release];

        for (id currentObject in [self.scrollView subviews]) {
            if ([currentObject isKindOfClass:[MeasureView class]]){
                              
                NSArray *tmpSlidersArray = ((MeasureView *)currentObject).slidersArray;
                for (LabeledSlider *lSlider in tmpSlidersArray) {
                    if (lSlider != currentSlider){
                        if ([lSlider.nameLabel.text isEqualToString:currentSlider.nameLabel.text]){
                            lSlider.value = currentSlider.value;
                            lSlider.valueLabel.text = currentSlider.valueLabel.text;
                            [self updateSizesWhereSliderHasTheSameName:lSlider];
                        }
                    }
                  
                }
            }
        }
    }
    
}


- (void) sliderValueChange:(id)sender
{
    LabeledSlider *currentSlider = (LabeledSlider *)sender;
    
    //float newValue = (currentSlider.value - currentSlider.minimumValue)/currentSlider.step;
    //newValue = currentSlider.minimumValue+((int)newValue*currentSlider.step);
    //[currentSlider setValue:newValue animated:NO];
    if (inchesSelected){
        float slValue = ((LabeledSlider *)sender).value/2.54f;
        currentSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", slValue];
    }
    else{
        currentSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", ((LabeledSlider *)sender).value];
    }
}
- (void)anyButtonPressed:(id)sender
{
    NSInteger currentTag;
    float viewHeight;
    float viewXCenter;
    currentTag =  ((UIButton *)sender).superview.tag;
    //viewHeight = ((UIButton *)sender).superview.frame.size.height;
    viewXCenter = ((UIButton *)sender).superview.center.x;
    
    NSArray *currenSlidersArray = ((MeasureView *)((UIButton *)sender).superview).slidersArray;
    MeasureView *currentMeasureView = ((MeasureView *)((UIButton *)sender).superview);
    
    //20 - slider height
    //20 - label height
    viewHeight = [currenSlidersArray count]*30*2;
    
    if ([viewsStateArray objectAtIndex:currentTag] == @"0")
    {
        [viewsStateArray replaceObjectAtIndex:currentTag withObject:@"1"];
        
        [(UIButton *)sender setTitle:NSLocalizedString(@"Hide",nil) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
           
            for (id currentObject in [self.scrollView subviews]) {
                if ([currentObject isKindOfClass:[MeasureView class]]){
                    if (((MeasureView *)currentObject).tag > currentTag){
                        ((MeasureView *)currentObject).center = CGPointMake(viewXCenter, ((MeasureView *)currentObject).center.y+viewHeight);
                        
                        NSArray *tmpSlidersArray = ((MeasureView *)currentObject).slidersArray;
                        for (LabeledSlider *lSlider in tmpSlidersArray) {
                            lSlider.center = CGPointMake(lSlider.center.x, lSlider.center.y+viewHeight);
                            lSlider.valueLabel.center = CGPointMake(lSlider.valueLabel.center.x, lSlider.valueLabel.center.y+viewHeight);
                            lSlider.nameLabel.center = CGPointMake(lSlider.nameLabel.center.x, lSlider.nameLabel.center.y+viewHeight);
                        }
                    }
                }
            }
        }
         completion:^(BOOL finished) {
             NSInteger step = currentMeasureView.frame.size.height+5;
             for (LabeledSlider *object in currenSlidersArray) {
                 
                 object.nameLabel.frame = CGRectMake(currentMeasureView.frame.origin.x+5, currentMeasureView.frame.origin.y + step, currentMeasureView.frame.size.width/2, 20);
                 object.nameLabel.alpha = 0.0f;
                 [self.scrollView addSubview:object.nameLabel];
                 
                 object.valueLabel.frame = CGRectMake(currentMeasureView.frame.size.width/2+5, currentMeasureView.frame.origin.y + step, currentMeasureView.frame.size.width/2-10, 20);
                 object.valueLabel.alpha = 0.0f;
                 [self.scrollView addSubview:object.valueLabel];
                 
                 step = step+25;
                 
                 object.frame =CGRectMake(currentMeasureView.frame.origin.x+5, currentMeasureView.frame.origin.y + step, currentMeasureView.frame.size.width-10, 20);
                 object.alpha = 0.0f;
                 [self.scrollView addSubview:object];
                 
                 step = step+25;
             }

             
             [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                 
                 for (LabeledSlider *object in currenSlidersArray) {
                     object.alpha = 1.0f;
                     object.nameLabel.alpha = 1.0f;
                     object.valueLabel.alpha = 1.0f;
                 }
                 
             }
             completion:^(BOOL finished) {
                                  
             }];
         }];
         self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height+viewHeight);
       
        //[self.scrollView scrollRectToVisible:CGRectMake(0, currentMeasureView.frame.origin.y, currentMeasureView.frame.size.width, currentMeasureView.frame.origin.y+currentMeasureView.frame.size.height) animated:YES];
        
    }
    else{
        [viewsStateArray replaceObjectAtIndex:currentTag withObject:@"0"];
       
        [(UIButton *)sender setTitle:NSLocalizedString(@"Expand",nil) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            for (LabeledSlider *object in currenSlidersArray) {
                
                object.alpha = 0.0f;
                object.nameLabel.alpha = 0.0f;
                object.valueLabel.alpha = 0.0f;
            }

        }
         completion:^(BOOL finished) {
             for (LabeledSlider *object in currenSlidersArray) {
                 
                 [object removeFromSuperview];
                 [object.nameLabel removeFromSuperview];
                 [object.valueLabel removeFromSuperview];
             }

             
             [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                 for (id currentObject in [self.scrollView subviews]) {
                     if ([currentObject isKindOfClass:[MeasureView class]]){
                         if (((MeasureView *)currentObject).tag > currentTag){
                             ((MeasureView *)currentObject).center = CGPointMake(viewXCenter, ((MeasureView *)currentObject).center.y-viewHeight);
                             
                             NSArray *tmpSlidersArray = ((MeasureView *)currentObject).slidersArray;
                             for (LabeledSlider *lSlider in tmpSlidersArray) {
                                 lSlider.center = CGPointMake(lSlider.center.x, lSlider.center.y-viewHeight);
                                 lSlider.valueLabel.center = CGPointMake(lSlider.valueLabel.center.x, lSlider.valueLabel.center.y-viewHeight);
                                 lSlider.nameLabel.center = CGPointMake(lSlider.nameLabel.center.x, lSlider.nameLabel.center.y-viewHeight);
                             }
   
                        }
                     }
                 }
                 

             }
          completion:^(BOOL finished) {
              [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                  self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height-viewHeight);
              }
              completion:^(BOOL finished) {
              }];

          }];
         }];
        
           
    }
    
        
}

#pragma mark scrollView delegate methods

-(void)scrollViewDidScroll:(UIScrollView *)sView
{
 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    //NSLog(@"%f",sView.contentOffset.y/sView.frame.size.height);
    
    MeasureView *mView = (MeasureView *)sView.superview;
    for (LabeledSlider *lSlider in mView.slidersArray) {
        
        if ([lSlider.sliderKey isEqualToString:@"Inside leg"]){
            continue;
        }
        if (([mView.viewKey isEqualToString:@"Bras"]) && ([lSlider.sliderKey isEqualToString:@"Chest"])){
            continue;
        }
        
        
        //[lSlider setValue:(lSlider.minimumValue+lSlider.step*(sView.contentOffset.y/sView.frame.size.height)) animated:YES];
        [lSlider setValue:[[MeasureManager sharedMeasureManager] getSizeValueForKey:lSlider.sliderKey PersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender] andState:roundf(sView.contentOffset.y/sView.frame.size.height)] animated:YES];
        lSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", lSlider.value];
        
        //definig letter fo bra 
        if (([mView.viewKey isEqualToString:@"Bras"]) && ([lSlider.sliderKey isEqualToString:@"Under chest"])){
            float chestValue = 0.0f;
            
            for (LabeledSlider *sl in mView.slidersArray) {
                if ([sl.sliderKey isEqualToString:@"Chest"]){
                    chestValue = sl.value;
                    break;
                }
            }
            
            mView.additionalInfoLabel.text = [[MeasureManager sharedMeasureManager] getLetterForBrasSizeWithChest:chestValue andUnderChest:lSlider.value];
        }

        
        //[self sliderStopped:lSlider];
        
        for (id currentObject in [self.scrollView subviews]) {
            if ([currentObject isKindOfClass:[MeasureView class]]){
                
                NSArray *tmpSlidersArray = ((MeasureView *)currentObject).slidersArray;
                for (LabeledSlider *lbSlider in tmpSlidersArray) {
                    if (lbSlider != lSlider){
                        if ([lbSlider.nameLabel.text isEqualToString:lSlider.nameLabel.text]){
                            lbSlider.value = lSlider.value;
                            lbSlider.valueLabel.text = lSlider.valueLabel.text;
                            [self updateSizesWhereSliderHasTheSameName:lbSlider];
                        }
                    }
                    
                }
            }
        }

    }

}

#pragma mark alert view delegate methods
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL updateSizeForOtherClothes = NO;
    
    //YES
    if (buttonIndex == 1){
        updateSizeForOtherClothes = YES;
    }
    
    if (updateSizeForOtherClothes){
       
        
        for (id currentView in [self.scrollView subviews]) {
            if ([currentView isKindOfClass:[MeasureView class]]){
                
                MeasureView * tmpView = (MeasureView *)currentView;
                NSInteger positionInSizesArray = roundf(tmpView.sizesScrollView.contentOffset.y/tmpView.sizesScrollView.frame.size.height);
                NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: positionInSizesArray]];
                
                //getting  dictionaty to change the size for the clothes with the same params
                NSArray *clothesWithTheSameSize = [[MeasureManager sharedMeasureManager] getClothesWithTheSameSizeForChoosenOne:tmpView.viewKey andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
                
                for (NSString *wear in clothesWithTheSameSize) {
                    // TODO: think about saving the additional info!!!
                    
                    [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey:wear];
                }
                [resultsArray release];
                
                resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: positionInSizesArray]];
                
                //adding additional info
                if ([tmpView.viewKey isEqualToString:@"Jeans"]){
                    for (LabeledSlider *currentSlider in tmpView.slidersArray) {
                        if ([currentSlider.sliderKey isEqualToString:@"Inside leg"]){
                            [resultsArray addObject:[NSNumber numberWithFloat:currentSlider.value]];
                            break;
                        }
                    }
                    
                }
                if ([tmpView.viewKey isEqualToString:@"Bras"]){
                    [resultsArray addObject:tmpView.additionalInfoLabel.text];
                }
                [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey:tmpView.viewKey];
                //saving body params
                for (LabeledSlider *currentSlider in tmpView.slidersArray) {
                    
                    [[[DataManager sharedDataManager] currentProfile] setObject:[NSNumber numberWithFloat:currentSlider.value] forKey:currentSlider.sliderKey];
                }

                
                [resultsArray release];
            }
        }
    }
    else{
        
        for (id currentView in [self.scrollView subviews]) {
            if ([currentView isKindOfClass:[MeasureView class]]){
                
            
                MeasureView * tmpView = (MeasureView *)currentView;
                NSInteger positionInSizesArray = roundf(tmpView.sizesScrollView.contentOffset.y/tmpView.sizesScrollView.frame.size.height);
                
                NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
                //adding main size
                [resultsArray addObject:[NSNumber numberWithInteger: positionInSizesArray]];
                //adding additional info
                if ([tmpView.viewKey isEqualToString:@"Jeans"]){
                    for (LabeledSlider *currentSlider in tmpView.slidersArray) {
                        if ([currentSlider.sliderKey isEqualToString:@"Inside leg"]){
                            [resultsArray addObject:[NSNumber numberWithFloat:currentSlider.value]];
                            break;
                        }
                    }
                    
                }
                if ([tmpView.viewKey isEqualToString:@"Bras"]){
                    [resultsArray addObject:tmpView.additionalInfoLabel.text];
                }
                [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey:tmpView.viewKey];
                //saving body params
                for (LabeledSlider *currentSlider in tmpView.slidersArray) {
                    
                    [[[DataManager sharedDataManager] currentProfile] setObject:[NSNumber numberWithFloat:currentSlider.value] forKey:currentSlider.sliderKey];
                }

                
                [resultsArray release];

                
                
            }
        }

        
    }
    
    
    
    //saving profile
    [[DataManager sharedDataManager] saveDataWithKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                              oldKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                       andDictionary:[[DataManager sharedDataManager] currentProfile]];
    
    //updating profile list
    [[DataManager sharedDataManager] getProfileList];
    
    ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
    resultController.bButtonType = rootButton;
    resultController.eButtonType = noButton;
    resultController.resultArray = self.whatToMeasureArray;
    [self.navigationController pushViewController:resultController animated:YES];
    [resultController release];

    
    
}
@end
