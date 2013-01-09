//
//  ResultViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 04.08.12.
//
//

#import "ResultViewController.h"


@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize profileImageView, nameLabel, bButtonType, sexLabel, bodyParamsLabel, eButtonType, fbButton,resultScrollView, resultArray, brandsButton;

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
    self.profileImageView = nil;
    self.nameLabel = nil;
    self.sexLabel = nil;
    self.bodyParamsLabel = nil;
    self.resultScrollView = nil;
    self.resultArray = nil;
    self.fbButton = nil;
    self.brandsButton = nil;
}

- (void)dealloc
{
    [profileImageView release];
    [nameLabel release];
    [sexLabel release];
    [bodyParamsLabel release];
    [resultScrollView release];
    [resultArray release];
    [fbButton release];
    [brandsButton release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.profileImageView.clipsToBounds =YES;
    self.profileImageView.layer.cornerRadius = 10.0f;

    //just viewing results
    if (eButtonType != noButton){
        UIBarButtonItem *changeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editData)] ;
    
        self.navigationItem.rightBarButtonItem = changeButton;
        [changeButton release];
        self.fbButton.hidden = NO;
        [self.fbButton setTitle:NSLocalizedString(@"Send by e-mail", nil) forState:UIControlStateNormal];
    }
    //viewing results after measuring
    else{
        self.fbButton.hidden = NO;
        [self.fbButton setTitle:NSLocalizedString(@"Wrong size?", nil) forState:UIControlStateNormal];
    }
    [self.brandsButton setTitle:NSLocalizedString(@"Sizes by brands", nil) forState:UIControlStateNormal];
    
    if (self.bButtonType == rootButton){
        UIBarButtonItem *backToProfilesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profiles", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backToProfiles)] ;
        
        self.navigationItem.leftBarButtonItem = backToProfilesButton;
        [backToProfilesButton release];
    }
    self.title = NSLocalizedString(@"Result", nil);
    
    
    
    [self fillScrollViewWithSizes];
   
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[DataManager sharedDataManager] currentProfile]){
        
        NSString *name = [[[DataManager sharedDataManager] currentProfile] objectForKey:@"name"];
        
        name = [name stringByAppendingString:@" "];
        
        name = [name stringByAppendingString:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"surname"]];
        
        
        self.nameLabel.text = name;

        self.sexLabel.text = NSLocalizedString([[[MeasureManager sharedMeasureManager] getGenderList] objectAtIndex:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]], nil);
        NSString *bodyParams = @"";
        if ([[[DataManager sharedDataManager] currentProfile] objectForKey:@"Chest"] )
        {
            //chest
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(@"Chest", nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.2f cm", [[[[DataManager sharedDataManager] currentProfile] objectForKey:@"Chest"] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.2f inch\n", [[[[DataManager sharedDataManager] currentProfile] objectForKey:@"Chest"] floatValue]/2.54f]];

            
        }
        if ([[[DataManager sharedDataManager] currentProfile] objectForKey:@"Waist"] )
        {
            //waist
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(@"Waist", nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.2f cm", [[[[DataManager sharedDataManager] currentProfile] objectForKey:@"Waist"] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.2f inch\n", [[[[DataManager sharedDataManager] currentProfile] objectForKey:@"Waist"] floatValue]/2.54f]];
            
        }
        if ([[[DataManager sharedDataManager] currentProfile] objectForKey:@"Hips"] )
        {
            //waist
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(@"Hips", nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.2f cm", [[[[DataManager sharedDataManager] currentProfile] objectForKey:@"Hips"] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.2f inch ", [[[[DataManager sharedDataManager] currentProfile] objectForKey:@"Hips"] floatValue]/2.54f]];

            
        }

        
        self.bodyParamsLabel.text = bodyParams;
        
        //getting photo
        NSData *imageData = [[[DataManager sharedDataManager] currentProfile] objectForKey:@"photo"];
        if (imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.profileImageView.image = image;
        }
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - help functions

- (NSString *) getCurrentProfileSizes
{
    NSString *resStr = @"";
    NSArray *stuffArray;
    
    NSArray *countries = [NSArray arrayWithObjects:@"EU", @"RU", @"US", @"UK", @"INT", nil];
    
    if (self.resultArray){
        stuffArray = self.resultArray;
    }
    else{
        stuffArray = [[MeasureManager sharedMeasureManager] getClothesListForPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
    }
    
    for (NSString *clothesType in stuffArray) {
        
        if ([[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:0] integerValue] != -1)
        {
            
            resStr = [resStr stringByAppendingString:NSLocalizedString(clothesType, nil)];
            resStr = [resStr stringByAppendingString:@": "];
            
            NSArray *sizesArray =  [[MeasureManager sharedMeasureManager] getSizesListForClothesType:clothesType personType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender] andIndex:[[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:0] integerValue]];
            
            NSString *additionalInfo = @"";
            if ([[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] count] == 2){
                /*
                 if ([clothesType isEqualToString:@"Trousers & jeans"]){
                 additionalInfo = [[MeasureManager sharedMeasureManager] getLegLengthDescriptionForValue:[[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:1] floatValue] andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
                 }
                 */
                //letter for bra size
                if ([clothesType isEqualToString:@"Bras"]){
                    additionalInfo = [[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:1];
                }
                
            }
            NSInteger i = 0;
            for (NSString *sizeString in sizesArray) {
                resStr = [resStr stringByAppendingString:[countries objectAtIndex:i]];
                resStr = [resStr stringByAppendingString:@" - "];
                resStr = [resStr stringByAppendingString:sizeString];
                resStr = [resStr stringByAppendingString:@"; "];
                i++;
            }
            resStr = [resStr stringByAppendingString: additionalInfo];
            resStr = [resStr stringByAppendingString:@"\n"];
        }
        
        
    }
    resStr = [resStr stringByAppendingString:@"\n"];
    resStr = [resStr stringByAppendingString: NSLocalizedString(@"Sent from EasySize", nil)];
    return resStr;
    
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

- (void) fillScrollViewWithSizes
{
    float currentY = 0;
    NSArray *stuffArray;
    
    if (self.resultArray){
        stuffArray = self.resultArray;
    }
    else{
        stuffArray = [[MeasureManager sharedMeasureManager] getClothesListForPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
    }
    
    for (NSString *clothesType in stuffArray) {
        
        if ([[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:0] integerValue] != -1)
        {
            
            NSArray *sizesArray =  [[MeasureManager sharedMeasureManager] getSizesListForClothesType:clothesType personType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender] andIndex:[[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:0] integerValue]];
            
            NSString *additionalInfo = @"";
            if ([[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] count] == 2){
                //NSLog(@"%@",clothesType);
                /*
                if ([clothesType isEqualToString:@"Trousers & jeans"]){
                    additionalInfo = [[MeasureManager sharedMeasureManager] getLegLengthDescriptionForValue:[[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:1] floatValue] andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
                }
                 */
                //letter for bra size
                if ([clothesType isEqualToString:@"Bras"]){
                    additionalInfo = [[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:1];
                }

            }
            
            CGRect currentFrame = CGRectMake(0, currentY, self.resultScrollView.frame.size.width, 120);
            
            [self createSizeViewWithFrame:currentFrame Background:[UIImage imageNamed:@"cell_background.png"] Title:clothesType sizesArray:sizesArray addInfo:additionalInfo];
            currentY = currentY + 120;
        }
        
        
    }
    
    self.resultScrollView.contentSize = CGSizeMake(self.resultScrollView.frame.size.width , currentY);
}


- (void) createSizeViewWithFrame:(CGRect) frame Background:(UIImage *) bg  Title:(NSString *) title sizesArray:(NSArray *) sizesArray addInfo:(NSString *) additionalInfo
{
    //image cell
    MeasureView *currentView = [[MeasureView alloc] initWithFrame:frame];
    currentView.userInteractionEnabled = YES;
    currentView.image = bg;
    currentView.viewKey = title;
    
    //adding gesture to image view
    UISwipeGestureRecognizer *swipeShowRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteButton:)];
    swipeShowRecognizer.direction =UISwipeGestureRecognizerDirectionRight;
    [currentView addGestureRecognizer:swipeShowRecognizer];
    [swipeShowRecognizer release];
    
    UISwipeGestureRecognizer *swipeHideRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideDeleteButton:)];
    swipeHideRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;
    [currentView addGestureRecognizer:swipeHideRecognizer];
    [swipeHideRecognizer release];

    
    //title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, currentView.frame.size.width, 17)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment =UITextAlignmentCenter;
    label.text = NSLocalizedString(title, nil);
    [currentView addSubview:label];
    [label release];

    //additional info label
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentView.frame.size.height-37, currentView.frame.size.width/2, 25)];
    infoLabel.textColor = [UIColor blackColor];
    infoLabel.font = [UIFont systemFontOfSize:16.0f];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.numberOfLines = 0;
    infoLabel.lineBreakMode = UILineBreakModeWordWrap;
    infoLabel.textAlignment =UITextAlignmentLeft;
    infoLabel.text = additionalInfo;
    [currentView addSubview:infoLabel];
    [infoLabel release];

    
    //flags view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 40, 35)];
    imageView.image = [UIImage imageNamed:@"EU_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 25, 40, 35)];
    imageView.image = [UIImage imageNamed:@"RUS_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 25, 40, 35)];
    imageView.image = [UIImage imageNamed:@"US_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(205, 25, 40, 35)];
    imageView.image = [UIImage imageNamed:@"UK_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 25, 40, 35)];
    imageView.image = [UIImage imageNamed:@"World_Flag.png"];
    [currentView addSubview:imageView];
    [imageView release];
    
    /*
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 40, 35)];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor brownColor];
    labelView.font = [UIFont systemFontOfSize:15.0f];
    labelView.adjustsFontSizeToFitWidth = YES;
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.textAlignment =UITextAlignmentCenter;
    labelView.text = @"EU";
    [currentView addSubview:labelView];
    [labelView release];
    
    labelView = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 40, 35)];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor brownColor];
    labelView.font = [UIFont systemFontOfSize:15.0f];
    labelView.adjustsFontSizeToFitWidth = YES;
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.textAlignment =UITextAlignmentCenter;
    labelView.text = @"RUS";
    [currentView addSubview:labelView];
    [labelView release];

    labelView = [[UILabel alloc] initWithFrame:CGRectMake(140, 25, 40, 35)];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor brownColor];
    labelView.font = [UIFont systemFontOfSize:15.0f];
    labelView.adjustsFontSizeToFitWidth = YES;
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.textAlignment =UITextAlignmentCenter;
    labelView.text = @"US";
    [currentView addSubview:labelView];
    [labelView release];

    labelView = [[UILabel alloc] initWithFrame:CGRectMake(205, 25, 40, 35)];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor brownColor];
    labelView.font = [UIFont systemFontOfSize:15.0f];
    labelView.adjustsFontSizeToFitWidth = YES;
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.textAlignment =UITextAlignmentCenter;
    labelView.text = @"UK";
    [currentView addSubview:labelView];
    [labelView release];

    labelView = [[UILabel alloc] initWithFrame:CGRectMake(270, 25, 40, 35)];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textColor = [UIColor brownColor];
    labelView.font = [UIFont systemFontOfSize:15.0f];
    labelView.adjustsFontSizeToFitWidth = YES;
    labelView.lineBreakMode = UILineBreakModeWordWrap;
    labelView.textAlignment =UITextAlignmentCenter;
    labelView.text = @"INT";
    [currentView addSubview:labelView];
    [labelView release];
    */
    
    float xPoint = 10.0f;
    for (NSString *sizeString in sizesArray) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, 55, 40, 30)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.textAlignment =UITextAlignmentCenter;
        label.text = sizeString;
        [currentView addSubview:label];
        [label release];
        xPoint = xPoint+40+25;
    }
    
    
    [self.resultScrollView addSubview:currentView];
    [currentView release];
}



#pragma mark - actions

- (IBAction) showBrands:(id) sender
{
    BrandsViewController *controller = [[BrandsViewController alloc] initWithNibName:@"BrandsView" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}


- (IBAction) showTips:(id) sender
{
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    //controller.delegate = self;
    //controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:controller animated:YES completion:NULL];
    controller.numberOfPageToShow = 1;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(IBAction) showFeedbackOrEmailForm:(id) sender
{
    //just viewing results
    //and sending e-mail
    if (eButtonType != noButton){
        if(![MFMailComposeViewController canSendMail]) {
            [self showAlertDialogWithTitle:@"Warning" andMessage:@"Can't send e-mail"];
            
        } else {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setSubject:[NSLocalizedString(@"Sizes of ", nil) stringByAppendingString:self.nameLabel.text]];
            [mailController setToRecipients:
             [NSArray arrayWithObjects:@"person_mail@mail.com", nil]];
            
            [mailController setMessageBody:[self getCurrentProfileSizes]
                                    isHTML:NO];
            
            mailController.mailComposeDelegate = self;
            /*
            NSString *path = [[NSBundle mainBundle] pathForResource:@"my_logo"
                                                             ofType:@"png"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            [mailController addAttachmentData:myData mimeType:@"image/png"
                                     fileName:@"my_logo"];
            */
            [self presentViewController:mailController animated:YES completion:NULL];
            [mailController  release];
        }
        
    }
    //show sending feedback form
    else{
        FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
        controller.textForFeedbackLabel = @"Tell us about your problem" ;
        controller.form = result;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }

}

- (void) showDeleteButton:sender
{
    //uncheking wear at the table
    UIView *swipedView = ((UISwipeGestureRecognizer *)sender).view;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(swipedView.frame.size.width-90, swipedView.frame.size.height-37, 80, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"grayBtnBackground.png"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [button setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anyDelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setAlpha:0.0f];
    [swipedView addSubview:button];

    

    [UIView animateWithDuration:0.5f animations:^{
        [button setAlpha:1.0f];
    }
    completion:^(BOOL finished) {
                         
    }];
    
}

- (void) hideDeleteButton:sender
{
    
    UIView *swipedView = ((UISwipeGestureRecognizer *)sender).view;
    
    for (UIView *view in [swipedView subviews]) {
        if ([view isKindOfClass:[UIButton class]]){
            
            [UIView animateWithDuration:0.5f animations:^{
                view.alpha = 0.0f;
            }
            completion:^(BOOL finished) {
                 [view removeFromSuperview];
            }];
            break;
        }
    }
    
      
}

- (void) anyDelButtonPressed:sender
{
    UIButton *delButton = (UIButton *)sender;
    
    MeasureView *owner = (MeasureView *)[delButton superview];
    
    [delButton removeFromSuperview];
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    //adding main size
    [resultsArray addObject:[NSNumber numberWithInteger: -1]];
    
    [[[DataManager sharedDataManager] currentProfile] setObject:resultsArray forKey:owner.viewKey];
    [resultsArray release];
    
    //saving profile
    [[DataManager sharedDataManager] saveDataWithKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                          oldKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"]
                                   andDictionary:[[DataManager sharedDataManager] currentProfile]];

    //updating profile list
    [[DataManager sharedDataManager] getProfileList];
    
    [owner removeFromSuperview];
    
    //cleaning scrollview
    for (UIView *view in [self.resultScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    
    [self fillScrollViewWithSizes];

}

- (void) backToProfiles
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) editData
{
    
    UIActionSheet *startSheet = [[UIActionSheet alloc]
                                 initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:NSLocalizedString(@"Edit profile data", nil),
                                 NSLocalizedString(@"Edit sizes", nil),  nil];
    
    [startSheet showInView:self.view];
    [startSheet release];

    
   }

#pragma mark - MFMailComposeViewControllerDelegate methods
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *strResult = nil;
    switch(result) {
        case MFMailComposeResultCancelled:
            strResult = @"E-mail canceled";
            break;
        case MFMailComposeResultSaved:
            strResult = @"E-mail saved";
            break;
        case MFMailComposeResultSent:
            strResult = @"E-mail sent";
            break;
        case MFMailComposeResultFailed:
        {
            if([error.domain isEqualToString:MFMailComposeErrorDomain]) {
                switch(error.code) {
                    case MFMailComposeErrorCodeSendFailed:
                        strResult = @"Can't send e-mail";
                        break;
                    case MFMailComposeErrorCodeSaveFailed:
                        strResult = @"Can't save e-mail";
                        break;
                }
            } else {
                strResult = @"Can't send e-mail";
            }
            break;
        }
        default:
            strResult = @"Can't send e-mail";
    }
    
    [self showAlertDialogWithTitle:@"" andMessage:strResult];
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - newProfileViewController delegate methods

- (void)newProfileViewControllerDidFinish:(NewProfileViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) newProfileViewControllerUpdateData:(NSMutableDictionary *)dataDictionary
{
    [[DataManager sharedDataManager] setCurrentProfile: dataDictionary];
    
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
        // edit profile data
        if (buttonIndex == actionSheet.firstOtherButtonIndex){
            NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
            newProfileController.delegate = self;
            newProfileController.saveButtonAction = 2; //just save action
            [self.navigationController pushViewController:newProfileController animated:YES];
            [newProfileController release];
        }
        //edit sizes
        else if (buttonIndex == 1){
            
            NSString *nibName = nil;
            if ([[UIScreen mainScreen] bounds].size.height == 568){
                nibName = @"HowToMeasure568";
            }
            else{
                nibName = @"HowToMeasure";
            }
            
            HowToMeasureViewController *howToMeasureController = [[HowToMeasureViewController alloc] initWithNibName:nibName bundle:nil] ;
            howToMeasureController.backButtonNum = 99;
            [self.navigationController pushViewController:howToMeasureController animated:YES];
            [howToMeasureController release];

        }
                             
    }
}


@end
