//
//  BrandSizesViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 10.01.13.
//
//

#import "BrandSizesViewController.h"
#import "SizesCell.h"
#import "DataManager.h"
#import "MeasureManager.h"
#import "BrandManager.h"

@interface BrandSizesViewController ()

@end

@implementation BrandSizesViewController

@synthesize brandSizesTable, currentBrand;

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
    [brandSizesTable release];
    [measuredClothesType release];
    [currentBrand release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.brandSizesTable = nil;
    self.currentBrand = nil;
    [measuredClothesType release]; measuredClothesType = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Sizes", nil);
    
    //finding out what kind of clothes have already measured
    measuredClothesType = [[NSMutableArray alloc] init];
    
    NSArray *stuffArray = [[MeasureManager sharedMeasureManager] getClothesListForPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
   
    for (NSString *clothesType in stuffArray) {
        
        if ([[[[[DataManager sharedDataManager] currentProfile] objectForKey:clothesType] objectAtIndex:0] integerValue] != -1){
            [measuredClothesType addObject:clothesType];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [measuredClothesType count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SizesCell *cell = (SizesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SizesCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    
        //инициализация фонов
        cell.backgroundView = [[UIImageView new] autorelease];
        cell.selectedBackgroundView = [[UIImageView new] autorelease];
        
    }
    
    NSString *clothesType = [measuredClothesType objectAtIndex:indexPath.row];
    cell.titleLabel.text = NSLocalizedString(clothesType, nil);
    //finding out sizes
    NSArray *bodyParams = [[BrandManager sharedBrandManager] getMeasureParamsForClothesType:clothesType andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
    
    NSMutableDictionary *bodyParamsWithValues = [[NSMutableDictionary alloc] initWithCapacity:[bodyParams count]];
    for (NSString *param in bodyParams) {
        [bodyParamsWithValues setObject:[NSNumber numberWithFloat:[[MeasureManager sharedMeasureManager] getCurrentProfileBodyParam:param]] forKey:param];
    }
    NSDictionary *sizes = [[BrandManager sharedBrandManager] getSizesForBrand:[self currentBrand] ClothesType:clothesType BodyParams:bodyParamsWithValues andPersonType:[[MeasureManager sharedMeasureManager] getCurrentProfileGender]];
    
    if ([sizes objectForKey:@"firstSize"]){
        cell.euSizeLabel.text = [sizes objectForKey:@"firstSize"];
        
        if ([sizes objectForKey:@"secondSize"]){
            cell.ruSizeLabel.text = [sizes objectForKey:@"secondSize"];
        }
        else{
            cell.ruSizeLabel.text = [sizes objectForKey:@"firstSize"];
        }
        
        if ([sizes objectForKey:@"thirdSize"]){
            cell.usSizeLabel.text = [sizes objectForKey:@"thirdSize"];
        }
        else{
            cell.usSizeLabel.text = [sizes objectForKey:@"firstSize"];
        }

        if ([sizes objectForKey:@"fourthSize"]){
            cell.ukSizeLabel.text = [sizes objectForKey:@"fourthSize"];
        }
        else{
            cell.ukSizeLabel.text = [sizes objectForKey:@"firstSize"];
        }
        
        if ([sizes objectForKey:@"fifthSize"]){
            cell.intSizeLabel.text = [sizes objectForKey:@"fifthSize"];
        }
        else{
            cell.intSizeLabel.text = [sizes objectForKey:@"firstSize"];
        }
    }
    
    if ([sizes objectForKey:@"additionalInfo"]){
        cell.infoLabel.text = [sizes objectForKey:@"additionalInfo"];
    }
    
    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"cell_background.png"];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
}


@end
