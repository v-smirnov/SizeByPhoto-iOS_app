//
//  MasterViewController.m
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"



@interface MasterViewController () {
    
}
@end

@implementation MasterViewController

@synthesize deleteView, deleteButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Profiles", @"Profiles");
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.deleteView = nil;
    self.deleteButton = nil;
}


- (void)dealloc
{
    [deleteView release];
    [deleteButton release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    self.tableView.rowHeight = 104;
   
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableView.backgroundView.frame];
    bgImageView.image = [UIImage imageNamed:@"background.png"];
    [self.tableView setBackgroundView: bgImageView];
    //[self.tableView setBackgroundColor:[UIColor brownColor]];
    [bgImageView release];
    
   
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProfile)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(addNewProfile)] ;
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editing)] ;
    self.navigationItem.leftBarButtonItem = edit;
    [edit release];
    
    [self.deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    //[UIColor colorWithRed:0.58f green:0.33f blue:0.075f alpha:1.0f]
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0.65f green:0.34f blue:0.08f alpha:1.0f], UITextAttributeTextColor, nil]];

    
    // prepearing profiles
    [[DataManager sharedDataManager] getProfileList];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.deleteView.center = CGPointMake([appDelegate window].center.x, [appDelegate window].frame.size.height-self.deleteView.frame.size.height/2);
    [[appDelegate window] addSubview:self.deleteView];
    
  
   
    //preparing table header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headerView.backgroundColor = [UIColor clearColor];
    //info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.frame.size.width-35, 5 , 30, 30);
    [infoButton addTarget:self action:@selector(showTips:) forControlEvents:UIControlEventTouchDown];
    [headerView addSubview:infoButton];
    //feedback button
    UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fbButton.frame = CGRectMake(3, 5 , 100, 30);
    [fbButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [fbButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
    [fbButton setBackgroundImage:[UIImage imageNamed:@"grayBtnBackground.png"] forState:UIControlStateNormal];
    [fbButton setTitle:NSLocalizedString(@"Feedback", nil) forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(showFeedbackForm:) forControlEvents:UIControlEventTouchDown];
    [headerView addSubview:fbButton];

    self.tableView.tableHeaderView = headerView;
    [headerView release];
    
   }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark selectors
- (void)addNewProfile
{
       
    NewProfileViewController *newProfileController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileView" bundle:nil] ;
    [[DataManager sharedDataManager] setCurrentProfile:nil];
    newProfileController.saveButtonAction = 1; //save and go to howToMeasure  controller
    [self.navigationController pushViewController:newProfileController animated:YES];
    [newProfileController release];
    
    
}

- (void)editing {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = !self.navigationItem.rightBarButtonItem.enabled;
    
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
    NSInteger count;
    NSMutableArray *mKeys, *mIndexPathes;
    NSArray *keys, *indexPathes;
    
    mKeys = [[NSMutableArray alloc] init];
    mIndexPathes = [[NSMutableArray alloc] init];
    
    
    count = [[[DataManager sharedDataManager] profilesList] count];
    
    for (NSInteger i = 0; i <count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.selected){
            NSMutableDictionary *currentDict = [[[DataManager sharedDataManager] profilesList] objectAtIndex:indexPath.row];
            [mKeys addObject:[currentDict objectForKey:@"searchingKey"]];
            [mIndexPathes addObject:indexPath];
        }
    }
    
    keys = [NSArray arrayWithArray:mKeys];
   
    [[DataManager sharedDataManager] deleteProfilesWithKeys:keys];
    [[DataManager sharedDataManager] getProfileList];
    
    indexPathes = [NSArray arrayWithArray:mIndexPathes];
    [self.tableView deleteRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationFade];
    
    [mKeys release];
    [mIndexPathes release];
    
    [self editing];
}

#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[DataManager sharedDataManager] profilesList] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.selectedBackgroundView = [[UIImageView new] autorelease];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        //UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
        //cell.accessoryView = [[[UIImageView alloc] initWithImage:indicatorImage] autorelease];
        
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        //cell.textLabel.numberOfLines = 0;
        //cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        //инициализация фонов
        cell.backgroundView = [[UIImageView new] autorelease];
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        
        cell.customImageView.frame = CGRectMake(15, 8, 66, 88);

    }

    
    NSMutableDictionary *object = [[[DataManager sharedDataManager] profilesList] objectAtIndex:indexPath.row];
    // getting name
    
    NSString *name = [object objectForKey:@"name"];
    
    name = [name stringByAppendingString:@" "];
    
    name = [name stringByAppendingString:[object objectForKey:@"surname"]];
    
    //cell.customTextLabel.textColor = [UIColor brownColor];
    cell.customTextLabel.text = name;
    
    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"cell_background.png"];
    /*
    if (indexPath.row == 0){
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"cell_background.png"];
    }
    else{
        ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"cell_background.png"];
    }
     */
    ((UIImageView *)cell.selectedBackgroundView).backgroundColor = [UIColor clearColor];

    //getting photo
    NSData *imageData = [object objectForKey:@"photo"];
    if (imageData)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        cell.customImageView.image = image;
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
        
        NSMutableDictionary *currentDict = [[[DataManager sharedDataManager] profilesList] objectAtIndex:indexPath.row];
        
        [[DataManager sharedDataManager] deleteProfileWithKey:[currentDict objectForKey:@"searchingKey"]];
        [[DataManager sharedDataManager] getProfileList];
        
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
        [[DataManager sharedDataManager] setCurrentProfile:[[[DataManager sharedDataManager] profilesList] objectAtIndex:indexPath.row]];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ResultViewController *resultController = [[ResultViewController alloc] initWithNibName:@"ResultView" bundle:nil];
        resultController.bButtonType = rootButton;
        resultController.eButtonType = standartEditButton;
        resultController.resultArray = nil;
        [self.navigationController pushViewController:resultController animated:YES];
        [resultController release];
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

#pragma mark - newProfileViewController delegate methods
/*
- (void)newProfileViewControllerDidFinish:(NewProfileViewController *)controller
{    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)newProfileViewControllerUpdateData:(NSMutableDictionary *)dataDictionary
{
    //
}
*/
@end
