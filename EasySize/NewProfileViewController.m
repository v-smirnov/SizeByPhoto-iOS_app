//
//  DetailViewController.m
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewProfileViewController.h"

#define START_DIALOG_TAG 101

@interface NewProfileViewController ()

@end

@implementation NewProfileViewController

@synthesize profileImageView, nameField, surnameField, ageField, saveButtonAction, sexScrollView, genderSegmentedControl, startDialogController, mainProfileButton, createdMainProfile, mainProfileLabel;




- (void)dealloc
{
    [nameField release];
    [surnameField release];
    [ageField release];
    [profileImageView release];
    [sexScrollView release];
    [genderSegmentedControl release];
    [measureManager release];
    [startDialogController release];
    [mainProfileButton release];
    [mainProfileLabel release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.profileImageView  = nil;
    self.nameField = nil;
    self.surnameField = nil;
    self.ageField = nil;
    self.sexScrollView = nil;
    self.genderSegmentedControl = nil;
    [measureManager release]; measureManager = nil;
    self.startDialogController = nil;
    self.mainProfileButton = nil;
    self.mainProfileLabel = nil;
}


#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    userMakeCurrentProfileMain = false;
    userSelectedNewPhoto = false;
    
    self.title = NSLocalizedString(@"Profile", nil);
    
    [self.mainProfileLabel setTextColor: MAIN_THEME_COLOR];
    [self.mainProfileLabel setFont: [UIFont fontWithName:PROFILE_NAME_FONT size:13.0f]];
    [self.mainProfileLabel setText: NSLocalizedString(@"My profile", nil)];

    
    self.nameField.font = [UIFont fontWithName:EDIT_PROFILE_TEXT_FIELD_FONT size:EDIT_PROFILE_TEXT_FIELD_FONT_SIZE];
    self.nameField.textColor = MAIN_THEME_COLOR;
    self.nameField.placeholder = NSLocalizedString(@"name", nil);    
    self.surnameField.font = [UIFont fontWithName:EDIT_PROFILE_TEXT_FIELD_FONT size:EDIT_PROFILE_TEXT_FIELD_FONT_SIZE];
    self.surnameField.textColor = MAIN_THEME_COLOR;
    self.surnameField.placeholder = NSLocalizedString(@"surname", nil);
    self.ageField.font = [UIFont fontWithName:EDIT_PROFILE_TEXT_FIELD_FONT size:EDIT_PROFILE_TEXT_FIELD_FONT_SIZE];
    self.ageField.textColor = MAIN_THEME_COLOR;
    self.ageField.placeholder = NSLocalizedString(@"age", nil);
    
    self.profileImageView.clipsToBounds =YES;
    self.profileImageView.layer.cornerRadius = 10.0f;
    
    if (self.saveButtonAction == saveButtonAction_saveAndStartMeasure){
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Measure", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveProfileData)] ;
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];

    }
    else{
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveProfileData)] ;
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
    }
       
   
    
    if ([[VSProfileManager sharedProfileManager] currentProfileNotEmpty]){
        self.nameField.text = (NSString *)[[VSProfileManager sharedProfileManager] getCurrentProfileCharacteristic:PROFILE_NAME];
        self.surnameField.text = (NSString *)[[VSProfileManager sharedProfileManager] getCurrentProfileCharacteristic:PROFILE_SURNAME];
        self.ageField.text = (NSString *)[[VSProfileManager sharedProfileManager] getCurrentProfileCharacteristic:PROFILE_AGE];
        
        //getting photo
        NSData *imageData = (NSData *)[[VSProfileManager sharedProfileManager] getCurrentProfileCharacteristic:PROFILE_PHOTO];
        if (imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.profileImageView.image = image;
        }
        else{
            self.profileImageView.image = [UIImage imageNamed:@"Add_photo"];
        }
        
        if ([[VSProfileManager sharedProfileManager] currentProfileIsMainUserProfile]){
            userMakeCurrentProfileMain = true;
            [self.mainProfileButton setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
        }
    
    }
    else{
        if (self.createdMainProfile){
            userMakeCurrentProfileMain = true;
            [self.mainProfileButton setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
        }
    }
    measureManager = [[VSMeasureManager alloc] init];
    
    NSArray *personKindsList = [measureManager getPersonKindsList];
    
       
    for (NSString *personKind in personKindsList) {
             
       [self.genderSegmentedControl setTitle:NSLocalizedString(personKind, nil) forSegmentAtIndex:[personKindsList indexOfObject:personKind]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[VSProfileManager sharedProfileManager] currentProfileNotEmpty]){
                
        [self.genderSegmentedControl setSelectedSegmentIndex:[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]];
        
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark selectors
-(void) saveProfileData
{
   
    
    if ([self.nameField.text isEqualToString:@""]){
        [self showAlertDialogWithTitle:@"" andMessage:@"Input your name first!"];
        return;
    }
    
    if (self.nameField.text.length > 50){
        [self showAlertDialogWithTitle:@"" andMessage:@"Use short name, please!"];
        self.nameField.text = @"";
        return;
    }


    if (self.surnameField.text.length > 50){
        [self showAlertDialogWithTitle:@"" andMessage:@"Use short surname, please!"];
        self.surnameField.text = @"";
        return;
    }
    
    NSString *currentName = [self.nameField.text stringByAppendingFormat:@"_%@", self.surnameField.text];
    if ([currentName isEqualToString:KEY_FOR_TEMP_PROFILE]){
        [self showAlertDialogWithTitle:@"" andMessage:@"Enter the name, please"];
        return;
    }
    
    if (![self checkAge]){
        return;
    }
  
    
    
    NSInteger retValue;
    NSMutableDictionary *dataDict;
    if ([[VSProfileManager sharedProfileManager] currentProfileNotEmpty]){
        dataDict = [[NSMutableDictionary alloc] initWithDictionary:[[VSProfileManager sharedProfileManager] currentProfile]];
    }
    else{
        dataDict = [[NSMutableDictionary alloc] init];
        
        
        //initializing sizes with -1(have not yet measured);
        NSArray *stuffArray = [measureManager getStuffForSizeDefiningForAllKindsOfPeople];
        for (NSString *key in stuffArray) {
            
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            //adding main size
            [resultsArray addObject:[NSNumber numberWithInteger: -1]];
            [dataDict setObject:resultsArray forKey:key];
            [resultsArray release];
        }

    }
    
    NSData* imageData = UIImagePNGRepresentation(self.profileImageView.image);
    
    [dataDict setObject:[self getSearchingKey] forKey:PROFILE_SEARCHING_KEY];
    [dataDict setObject:self.nameField.text forKey:PROFILE_NAME];
    if (userSelectedNewPhoto){
        [dataDict setObject:imageData forKey:PROFILE_PHOTO];
    }
    [dataDict setObject:self.surnameField.text forKey:PROFILE_SURNAME];
    [dataDict setObject:self.ageField.text forKey:PROFILE_AGE];
    [dataDict setObject:[NSNumber numberWithInteger: [self.genderSegmentedControl selectedSegmentIndex]] forKey:PROFILE_GENDER];
    if (userMakeCurrentProfileMain){
        [dataDict setObject:[NSNumber numberWithInteger:1] forKey:MAIN_USER_PROFILE];
    }
    else{
        [dataDict setObject:[NSNumber numberWithInteger:0] forKey:MAIN_USER_PROFILE];
    }
    
    if ([[VSProfileManager sharedProfileManager] currentProfileNotEmpty]){
        retValue = [[VSProfileManager sharedProfileManager] saveDataWithKey:[self getSearchingKey] oldKey:(NSString *)[[VSProfileManager sharedProfileManager] getCurrentProfileCharacteristic:PROFILE_SEARCHING_KEY] andDictionary:dataDict];
        
        if (retValue == PROFILE_SAVE_RESULT_OK){
            [[VSProfileManager sharedProfileManager] setCurrentProfile:dataDict];
        };
    }
    else{
        retValue = [[VSProfileManager sharedProfileManager] saveDataWithKey:[self getSearchingKey] oldKey:@"" andDictionary:dataDict];
        if (retValue == PROFILE_SAVE_RESULT_OK){
            [[VSProfileManager sharedProfileManager] setCurrentProfile:dataDict];
        };
    }
    [dataDict release];
    
    if (retValue == PROFILE_SAVE_RESULT_OK){
      
        
        // updating profiles list after updating current profile
        [[VSProfileManager sharedProfileManager] getProfilesList];
        
        if (self.saveButtonAction == saveButtonAction_saveAndStartMeasure){
        
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            UIView *startDialogView = [[appDelegate window] viewWithTag:START_DIALOG_TAG];
            
            if (!startDialogView){
                startDialogController = [[StartDialogViewController alloc] initWithNibName:@"StartDialogView" bundle:nil] ;
                startDialogController.delegate = self;
                startDialogController.startingFrom = startingFromOtherView;
                [[startDialogController view] setCenter:[[appDelegate window] center]];
                [[startDialogController view] setTag:START_DIALOG_TAG];
                [[appDelegate window] addSubview:[startDialogController view]];
                
                [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    [[startDialogController view] setAlpha:1.0f];
                    [[startDialogController view] setCenter:[[appDelegate window] center]];
                }
                                 completion:^(BOOL finished) {
                                     //
                                 }];
            }
        }
        else{
            //[self showAlertDialogWithTitle:@"" andMessage:@"Data saved"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (retValue == PROFILE_SAVE_RESULT_PROFILE_WITH_GIVEN_KEY_ALREADY_EXIST){
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"Profile with this name already exist!"];
    }
    else if (retValue == PROFILE_SAVE_RESULT_ERROR){
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"Unable to save data!"];
    }
    
   
    
}

	
#pragma mark actions

- (void) onMainProfileButtonTap:(id)sender
{
    if ([[VSProfileManager sharedProfileManager] currentProfileNotEmpty]){
        if ([[VSProfileManager sharedProfileManager] currentProfileIsMainUserProfile]){
            if (userMakeCurrentProfileMain){
                [[self mainProfileButton] setImage:[UIImage imageNamed:@"cb_unchecked.png"] forState:UIControlStateNormal];
            }
            else{
                [[self mainProfileButton] setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
            }
            userMakeCurrentProfileMain = !userMakeCurrentProfileMain;
        }
        else{
            if ([[VSProfileManager sharedProfileManager] mainUserProfileExist]){
                [self showAlertDialogWithTitle:@"" andMessage:@"Your profile already exist!"];
            }
            else{
                if (userMakeCurrentProfileMain){
                    [[self mainProfileButton] setImage:[UIImage imageNamed:@"cb_unchecked.png"] forState:UIControlStateNormal];
                }
                else{
                    [[self mainProfileButton] setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
                }
                userMakeCurrentProfileMain = !userMakeCurrentProfileMain;
            }
        }
    }
    else{
        if ([[VSProfileManager sharedProfileManager] mainUserProfileExist]){
            [self showAlertDialogWithTitle:@"" andMessage:@"Your profile already exist!"];
        }
        else{
            if (userMakeCurrentProfileMain){
                [[self mainProfileButton] setImage:[UIImage imageNamed:@"cb_unchecked.png"] forState:UIControlStateNormal];
            }
            else{
                [[self mainProfileButton] setImage:[UIImage imageNamed:@"cb_checked.png"] forState:UIControlStateNormal];
            }
            userMakeCurrentProfileMain = !userMakeCurrentProfileMain;
        }
    }
}

-(IBAction) selectProfileImage
{
    [self.nameField resignFirstResponder];
    [self.surnameField resignFirstResponder];
    [self.ageField resignFirstResponder];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *startSheet = [[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"Choose the action", nil)
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"Take a photo", nil),
                                     NSLocalizedString(@"Choose existing", nil), nil];
        
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
                                     otherButtonTitles:NSLocalizedString(@"Choose existing", nil), nil];
        
        [startSheet showInView:self.view];
        [startSheet release];
        
    }
   
}
- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)hideKeyboard:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.surnameField resignFirstResponder];
    [self.ageField resignFirstResponder];
}
- (IBAction) onAgeFieldValueChanged:(id)sender
{
    //[self checkAge];
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
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
    }
    else
    {
        
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                [self getPhotoFromSource:UIImagePickerControllerSourceTypeCamera];
            }
            else if (buttonIndex == 1){
                [self getPhotoFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        }
        else
        {
            if (buttonIndex == actionSheet.firstOtherButtonIndex){
                [self getPhotoFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
            }
                      
        }
    }
}

#pragma mark UIImagePickerController delegate methods
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
       
    UIImage *picture = [info objectForKey:UIImagePickerControllerEditedImage];
    CGSize newSize = CGSizeMake(picture.size.width/2, picture.size.height/2);
    UIImage *profileImage = [picture resizedImage:newSize interpolationQuality:kCGInterpolationHigh];

    self.profileImageView.image = profileImage;
    userSelectedNewPhoto = true;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
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



#pragma mark help funtions

- (void) createSexScrollViewScreenWithTitle:(NSString *) title andFrame:(CGRect) frame
 {
    
     UILabel *label = [[UILabel alloc] initWithFrame: frame];
     label.textColor = [UIColor blackColor];
     label.font = [UIFont systemFontOfSize:15.0f];
     label.backgroundColor = [UIColor whiteColor];
     label.numberOfLines = 0;
     label.lineBreakMode =  NSLineBreakByWordWrapping;
     label.textAlignment =NSTextAlignmentLeft;
     label.text = [@"  " stringByAppendingString: title];
     label.layer.cornerRadius = 7.0f;
     
     [self.sexScrollView addSubview:label];
     [label release];
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

- (void) getPhotoFromSource:(UIImagePickerControllerSourceType) sourceType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:NULL];
    [picker release];
    
}

//searching key has the following king: name_surname
- (NSString *) getSearchingKey
{
    return [[self.nameField.text stringByAppendingString:@"_"] stringByAppendingString:self.surnameField.text];
}

- (BOOL) checkAge
{
    /*
    if ([self.ageField.text integerValue] == 0){
        [self showAlertDialogWithTitle:@"" andMessage:@"AgeMessage1"];
    }
    else if ([self.ageField.text integerValue] > 0 && [self.ageField.text integerValue] < 13){
        [self showAlertDialogWithTitle:@"Sorry" andMessage:@"AgeMessage2"];
        return false;
    }
    else if ([self.ageField.text integerValue] > 150){
        [self showAlertDialogWithTitle:@"" andMessage:@"AgeMessage3"];
        self.ageField.text = @"100";
        return false;
    }
    */
    return true;
     
}

@end


