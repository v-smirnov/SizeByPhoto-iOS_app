//
//  MasterViewController.m
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "Consts.h"
#import "Types.h"
#import "MeasureViewController.h"

#define START_DIALOG_TAG 100

@interface MasterViewController () {
    
}
@end

@implementation MasterViewController

@synthesize deleteView, deleteButton, cameraButton, startDialogController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.deleteView = nil;
    self.deleteButton = nil;
    [selectedCells release]; selectedCells = nil;
    self.cameraButton = nil;
    [startDialogController release]; startDialogController = nil;
    [measureManager release]; measureManager = nil;
}


- (void)dealloc
{
    [deleteView release];
    [deleteButton release];
    [selectedCells release];
    [cameraButton release];
    [startDialogController release];
    [measureManager release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // prepearing profiles
    [[VSProfileManager sharedProfileManager] getProfilesList];

    if ([[[VSProfileManager sharedProfileManager] profilesList] count] > 1){
        [[LocalyticsSession shared] tagEvent:@"There are more than one profile in the app"];
    }
    
    if ([[VSProfileManager sharedProfileManager] mainUserProfileExist]){
        [[LocalyticsSession shared] tagEvent:@"Main profile exists"];
    }

    //use for store celected cell to have a possibility delete a lot profiles correctly 
    selectedCells = [[NSMutableDictionary alloc] init];
    
    self.tableView.rowHeight = 104;
   
    /*
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.backgroundView.frame];
    bgImageView.image = [UIImage imageNamed:@"background.png"];
    [self.tableView setBackgroundView: bgImageView];
    [bgImageView release];
    */
    
   
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:[self createCustomButtonForNavBarWithTitle:NSLocalizedString(@"Add", nil) selector:@selector(addNewProfile) andStyle:usual]];

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(addNewProfile)] ;
    //self.navigationItem.rightBarButtonItem = addButton;
    //[addButton release];
    
    
    [self.deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
    [self.deleteButton.titleLabel setFont:[UIFont fontWithName:BUTTON_FONT size:BUTTON_FONT_SIZE]];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed.png"] forState:UIControlStateHighlighted];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.deleteView.center = CGPointMake([appDelegate window].center.x, [appDelegate window].frame.size.height-self.deleteView.frame.size.height/2);
    [[appDelegate window] addSubview:self.deleteView];
    
    self.cameraButton.center = [[appDelegate window] center];
    [[appDelegate window] addSubview:self.cameraButton];
    
    
    [[appDelegate backgroundView] setImage:[UIImage imageNamed:@"background.png"]];
    
    [self setTableHeaderView];
    
    measureManager = [[VSMeasureManager alloc] init];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self makeCameraButtonHidden:NO];
    [self changeViewElementsDependingOnProfilesCount];
    [self setTableHeaderView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self makeCameraButtonHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark selectors

- (void)editing {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = !self.navigationItem.rightBarButtonItem.enabled;
    self.cameraButton.hidden = !self.cameraButton.hidden;
    
    if (self.tableView.editing){
        
        self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"Done", nil);
    
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.deleteView.alpha = 0.9f;
        }
        completion:^(BOOL finished) {
            //
        }];
            }
    else{
        
        self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"Edit", nil);
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.deleteView.alpha = 0.0f;
        }
        completion:^(BOOL finished) {
            //
        }];
        
    }
    
}
#pragma mark - actions

- (void) onAddProfileButtonTap:(id) sender
{
    
    [[LocalyticsSession shared] tagEvent:@"Add profile button tap"];
    
    [self showStartDialog];
    
    /*
    NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
    [[VSProfileManager sharedProfileManager] setCurrentProfile:nil];
    newProfileController.saveButtonAction = saveButtonAction_saveAndStartMeasure; //save and go to measure  controller
    newProfileController.createdMainProfile = true;
    [self.navigationController pushViewController:newProfileController animated:YES];
    [newProfileController release];
     */
}

- (void) onFavoriteButtonTap:(id) sender
{
    //NSLog(@"%d", [sender tag]);
    NSInteger index = [sender tag];
    
    UIImageView *favoriteImageView = (UIImageView *)[sender superview];
    NSMutableDictionary *profile = [[VSProfileManager sharedProfileManager] getProfileAtIndex:index];
    
    if ([[VSProfileManager sharedProfileManager] profileAtIndexIsFavorite:index]){
        if (favoriteImageView){
            favoriteImageView.image = [UIImage imageNamed:@"favorite_nonactive.png"];
        }
        [profile setObject:[NSNumber numberWithInt:0] forKey:PROFILE_IS_FAVORITE];
        [[VSProfileManager sharedProfileManager] saveDataWithKey:[profile objectForKey:PROFILE_SEARCHING_KEY] oldKey:[profile objectForKey:PROFILE_SEARCHING_KEY] andDictionary:profile];
        [[VSProfileManager sharedProfileManager] getProfilesList];
    }
    else{
        if (favoriteImageView){
            favoriteImageView.image = [UIImage imageNamed:@"favorite_active.png"];
        }
        [profile setObject:[NSNumber numberWithInt:1] forKey:PROFILE_IS_FAVORITE];
        [[VSProfileManager sharedProfileManager] saveDataWithKey:[profile objectForKey:PROFILE_SEARCHING_KEY] oldKey:[profile objectForKey:PROFILE_SEARCHING_KEY] andDictionary:profile];
        [[VSProfileManager sharedProfileManager] getProfilesList];

    }
}

- (void) showTips:sender
{
    TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsView" bundle:nil];
    controller.numberOfPageToShow = 0;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

}
-(void) showFeedbackForm:sender
{
    FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
    controller.textForFeedbackLabel = @"Your feedback";
    controller.form = general;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(IBAction)deleteSelectedCells
{
  
    if ([selectedCells count] == 0){
        return;
    }
    
    NSMutableArray *mKeys = [[NSMutableArray alloc] init];
    NSMutableArray *mIndexPathes = [[NSMutableArray alloc] init];
    
    for (NSString *key in selectedCells) {
        NSInteger selectedCellNum = [[selectedCells objectForKey:key] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedCellNum inSection:0];
        
        //recieve profile for selected cell
        NSMutableDictionary *currentDict = [[[VSProfileManager sharedProfileManager] profilesList] objectAtIndex:selectedCellNum];
        //recieve profile key from profiles dictionary and add it to keys array for future deleting
        [mKeys addObject:[currentDict objectForKey:PROFILE_SEARCHING_KEY]];
        
        [mIndexPathes addObject:indexPath];

    }
    //clean selected cells dictionary
    [selectedCells removeAllObjects];
    
    NSArray *keys = [NSArray arrayWithArray:mKeys];
    
    [[VSProfileManager sharedProfileManager] deleteProfilesWithKeys:keys];
    [[VSProfileManager sharedProfileManager] getProfilesList];
    
    NSArray *indexPathes = [NSArray arrayWithArray:mIndexPathes];
    [self.tableView deleteRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView reloadData];
    
    [mKeys release];
    [mIndexPathes release];
    
    [self editing];
    [self changeViewElementsDependingOnProfilesCount];
    [self setTableHeaderView];

}

-(IBAction)onCameraButtonTap
{
    /*
    TutorialViewController *controller = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
    //controller.delegate = self;
    controller.bodyPartForAnimation = WAIST;
    controller.personKind = Woman;
    controller.pictureMode = main;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:NULL];
    [controller release];
    */
    
    
    [[LocalyticsSession shared] tagEvent:@"Camera button tap"];
    
    [self showStartDialog];

}

#pragma mark - Table View
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 134.0f;
    }
    else{
        return 104.0f;
    }
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[VSProfileManager sharedProfileManager] profilesList] count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        //инициализация фонов
        cell.backgroundView = [[UIImageView new] autorelease];
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.customImageView.frame = CGRectMake(0, 0, 66, 88);
        cell.customImageView.center = CGPointMake(58, cell.frame.size.height/2);
        //cell.favoriteImageView.frame = CGRectMake(0, 0, 30, 30);
        //cell.favoriteImageView.center = CGPointMake(280, cell.frame.size.height/2);
        
    }

    
    NSMutableDictionary *object = [[VSProfileManager sharedProfileManager] getProfileAtIndex:indexPath.row];
    // getting name
    
    NSString *name = [object objectForKey:PROFILE_NAME];
    
    name = [name stringByAppendingString:@" "];
    
    name = [name stringByAppendingString:[object objectForKey:PROFILE_SURNAME]];
    
    cell.customTextLabel.font = [UIFont fontWithName:PROFILE_NAME_FONT size:PROFILE_NAME_FONT_SIZE];
    cell.customTextLabel.textColor = MAIN_THEME_COLOR;
    cell.customTextLabel.text = name;
    
    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"profile_cell.png"];
      //((UIImageView *)cell.selectedBackgroundView).backgroundColor = [UIColor clearColor];
    ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"profile_cell_pressed.png"];
    //((UIImageView *)cell.editingAccessoryView).image = [UIImage imageNamed:@"gender_image_0.png"];

    //getting photo
    NSData *imageData = [object objectForKey:PROFILE_PHOTO];
    if (imageData)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        cell.customImageView.image = image;
    }
    else{
        cell.customImageView.image = [UIImage imageNamed:@"No_photo.png"];
    }
    if ([[VSProfileManager sharedProfileManager] profileAtIndexIsFavorite:indexPath.row]){
        cell.favoriteImageView.image = [UIImage imageNamed:@"favorite_active.png"];
    }
    else{
        cell.favoriteImageView.image = [UIImage imageNamed:@"favorite_nonactive.png"];
    }
    
    if ([[VSProfileManager sharedProfileManager] mainUserProfileExist]){
        if (indexPath.row == 0){
            cell.favoriteImageView.image = [UIImage imageNamed:@"main_profile_icon.png"];
        }
        else{
            UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [favoriteButton setTag:indexPath.row];
            [favoriteButton setFrame:CGRectMake(0, 0, 30, 30)];
            [favoriteButton addTarget:self action:@selector(onFavoriteButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [cell.favoriteImageView addSubview:favoriteButton];
        }
    }
    else{
        UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [favoriteButton setTag:indexPath.row];
        [favoriteButton setFrame:CGRectMake(0, 0, 30, 30)];
        [favoriteButton addTarget:self action:@selector(onFavoriteButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.favoriteImageView addSubview:favoriteButton];
    }

    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableDictionary *currentDict = [[[VSProfileManager sharedProfileManager] profilesList] objectAtIndex:indexPath.row];
        
        [[VSProfileManager sharedProfileManager] deleteProfileWithKey:[currentDict objectForKey:PROFILE_SEARCHING_KEY]];
        [[VSProfileManager sharedProfileManager] getProfilesList];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!tableView.isEditing){
        
        [[LocalyticsSession shared] tagEvent:@"Profile was watched"];
        
        [[VSProfileManager sharedProfileManager] setCurrentProfile:[[[VSProfileManager sharedProfileManager] profilesList] objectAtIndex:indexPath.row]];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
        resultController.backButton = rootButton;
        resultController.editButton = standartEditButton;
        resultController.measuredStuff = nil;
        [self.navigationController pushViewController:resultController animated:YES];
        [resultController release];
    }
    else{
        //remember index of selected cell
        [selectedCells setObject:[NSNumber numberWithInteger:indexPath.row] forKey:[self getKeyForCellInRow:indexPath.row]];
        //NSLog(@"%d", indexPath.row);
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (tableView.isEditing){
       if ([selectedCells objectForKey:[self getKeyForCellInRow:indexPath.row]]){
           //remove index of deselected cell
           [selectedCells removeObjectForKey:[self getKeyForCellInRow:indexPath.row]];
       }
   }
}
/*
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *object = [appDelegate.profileList objectAtIndex:indexPath.row];
    
    NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
    [self.navigationController pushViewController:newProfileController animated:YES];
    [newProfileController release];

  
   
}
*/
#pragma mark - StartDialogViewControllerDelegate
-(void) startMeasureUsingPhotoSource:(UIImagePickerControllerSourceType) sourceType andSelectedPersonKind:(PersonKind) personKind
{
    if (![self getTempProfileForPersonKind:personKind]){
        return;
    }
    
    self.navigationController.navigationBar.hidden = false;
    
    NSString *measureViewNib = nil;
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        measureViewNib = @"MeasureView568";
    }
    else{
        measureViewNib = @"MeasureView";
    }
    
    //NSMutableArray *stuffToFindOutSize = [[NSMutableArray alloc] initWithArray:[measureManager getStuffForSizeDefining]];
    
    MeasureViewController *measureController = [[MeasureViewController alloc] initWithNibName:measureViewNib bundle:nil];
    //measureController.whatToMeasureArray = stuffToFindOutSize;
    measureController.makeMeasurementsUsingTwoPhotos = YES;
    measureController.source = sourceType;
    [self.navigationController pushViewController:measureController animated:YES];
    [measureController release];
    //[stuffToFindOutSize release];
    
}


#pragma mark - help functions
- (void) showStartDialog
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *startDialogView = [[appDelegate window] viewWithTag:START_DIALOG_TAG];
    
    if (!startDialogView){
        startDialogController = [[StartDialogViewController alloc] initWithNibName:@"StartDialogView" bundle:nil] ;
        startDialogController.delegate = self;
        startDialogController.startingFrom = startingFromMainView;
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

- (void) setTableHeaderView
{
    if ((![[VSProfileManager sharedProfileManager] mainUserProfileExist]) && (![[VSProfileManager sharedProfileManager] profilesListIsEmpty])){
        //preparing table header view
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 55)];
        headerView.backgroundColor = [UIColor clearColor];
        //info button
        UIButton *addYourProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addYourProfileButton.frame = CGRectMake(0, 5 , self.view.frame.size.width, 55);
        //[addYourProfileButton titleLabel]
        [addYourProfileButton setTitle:NSLocalizedString(@"Add profile", nil) forState:UIControlStateNormal];
        [[addYourProfileButton titleLabel] setFont:[UIFont fontWithName:UBUNTU_FONT size:18.0f]];
        [addYourProfileButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
        //[addYourProfileButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
       
        [addYourProfileButton setBackgroundImage:[UIImage imageNamed:@"profile_cell.png"] forState:UIControlStateNormal];
        [addYourProfileButton setBackgroundImage:[UIImage imageNamed:@"profile_cell_pressed.png"] forState:UIControlStateHighlighted];
        [addYourProfileButton addTarget:self action:@selector(onAddProfileButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:addYourProfileButton];
        
        /*
        UIImageView *add_symbol = [[UIImageView alloc] initWithFrame:CGRectMake(30, 25, 30, 30)];
        [add_symbol setImage:[UIImage imageNamed:@"add_btn.png"]];
        [headerView addSubview:add_symbol];
        [add_symbol release];
         */
        
        [self.tableView setTableHeaderView: headerView];
        [headerView release];
    }
    else{
        [self.tableView setTableHeaderView: nil];
    }

}

- (NSString *) getKeyForCellInRow:(NSInteger) row
{
    //return just row as a string
    return [NSString stringWithFormat:@"%ld", (long)row];
}

-(UIButton *) createCustomButtonForNavBarWithTitle:(NSString *) title selector:(SEL) selector andStyle:(barButtonStyle) btnStyle
{
    UIButton *customButton= [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnWidth = MAX(60.0f,[title sizeWithFont:[UIFont fontWithName:@"EuphemiaUCAS" size:15.0f]].width);
    [customButton setFrame:CGRectMake(0.0f, 0.0f,  btnWidth+20, 30.0f)];
    [customButton setTitle: title forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[customButton titleLabel] setFont:[UIFont fontWithName:@"EuphemiaUCAS" size:15.0f]];
    [customButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if (btnStyle == usual){
        [customButton setBackgroundImage:[UIImage imageNamed:@"barBtn.png" ] forState:UIControlStateNormal];
        [customButton setBackgroundImage:[UIImage imageNamed:@"barBtnPressed.png" ] forState:UIControlStateHighlighted];
    }
    else{
        [customButton setBackgroundImage:[UIImage imageNamed:@"backBarBtn.png" ] forState:UIControlStateNormal];
        [customButton setBackgroundImage:[UIImage imageNamed:@"backBarBtnPressed.png" ] forState:UIControlStateHighlighted];
    }
    return customButton;
}

-(void) makeCameraButtonHidden:(BOOL) hidden
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (hidden){
            [[self cameraButton] setAlpha:0.0f];
        }
        else{
            [[self cameraButton] setAlpha:0.9f];
        }
    }
                     completion:^(BOOL finished) {
                         [[self cameraButton] setHidden:hidden];
                     }];
}

-(BOOL) getTempProfileForPersonKind:(PersonKind) personKind
{
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        
    //initializing sizes with -1(have not yet measured);
    NSArray *stuffArray = [measureManager getStuffForSizeDefiningForAllKindsOfPeople];
    for (NSString *key in stuffArray) {
        
        NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
        //adding main size
        [resultsArray addObject:[NSNumber numberWithInteger: -1]];
        [dataDict setObject:resultsArray forKey:key];
        [resultsArray release];
    }

    //NSData* imageData = UIImagePNGRepresentation([UIImage imageNamed:@"No_photo.png"]);
    
    [dataDict setObject:KEY_FOR_TEMP_PROFILE forKey:PROFILE_SEARCHING_KEY];
    [dataDict setObject:@"Name" forKey:PROFILE_NAME];
    //[dataDict setObject:imageData forKey:PROFILE_PHOTO];
    [dataDict setObject:@"Surname" forKey:PROFILE_SURNAME];
    [dataDict setObject:@"" forKey:PROFILE_AGE];
    [dataDict setObject:[NSNumber numberWithInteger: personKind] forKey:PROFILE_GENDER];
    [dataDict setObject:[NSNumber numberWithInteger: 0] forKey:MAIN_USER_PROFILE];
    
    return [[VSProfileManager sharedProfileManager] setTempProfileAsCurrent:dataDict];
    
}

- (void) changeViewElementsDependingOnProfilesCount
{
    // if we have one or more profiles show additional control elements
    if (![[VSProfileManager sharedProfileManager] profilesListIsEmpty]){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editing)] ;
        
        self.navigationItem.leftBarButtonItem = editButton;
        [editButton release];
        
        self.title = NSLocalizedString(@"Profiles", nil);
        self.navigationController.navigationBar.hidden = false;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //UIImageView *bgView = (UIImageView *) [[self tableView] backgroundView];
        //[bgView setImage:[UIImage imageNamed:@"background.png"]];
        [[appDelegate backgroundView] setImage:[UIImage imageNamed:@"background.png"]];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[self cameraButton] setCenter: CGPointMake([[appDelegate window] center].x, [[appDelegate window] frame].size.height-self.cameraButton.frame.size.height/2-10)];
        }
                 completion:^(BOOL finished) {
                     
                 }];

        
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
        self.title = NSLocalizedString(@"", nil);
        self.navigationController.navigationBar.hidden = true;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //UIImageView *bgView = (UIImageView *) [[self tableView] backgroundView];
        //[bgView setImage:[UIImage imageNamed:@"background_v.png"]];
        [[appDelegate backgroundView] setImage:[UIImage imageNamed:@"start_background.png"]];
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //[[self cameraButton] setCenter:[[appDelegate window] center]];
            [[self cameraButton] setCenter: CGPointMake([[appDelegate window] center].x, [[appDelegate window] frame].size.height-self.cameraButton.frame.size.height/2-10)];
        }
                     completion:^(BOOL finished) {
                         
                     }];
    
        
    
    }

}


@end
