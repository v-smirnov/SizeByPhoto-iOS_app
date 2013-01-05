//
//  DetailViewController.m
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewProfileViewController.h"
#import "HowToMeasureViewController.h"

@interface NewProfileViewController ()

@end

@implementation NewProfileViewController

@synthesize profileImageView, nameField, surnameField, ageField, delegate, saveButtonAction, sexScrollView, ageLabel, nameLabel, surnameLabel, sexLabel, genderSegmentedControl;




- (void)dealloc
{
    [nameField release];
    [surnameField release];
    [ageField release];
    [profileImageView release];
    [ageLabel release];
    [nameLabel release];
    [surnameLabel release];
    [sexLabel release];
    [sexScrollView release];
    [genderSegmentedControl release];
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
    self.ageLabel = nil;
    self.nameLabel = nil;
    self.surnameLabel = nil;
    self.sexLabel = nil;
    self.sexScrollView = nil;
    self.genderSegmentedControl = nil;
}


#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"Profile", nil);
    
    self.ageLabel.text = NSLocalizedString(@"Age:", nil);
    self.nameLabel.text = NSLocalizedString(@"Name:", nil);
    self.surnameLabel.text = NSLocalizedString(@"Surname:", nil);
    self.sexLabel.text = NSLocalizedString(@"Sex:", nil);
    
    self.nameField.placeholder = NSLocalizedString(@"name", nil);
    self.surnameField.placeholder = NSLocalizedString(@"surname", nil);
    self.ageField.placeholder = NSLocalizedString(@"age", nil);

    self.profileImageView.clipsToBounds =YES;
    self.profileImageView.layer.cornerRadius = 10.0f;
    
    if (self.saveButtonAction == 1){
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveProfileData)] ;
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];

    }
    else{
        /*
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveProfileData)] ;
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
         */
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveProfileData)] ;
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
    }
       
   
    
    if ([[DataManager sharedDataManager] currentProfile]){
        self.nameField.text = [[[DataManager sharedDataManager] currentProfile] objectForKey:@"name"];
        self.surnameField.text = [[[DataManager sharedDataManager] currentProfile] objectForKey:@"surname"];
        self.ageField.text = [[[DataManager sharedDataManager] currentProfile] objectForKey:@"age"];
        
        //getting photo
        NSData *imageData = [[[DataManager sharedDataManager] currentProfile] objectForKey:@"photo"];
        if (imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.profileImageView.image = image;
        }
    
    }
    
    NSArray *sexArray = [[MeasureManager sharedMeasureManager] getGenderList];
    
    /*
    self.sexScrollView.contentSize = CGSizeMake(self.sexScrollView.frame.size.width , self.sexScrollView.frame.size.height * [sexArray count]);
    self.sexScrollView.delegate = self;
    self.sexScrollView.pagingEnabled = YES;
    self.sexScrollView.showsVerticalScrollIndicator = NO;
    self.sexScrollView.layer.cornerRadius = 7.0f;
    */
    
    for (NSString *sex in sexArray) {
        //CGRect frame = CGRectMake(0, self.sexScrollView.frame.size.height*[sexArray indexOfObject:sex], self.sexScrollView.frame.size.width, self.sexScrollView.frame.size.height);
        
        //[self createSexScrollViewScreenWithTitle: NSLocalizedString(sex, nil) andFrame:frame];
        
        [self.genderSegmentedControl setTitle:NSLocalizedString(sex, nil) forSegmentAtIndex:[sexArray indexOfObject:sex]];
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[DataManager sharedDataManager] currentProfile]){
                
        //CGRect sexFrame = CGRectMake(0, self.sexScrollView.frame.size.height*[[[[DataManager sharedDataManager] currentProfile] objectForKey:@"sex"] integerValue], self.sexScrollView.frame.size.width, self.sexScrollView.frame.size.height);
        //[self.sexScrollView scrollRectToVisible:sexFrame animated:NO];
        
        [self.genderSegmentedControl setSelectedSegmentIndex:[[[[DataManager sharedDataManager] currentProfile] objectForKey:@"sex"] integerValue]];
        
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
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"Input your name first!"];
        return;
    }
    
    NSInteger retValue;
    NSMutableDictionary *dataDict;
    if ([[DataManager sharedDataManager] currentProfile]){
        dataDict = [[NSMutableDictionary alloc] initWithDictionary:[[DataManager sharedDataManager] currentProfile]];
    }
    else{
        dataDict = [[NSMutableDictionary alloc] init];
        
        
        //initializing sizes with -1(have not yet measured);
        NSArray *stuffArray = [[MeasureManager sharedMeasureManager] getClothesListForAllGenders];
        for (NSString *key in stuffArray) {
            
            NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
            //adding main size
            [resultsArray addObject:[NSNumber numberWithInteger: -1]];
            [dataDict setObject:resultsArray forKey:key];
            [resultsArray release];
        }

    }
    
    NSData* imageData = UIImageJPEGRepresentation(self.profileImageView.image, 1.0f);
    
    [dataDict setObject:[self getSearchingKey] forKey:@"searchingKey"];
    [dataDict setObject:self.nameField.text forKey:@"name"];
    [dataDict setObject:imageData forKey:@"photo"];
    [dataDict setObject:self.surnameField.text forKey:@"surname"];
    [dataDict setObject:self.ageField.text forKey:@"age"];
    //[dataDict setObject:[NSNumber numberWithInt:roundf(self.sexScrollView.contentOffset.y/self.sexScrollView.frame.size.height)] forKey:@"sex"];
    [dataDict setObject:[NSNumber numberWithInteger: [self.genderSegmentedControl selectedSegmentIndex]] forKey:@"sex"];
    
    
    if ([[DataManager sharedDataManager] currentProfile]){
        retValue = [[DataManager sharedDataManager] saveDataWithKey:[self getSearchingKey] oldKey:[[[DataManager sharedDataManager] currentProfile] objectForKey:@"searchingKey"] andDictionary:dataDict];
        
        if (retValue == 1){
            [[DataManager sharedDataManager] setCurrentProfile:dataDict];
        };
    }
    else{
        retValue = [[DataManager sharedDataManager] saveDataWithKey:[self getSearchingKey] oldKey:@"" andDictionary:dataDict];
        if (retValue == 1){
            [[DataManager sharedDataManager] setCurrentProfile:dataDict];
        };
    }
    [dataDict release];
    
    if (retValue == 1){
      
        
        // prepearing profiles
        [[DataManager sharedDataManager] getProfileList];
        
        if (self.saveButtonAction == 1){
        
            NSString *nibName = nil;
            if ([[UIScreen mainScreen] bounds].size.height == 568){
                nibName = @"HowToMeasure568";
            }
            else{
                nibName = @"HowToMeasure";
            }

            
            HowToMeasureViewController *howToMeasureController = [[HowToMeasureViewController alloc] initWithNibName:nibName bundle:nil] ;
            howToMeasureController.backButtonNum = 0;
            [self.navigationController pushViewController:howToMeasureController animated:YES];
            [howToMeasureController release];
        }
        else{
            [self showAlertDialogWithTitle:@"" andMessage:@"Data saved"];
            if ([[DataManager sharedDataManager] currentProfile]){
                [self.delegate newProfileViewControllerUpdateData:[[DataManager sharedDataManager] currentProfile]];
            };
        }
    }
    else if (retValue == 2){
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"Profile with this name already exist!"];
    }
    else if (retValue == 0){
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"Unable to save data!"];
    }
    
   
    
}

	
#pragma mark actions

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
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark help funtions

- (void) createSexScrollViewScreenWithTitle:(NSString *) title andFrame:(CGRect) frame
 {
    
     UILabel *label = [[UILabel alloc] initWithFrame: frame];
     label.textColor = [UIColor blackColor];
     label.font = [UIFont systemFontOfSize:15.0f];
     label.backgroundColor = [UIColor whiteColor];
     label.numberOfLines = 0;
     label.lineBreakMode = UILineBreakModeWordWrap;
     label.textAlignment =UITextAlignmentLeft;
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

- (NSString *) getSearchingKey
{
    return [[self.nameField.text stringByAppendingString:@"_"] stringByAppendingString:self.surnameField.text];
}

- (BOOL) checkAge
{
    if ([self.ageField.text integerValue] > 0 && [self.ageField.text integerValue] < 13){
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"Application doesn't define children sizes (under 13 years old)"];
    }
    
    if ([self.ageField.text integerValue] == 0){
        [self showAlertDialogWithTitle:@"Warning" andMessage:@"You didn't input age. You should know: application doesn't define children sizes (under 13 years old)"];
    }
    
    return true;
}

@end


