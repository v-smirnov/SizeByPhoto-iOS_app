//
//  ResultViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 04.08.12.
//
//

#import "ResultViewController.h"
#import "MPAnimation.h"
#import "Consts.h"

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define WIRE_VIEW_TAG 100

#define SEND_SHEET 10
#define EDIT_SHEET 11
#define SHARE_SHEET 12

#define SHARE_ALERT 20
#define SAVE_PROFILE_ALERT 21


#define START_DIALOG_TAG 101


@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize profileImageView, nameLabel, backButton, bodyParamsLabel, editButton, fbButton, measuredStuff, genderImageView, startDialogController, stuffTableView;

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
    self.bodyParamsLabel = nil;
    self.measuredStuff = nil;
    self.fbButton = nil;
    [measureManager release]; measureManager = nil;
    self.genderImageView = nil;
    [startDialogController release]; startDialogController = nil;
    self.stuffTableView = nil;
}

- (void)dealloc
{
    [profileImageView release];
    [nameLabel release];
    [bodyParamsLabel release];
    [measuredStuff release];
    [fbButton release];
    [measureManager release];
    [genderImageView release];
    [startDialogController release];
    [stuffTableView release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userTapedOnSaveAsButton = false;
    
    self.profileImageView.clipsToBounds =YES;
    self.profileImageView.layer.cornerRadius = 10.0f;
    
    PersonKind pKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
    measureManager = [[VSMeasureManager alloc] initWithPersonKind:pKind];
    
      
    //just viewing results
    if (editButton == standartEditButton){
        
        UIBarButtonItem *measureButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Measure", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(startMeasure)] ;
        
        self.navigationItem.rightBarButtonItem = measureButton;
        [measureButton release];
        
        self.fbButton.hidden = NO;
    }
    else if (editButton == saveAsButton){
        UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save as", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveProfileData:)] ;
        self.navigationItem.rightBarButtonItem = saveAsButton;
        [saveAsButton release];
            
        self.fbButton.hidden = NO;
    }
    //viewing results after measuring
    else if (editButton == noButton){
        self.fbButton.hidden = NO;
    }
    
    if (self.backButton == rootButton){
        UIBarButtonItem *backToProfilesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profiles", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backToProfiles)] ;
        
        self.navigationItem.leftBarButtonItem = backToProfilesButton;
        [backToProfilesButton release];
    }
    
    self.measuredStuff = [measureManager getStuffForSizeDefining];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [[VSProfileManager sharedProfileManager] getCurrentProfileCharacteristic:PROFILE_NAME];
    
    // we have to reload stuff table if we change person kind
    if (measureManager){
        PersonKind pKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
        if (measureManager.personKind != pKind){
            measureManager.personKind = pKind;
            self.measuredStuff = [measureManager getStuffForSizeDefining];
            [self.stuffTableView reloadData];
        }
    }
    
    if (userTapedOnSaveAsButton){
        UIBarButtonItem *backToProfilesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Profiles", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backToProfiles)] ;
        
        self.navigationItem.rightBarButtonItem = backToProfilesButton;
        [backToProfilesButton release];
    }
    
    if ([[VSProfileManager sharedProfileManager] currentProfileNotEmpty]){
        
        NSString *name = [[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:PROFILE_NAME];
        
        name = [name stringByAppendingString:@" "];
        
        name = [name stringByAppendingString:[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:PROFILE_SURNAME]];
        
        self.nameLabel.textColor = MAIN_THEME_COLOR;
        self.nameLabel.font = [UIFont fontWithName:PROFILE_NAME_FONT size:SIZE_LABEL_FONT_SIZE];
        self.nameLabel.text = name;

        self.genderImageView.image = [[measureManager getPersonKindsImagesList] objectAtIndex:(NSInteger)[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]];
        
        NSString *bodyParams = @"";
        if ([[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:CHEST] )
        {
            //chest
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(@"Chest", nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.1f cm", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:CHEST] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.1f inch\n", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:CHEST] floatValue]/2.54f]];

            
        }
        
        if ([[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:UNDER_CHEST] )
        {
            //under chest
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(@"Under chest", nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.1f cm", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:UNDER_CHEST] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.1f inch\n", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:UNDER_CHEST] floatValue]/2.54f]];
            
        }
         
        if ([[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:WAIST] )
        {
            //waist
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(@"Waist", nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.1f cm", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:WAIST] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.1f inch\n", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:WAIST] floatValue]/2.54f]];
            
        }
        if ([[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:HIPS] )
        {
            //waist
            bodyParams = [bodyParams stringByAppendingString:NSLocalizedString(HIPS, nil)];
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@": %.1f cm", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:HIPS] floatValue]]];
            //inches
            bodyParams = [bodyParams stringByAppendingString:[NSString stringWithFormat:@"/%.1f inch ", [[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:HIPS] floatValue]/2.54f]];

            
        }

        
        self.bodyParamsLabel.text = bodyParams;
        
        //getting photo
        NSData *imageData = [[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:PROFILE_PHOTO];
        if (imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.profileImageView.image = image;
        }
        else{
            self.profileImageView.image = [UIImage imageNamed:@"No_photo"];
        }
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - help functions

- (void) unlockAllStuff
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:USER_UNLOCK_ALL_STUFF];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL) stuffUnlocked
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_UNLOCK_ALL_STUFF]){
        NSInteger num = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_UNLOCK_ALL_STUFF] integerValue];
        return (num == 1);
        //return false;
    }
    else{
        return false;
    }
    
}

- (void) shareViaTwitter
{

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                //NSLog(@"Cancelled");
                
            } else
                
            {
                [self unlockAllStuff];
                [self.stuffTableView reloadData];
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:@"#easysize"];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        [self showAlertDialogWithTitle:@"Twitter" andMessage:@"You can't send a twit right now. Make sure your device has an internet connection and you have at least one Twitter account setup."];
    }
    
}

- (void) shareViaFacebook
{
    //NSLog(@"F");
    
}

- (NSString *) getMessageBody
{
    NSString *resStr = @"";
    NSArray *stuffArray;
    
    
    if (self.measuredStuff){
        stuffArray = self.measuredStuff;
    }
    else{
        stuffArray = [measureManager getStuffForSizeDefining];
    }
    
    
    //start html-message
    resStr = [resStr stringByAppendingFormat:@"<!DOCTYPE HTML><html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body><p>%@</p>", NSLocalizedString(@"email_part1", nil)];
    
    
    NSInteger pKind = (NSInteger) [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
    
    if (pKind == Man){ 
        resStr = [resStr stringByAppendingFormat:@"<p>%@ %@ %@</p>", NSLocalizedString(@"email_part2", nil), self.nameLabel.text, NSLocalizedString(@"email_part3_0", nil)];
    }
    else if (pKind == Woman){
         resStr = [resStr stringByAppendingFormat:@"<p>%@ %@ %@</p>", NSLocalizedString(@"email_part2", nil), self.nameLabel.text, NSLocalizedString(@"email_part3_1", nil)];
    }
    else {
         resStr = [resStr stringByAppendingFormat:@"<p>%@ %@ %@</p>", NSLocalizedString(@"email_part2", nil), self.nameLabel.text, NSLocalizedString(@"email_part3", nil)];
    }
    
    resStr = [resStr stringByAppendingFormat:@"<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\"><tbody><tr><td valign=\"top\"></td><td valign=\"top\" ><p>EU</p></td><td valign=\"top\" ><p>RU</p></td><td valign=\"top\" ><p>US</p></td><td valign=\"top\" ><p>UK</p></td><td valign=\"top\" ><p>%@</p></td></tr>",  NSLocalizedString(@"email_part4", nil)];
    
    // html sizes table
    for (NSString *stuffType in stuffArray) {
        
        if ([[[[[VSProfileManager sharedProfileManager] currentProfile] objectForKey:stuffType] objectAtIndex:0] integerValue] != -1)
        {
            
            resStr = [resStr stringByAppendingFormat:@"<tr><td valign=\"middle\">%@</td>", NSLocalizedString(stuffType, nil)];
            
            NSArray *bodyParams = [measureManager getMeasureParamsForStuffType:stuffType];
            
            NSMutableDictionary *bodyParamsWithValues = [[NSMutableDictionary alloc] initWithCapacity:[bodyParams count]];
            for (NSString *param in bodyParams) {
                [bodyParamsWithValues setObject:[NSNumber numberWithFloat:[[VSProfileManager sharedProfileManager] getCurrentProfileValueForBodyParam:param]] forKey:param];
            }
            NSDictionary *sizes = [measureManager getSizesForStuffType:stuffType andBodyParams:bodyParamsWithValues];
            [bodyParamsWithValues release];
            
            NSString *additionalInfo = @"";
            if ([sizes objectForKey:@"additionalInfo"]){
                additionalInfo = [sizes objectForKey:@"additionalInfo"];
            }
            
            if ([sizes objectForKey:@"Sizes"]){
                NSArray *sizesArray = [sizes objectForKey:@"Sizes"];
                for (NSString *sizeString in sizesArray) {
                    if (![additionalInfo isEqualToString:@""]){
                        sizeString = [sizeString stringByAppendingString:additionalInfo];
                    }
                    resStr = [resStr stringByAppendingFormat:@"<td valign=\"middle\" align=\"center\">%@</td>", sizeString];
                    
                }
            }
            
            resStr = [resStr stringByAppendingString:@"</tr>"];
        }
        
        
    }
    resStr = [resStr stringByAppendingString:@"</tbody></table>"];
    
    //end html message
    resStr = [resStr stringByAppendingFormat:@"%@", NSLocalizedString(@"email_part5", nil)];
    
    resStr = [resStr stringByAppendingString:@"</body></html>"];
    
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

- (void) showYesNoDialogWithTitle:(NSString *) title message:(NSString *) message andTag:(NSInteger) tag{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(title, nil)
                          message:NSLocalizedString(message, nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"No", nil)
                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}

- (void) showShareDialogWithTitle:(NSString *) title message:(NSString *) message andTag:(NSInteger) tag{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(title, nil)
                          message:NSLocalizedString(message, nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"No, thanks", nil)
                          otherButtonTitles:NSLocalizedString(@"Share", nil), nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}


- (MeasureView *) createSizeViewWithFrame:(CGRect) frame background:(UIImage *) bg  stuffType:(NSString *) stuff
{
    
    NSArray *bodyParams = [measureManager getMeasureParamsForStuffType:stuff];
    
    NSMutableDictionary *bodyParamsWithValues = [[NSMutableDictionary alloc] initWithCapacity:[bodyParams count]];
    for (NSString *param in bodyParams) {
        [bodyParamsWithValues setObject:[NSNumber numberWithFloat:[[VSProfileManager sharedProfileManager] getCurrentProfileValueForBodyParam:param]] forKey:param];
    }
    NSDictionary *sizes = [measureManager getSizesForStuffType:stuff andBodyParams:bodyParamsWithValues];
    
    [bodyParamsWithValues release];
    
    NSString *additionalInfo = @"";
    if ([sizes objectForKey:@"additionalInfo"]){
        additionalInfo = [sizes objectForKey:@"additionalInfo"];
    }
    
    NSArray *sizesArray = nil;
    if ([sizes objectForKey:@"Sizes"]){
        sizesArray = [sizes objectForKey:@"Sizes"];
    }

    
    
    //image cell
    MeasureView *currentView = [[[MeasureView alloc] initWithFrame:frame] autorelease];
    currentView.userInteractionEnabled = YES;
    //currentView.contentMode = UIViewContentModeScaleAspectFit;
    currentView.image = bg;
    //[currentView setBackgroundColor:[UIColor lightGrayColor]];
    //[[currentView layer] setBorderWidth:2.0f];
    //[[currentView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    currentView.viewKey = stuff;
    /*
    //adding gesture to image view
    UISwipeGestureRecognizer *swipeShowRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteButton:)];
    swipeShowRecognizer.direction =UISwipeGestureRecognizerDirectionRight;
    [currentView addGestureRecognizer:swipeShowRecognizer];
    [swipeShowRecognizer release];
    
    UISwipeGestureRecognizer *swipeHideRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideDeleteButton:)];
    swipeHideRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;
    [currentView addGestureRecognizer:swipeHideRecognizer];
    [swipeHideRecognizer release];
     */
    
    //for left page right swipe
    /*
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    [rightSwipeGR setDirection: UISwipeGestureRecognizerDirectionRight];
    [currentView addGestureRecognizer:rightSwipeGR];
    [rightSwipeGR release];
    */
    
    //title
    CGRect titleLabelFrame;
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        titleLabelFrame = CGRectMake(0, 30, currentView.frame.size.width, 20);
    }
    else{
        titleLabelFrame = CGRectMake(0, 20, currentView.frame.size.width, 20);
    }
    UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:SIZE_LABEL_TITLE_FONT size:SIZE_LABEL_TITLE_FONT_SIZE];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment =NSTextAlignmentCenter;
    label.text =  [NSLocalizedString(stuff, nil) uppercaseString];
    [currentView addSubview:label];
    [label release];

   
    //to imitate angle for flags use direction var
    NSInteger slopeDirection = -1;
    
    
    //flags view
    NSArray *flags = [NSArray arrayWithObjects:@"eu_flag.png", @"ru_flag.png", @"us_flag.png", @"uk_flag.png", @"wo_flag.png", nil];
    float yPoint;
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        yPoint= 80.0f;
    }
    else{
        yPoint = 62.0f;
    }
    NSInteger slopeKoef = 0;
    for (NSString *flag in flags) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25 + (slopeKoef*slopeDirection), yPoint, 25, 25)];
        imageView.image = [UIImage imageNamed:flag];
        [currentView addSubview:imageView];
        [imageView release];
        
        yPoint = yPoint + 30;
        slopeKoef++;
    }
    UIButton *addCountryButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addCountryButton setFrame:CGRectMake(25+(slopeKoef*slopeDirection), yPoint, 25, 25)];
    [currentView addSubview:addCountryButton];
    [addCountryButton addTarget:self action:@selector(onAddCountryButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        yPoint= 80.0f;
    }
    else{
        yPoint = 62.0f;
    }
    slopeKoef = 0;
    for (NSString *sizeString in sizesArray) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2+(slopeKoef*slopeDirection), yPoint, frame.size.width/2-(slopeKoef*slopeDirection), 25)];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:SIZE_LABEL_FONT size:SIZE_LABEL_FONT_SIZE];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment =NSTextAlignmentCenter;
        if (![additionalInfo isEqualToString:@""]){
            label.text = [NSString stringWithFormat:@"%@ %@", sizeString, additionalInfo];
        }
        else{
            label.text = sizeString;
        }
        [currentView addSubview:label];
        [label release];
        yPoint = yPoint+25+5;
        slopeKoef++;
    }
    
    return currentView;
}





#pragma mark - actions

- (void) showSaveDialog
{
    [self showYesNoDialogWithTitle:@"" message:@"Do you want to save current profile?" andTag:SAVE_PROFILE_ALERT];
}


- (void) onAddCountryButtonTap:(id)sender
{
    FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
    controller.textForFeedbackLabel = @"Add your country" ;
    controller.form = result;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}


- (void) onAddBrandButtonTap:(id)sender
{
    FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
    controller.textForFeedbackLabel = @"Add your favorite brand" ;
    controller.form = result;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}

- (void)editProfileData:(id)sender
{
    NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
    newProfileController.saveButtonAction = saveButtonAction_save;
    [self.navigationController pushViewController:newProfileController animated:YES];
    [newProfileController release];
}

- (void)saveProfileData:(id)sender
{
    [[LocalyticsSession shared] tagEvent:@"User goes to saving profile screen"];
    
    userTapedOnSaveAsButton = true;
    
    NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
    newProfileController.saveButtonAction = saveButtonAction_save;
    [self.navigationController pushViewController:newProfileController animated:YES];
    [newProfileController release];
}


- (void) backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction) showTips:(id) sender
{
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    controller.numberOfPageToShow = 1;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(IBAction) showFeedbackOrEmailForm:(id) sender
{

    UIActionSheet *sendSheet = [[UIActionSheet alloc]
                                 initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                 destructiveButtonTitle:nil
                                 otherButtonTitles: NSLocalizedString(@"Send feedback", nil),
                                 NSLocalizedString(@"Send sizes via e-mail", nil), nil];
    [sendSheet setTag:SEND_SHEET];
    [sendSheet showInView:self.view];
    [sendSheet release];

    
}



- (void) backToProfiles
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) startMeasure
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *startDialogView = [[appDelegate window] viewWithTag:START_DIALOG_TAG];
    
    if (!startDialogView){
        startDialogController = [[StartDialogViewController alloc] initWithNibName:@"StartDialogView" bundle:nil] ;
        startDialogController.delegate = self;
        startDialogController.startingFrom = startingFromOtherView;
        [[startDialogController view] setCenter:[[appDelegate window] center]];
        [[startDialogController view] setTag:START_DIALOG_TAG];
        [[appDelegate window] addSubview:[startDialogController view]];
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[startDialogController view] setAlpha:1.0f];
            [[startDialogController view] setCenter:[[appDelegate window] center]];
        }
                         completion:^(BOOL finished) {
                             //
                         }];
    }

    
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


#pragma mark action sheet delegate methods

- (void) willPresentActionSheet:(UIActionSheet *)actionSheet
{
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ){
    
        for (UIView *btnView in actionSheet.subviews)
        {
            if ([btnView isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton*) btnView;
                
                [btn setBackgroundImage:[UIImage imageNamed:@"asBtnBackground.png"]  forState:UIControlStateHighlighted];
            }
        }
    }
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([actionSheet tag] == EDIT_SHEET){

        if (buttonIndex == actionSheet.cancelButtonIndex){
            
        }
        else
        {
            // edit profile data
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
                newProfileController.saveButtonAction = saveButtonAction_save;
                [self.navigationController pushViewController:newProfileController animated:YES];
                [newProfileController release];
            }
            //edit sizes
            else if (buttonIndex == 1){
                /*
                NSString *nibName = nil;
                if ([[UIScreen mainScreen] bounds].size.height == 568){
                    nibName = @"HowToMeasure568";
                }
                else{
                    nibName = @"HowToMeasure";
                }
                
                HowToMeasureViewController *howToMeasureController = [[HowToMeasureViewController alloc] initWithNibName:nibName bundle:nil] ;
                howToMeasureController.backButtonAction = backButtonAction_goToResults;
                [self.navigationController pushViewController:howToMeasureController animated:YES];
                [howToMeasureController release];
                 */
            }
                                 
        }
    }
    else if ([actionSheet tag] == SEND_SHEET){
        if (buttonIndex == actionSheet.cancelButtonIndex){
            
        }
        else
        {
            // send feedback
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
                controller.textForFeedbackLabel = @"Tell us about your problem" ;
                controller.form = result;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];

            }
            //send mail
            else if (buttonIndex == 1){
                if(![MFMailComposeViewController canSendMail]) {
                    [self showAlertDialogWithTitle:@"Warning" andMessage:@"Can't send e-mail"];
                    
                } else {
                    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                    [mailController setSubject:[self.nameLabel.text stringByAppendingString:NSLocalizedString(@"'s sizes", nil)]];
                    [mailController setToRecipients:
                     [NSArray arrayWithObjects:@"_recipient@mail.com", nil]];
                    
                    [mailController setMessageBody:[self getMessageBody]
                                            isHTML:YES];
                    
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
            
        }

        
    }
    else if ([actionSheet tag] == SHARE_SHEET){
        if (buttonIndex == actionSheet.cancelButtonIndex){
            
        }
        else{
            if (buttonIndex == actionSheet.firstOtherButtonIndex){ //share via twitter
                [self shareViaTwitter];
            }
            else if (buttonIndex == 1){ // share via facebook
                [self shareViaFacebook];
            }
        }
    }
}


#pragma mark - StartDialogViewControllerDelegate
-(void) startMeasureUsingPhotoSource:(UIImagePickerControllerSourceType) sourceType
{
    
    self.navigationController.navigationBar.hidden = false;
    
    NSString *measureViewNib = nil;
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        measureViewNib = @"MeasureView568";
    }
    else{
        measureViewNib = @"MeasureView";
    }
    
    
    MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
    measureController.makeMeasurementsUsingTwoPhotos = YES;
    measureController.source = sourceType;
    [self.navigationController pushViewController:measureController animated:YES];
    [measureController release];
    
}

#pragma mark - Table view delegate methods

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return 80.0f;
 }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.measuredStuff count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{static NSString *CellIdentifier = @"Cell";
    
    StuffCell *cell = (StuffCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StuffCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        //инициализация фонов
        cell.backgroundView = [[UIImageView new] autorelease];
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.stuffImageView.frame = CGRectMake(20, cell.frame.size.height/2-15, 30, 30);
        //cell.customImageView.center = CGPointMake(40, 40);
        
    }
    
    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"stuff_choosing_cell.png"];
    ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"stuff_choosing_cell_pressed.png"];
    
    NSString *currentStuff = [self.measuredStuff objectAtIndex:indexPath.row];
    
    cell.stuffTextLabel.font = [UIFont fontWithName:PROFILE_NAME_FONT size:PROFILE_NAME_FONT_SIZE];
    cell.stuffTextLabel.textColor = MAIN_THEME_COLOR;
    cell.stuffTextLabel.text = NSLocalizedString(currentStuff, nil);
    
    
    cell.stuffImageView.image = [UIImage imageNamed:[currentStuff stringByAppendingFormat:@"_%d",[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]]];
    
    if (![self stuffUnlocked]){
        NSSet *lockedStuff = [measureManager getLockedBeforeSharingStuff];
        if ([lockedStuff containsObject:currentStuff]){
            cell.lockImageView.image = [UIImage imageNamed:@"locker.png"];
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSSet *lockedStuff;
    if ([self stuffUnlocked]){
        lockedStuff = [NSSet set];
    }
    else{
        lockedStuff = [measureManager getLockedBeforeSharingStuff];
    }
    
    NSString *currentStuff = [self.measuredStuff objectAtIndex:indexPath.row];
    
    if ([lockedStuff containsObject:currentStuff]){
        [self showShareDialogWithTitle:@"" message:@"Share via social networks to unlock the item?" andTag:SHARE_ALERT];
    }
    else{
        SizesViewController *sizesController = [[SizesViewController alloc] initWithNibName:@"SizesView" bundle:nil];
        sizesController.stuffToShowSizes = currentStuff;
        [self.navigationController pushViewController:sizesController animated:YES];
        [sizesController release];
    }
    
    
}

#pragma mark alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SHARE_ALERT){
        if (buttonIndex == 0){//No
            //
        }
        else if (buttonIndex == 1){ //Yes
            UIActionSheet *sendSheet = [[UIActionSheet alloc]
                                        initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                        delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: NSLocalizedString(@"Share via Twitter", nil),nil];
            [sendSheet setTag:SHARE_SHEET];
            [sendSheet showInView:self.view];
            [sendSheet release];

        }
    }
    else if (alertView.tag == SAVE_PROFILE_ALERT) {
        if (buttonIndex == 0){//No
            [[VSProfileManager sharedProfileManager] deleteTempProfile];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1){ //Yes
            [self editProfileData:nil];
        }

    }
    
}



@end
