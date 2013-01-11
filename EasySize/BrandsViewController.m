//
//  BrandsViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import "BrandsViewController.h"
#import "BrandManager.h"
#import "BrandSizesViewController.h"

@interface BrandsViewController ()

@end

@implementation BrandsViewController
@synthesize brandsTable;

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
    [brandsTable release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.brandsTable = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Brands", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[BrandManager sharedBrandManager] getBrands] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        //cell = [nib objectAtIndex:0];
        
        //UIImage *indicatorImage = [UIImage imageNamed:@"arrow.png"];
        //cell.accessoryView = [[[UIImageView alloc] initWithImage:indicatorImage] autorelease];
        
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        //cell.textLabel.numberOfLines = 0;
        //cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        
        //инициализация фонов
        cell.backgroundView = [[UIImageView new] autorelease];
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        
        //cell.customImageView.frame = CGRectMake(15, 8, 66, 88);
    }
    
    cell.textLabel.text = [[[BrandManager sharedBrandManager] getBrands] objectAtIndex:indexPath.row];
    
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
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BrandSizesViewController *controller = [[BrandSizesViewController alloc] initWithNibName:@"BrandSizesView" bundle:nil];
    controller.currentBrand = [[[BrandManager sharedBrandManager] getBrands] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
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



@end
