//
//  SizesViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 20.07.13.
//
//

#import "SizesViewController.h"
#import "StuffCell.h"
#import "Consts.h"
#import "BrandManager.h"
#import "VSProfileManager.h"
#import "FeedbackViewController.h"
#import "VSMeasureManager.h"

@interface SizesViewController ()

@end

@implementation SizesViewController

@synthesize stuffToShowSizes, brandsSizesTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(self.stuffToShowSizes, nil);
	
    BrandManager *brandManager = [[BrandManager alloc] initWithPersonKind:[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]];
    
    brands = [[NSArray alloc] initWithArray:[brandManager getBrands]];

    brandsSizes = [[NSDictionary alloc] initWithDictionary:[brandManager getSizesForAllBrandsForStuffType:self.stuffToShowSizes forCurrentProfile:[[VSProfileManager sharedProfileManager] currentProfile]]];
    
    [brandManager release];
    
    //getting common sizes
    VSMeasureManager *measureManager = [[VSMeasureManager alloc] initWithPersonKind:[[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind]];
    
    NSArray *bodyParams = [measureManager getMeasureParamsForStuffType:self.stuffToShowSizes];
    
    NSMutableDictionary *bodyParamsWithValues = [[NSMutableDictionary alloc] initWithCapacity:[bodyParams count]];
    for (NSString *param in bodyParams) {
        [bodyParamsWithValues setObject:[NSNumber numberWithFloat:[[VSProfileManager sharedProfileManager] getCurrentProfileValueForBodyParam:param]] forKey:param];
    }
    NSDictionary *sizes = [measureManager getSizesForStuffType:self.stuffToShowSizes andBodyParams:bodyParamsWithValues];
    
    [bodyParamsWithValues release];
    
    NSString *additionalInfo = @"";
    if ([sizes objectForKey:@"additionalInfo"]){
        additionalInfo = [sizes objectForKey:@"additionalInfo"];
    }
    
    NSArray *sizesArray = nil;
    if ([sizes objectForKey:@"Sizes"]){
        sizesArray = [sizes objectForKey:@"Sizes"];
    }
    
    [measureManager release];
    
    UIView *mainHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
    [mainHeaderView setBackgroundColor: [UIColor clearColor]];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    //headerView.contentMode = UIViewContentModeScaleAspectFit;
    headerView.image = [UIImage imageNamed:@"stuff_choosing_cell.png"];
    
    //flags view
    NSArray *flags = [NSArray arrayWithObjects:@"eu_flag.png", @"ru_flag.png", @"us_flag.png", @"uk_flag.png", @"wo_flag.png", nil];
    
    float xPoint = 30;
   
    for (NSString *flag in flags) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, 20, 25, 25)];
        imageView.image = [UIImage imageNamed:flag];
        [headerView addSubview:imageView];
        [imageView release];
        xPoint = xPoint + 60;
    }
    
    xPoint = 17;
    
    for (NSString *sizeString in sizesArray) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, 50, 50, 25)];
        label.textColor = MAIN_THEME_COLOR;
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
        [headerView addSubview:label];
        [label release];
        xPoint = xPoint + 60;
        
    }
    
    [mainHeaderView addSubview:headerView];
    [headerView release];
    
    UIImageView *addCountryIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 40, 40)];
    addCountryIV.image = [UIImage imageNamed:@"addCountry.png"];
    [mainHeaderView addSubview:addCountryIV];
    [addCountryIV release];
    
    UILabel *addCountryTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 100, self.view.frame.size.width-70, 40)];
    addCountryTitleLabel.textColor = MAIN_THEME_COLOR;
    addCountryTitleLabel.font = [UIFont fontWithName:UBUNTU_FONT size:15.0f];
    addCountryTitleLabel.backgroundColor = [UIColor clearColor];
    addCountryTitleLabel.numberOfLines = 0;
    addCountryTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addCountryTitleLabel.textAlignment =NSTextAlignmentLeft;
    addCountryTitleLabel.text = NSLocalizedString(@"Add your country", nil);
    [mainHeaderView addSubview:addCountryTitleLabel];
    [addCountryTitleLabel release];

    
    UIButton *addCountryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addCountryButton.frame = CGRectMake(0, 100 , self.view.frame.size.width, 40);
    //[addCountryButton setTitle:NSLocalizedString(@"Add your country", nil) forState:UIControlStateNormal];
    //[addCountryButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
   // [addCountryButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //[addCountryButton setBackgroundImage:[UIImage imageNamed:@"stuff_choosing_cell.png"] forState:UIControlStateNormal];
    //[addCountryButton setBackgroundImage:[UIImage imageNamed:@"stuff_choosing_cell_pressed.png"] forState:UIControlStateHighlighted];
    [addCountryButton addTarget:self action:@selector(onAddCountryButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [mainHeaderView addSubview:addCountryButton];

    UIImageView *addBrandIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, 40, 40)];
    addBrandIV.image = [UIImage imageNamed:@"addBrand.png"];
    [mainHeaderView addSubview:addBrandIV];
    [addBrandIV release];
    
    UILabel *addBrandTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 150, self.view.frame.size.width-70, 40)];
    addBrandTitleLabel.textColor = MAIN_THEME_COLOR;
    addBrandTitleLabel.font = [UIFont fontWithName:UBUNTU_FONT size:15.0f];
    addBrandTitleLabel.backgroundColor = [UIColor clearColor];
    addBrandTitleLabel.numberOfLines = 0;
    addBrandTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addBrandTitleLabel.textAlignment =NSTextAlignmentLeft;
    addBrandTitleLabel.text = NSLocalizedString(@"Add your favorite brand", nil);
    [mainHeaderView addSubview:addBrandTitleLabel];
    [addBrandTitleLabel release];
    
    
    UIButton *addBrandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addBrandButton.frame = CGRectMake(0, 150 , self.view.frame.size.width, 40);
    //[addBrandButton setTitle:NSLocalizedString(@"Add your favorite brand", nil) forState:UIControlStateNormal];
    //[addBrandButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    //[addBrandButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //[addBrandButton setBackgroundImage:[UIImage imageNamed:@"stuff_choosing_cell.png"] forState:UIControlStateNormal];
    //[addBrandButton setBackgroundImage:[UIImage imageNamed:@"stuff_choosing_cell_pressed.png"] forState:UIControlStateHighlighted];
    [addBrandButton addTarget:self action:@selector(onAddBrandButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [mainHeaderView addSubview:addBrandButton];


    [self.brandsSizesTable setTableHeaderView:mainHeaderView];
    
    [mainHeaderView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.stuffToShowSizes = nil;
    [brands release]; brands = nil;
    [brandsSizes release]; brandsSizes = nil;
    self.brandsSizesTable = nil;
}

- (void)dealloc
{
    [stuffToShowSizes release];
    [brands release];
    [brandsSizes release];
    [brandsSizesTable release];
    [super dealloc];
}

#pragma mark - help functions

- (NSString *) getUserCountry{
    
    NSArray *countriesCodes = [NSArray arrayWithObjects:@"RU", @"US", @"GB", @"DK", @"BR", @"FR", @"ES", @"IT", @"DE", nil];
    
    //NSArray *countries = [NSArray arrayWithObjects:[NSNumber numberWithInteger:Russia], [NSNumber numberWithInteger:USA], [NSNumber numberWithInteger:UK], [NSNumber numberWithInteger:Denmark], [NSNumber numberWithInteger:Brazil], [NSNumber numberWithInteger:France], [NSNumber numberWithInteger:Spain], [NSNumber numberWithInteger:Italy], [NSNumber numberWithInteger:Germany],nil];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    NSInteger indexOfCountry = [countriesCodes indexOfObject:countryCode];
    
    if (indexOfCountry == NSNotFound){
        return @"INT";
    }
    else{
        return countryCode;
    }
    
    
}


#pragma mark - actions

- (void) onAddBrandButtonTap:(id)sender
{
    [[LocalyticsSession shared] tagEvent:@"User taps add brand button"];
    
    FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
    controller.textForFeedbackLabel = NSLocalizedString(@"Add your favorite brand", nil);
    controller.form = result;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void) onAddCountryButtonTap:(id)sender
{
    [[LocalyticsSession shared] tagEvent:@"User taps add country button"];
    
    FeedbackViewController *controller = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
    controller.textForFeedbackLabel = NSLocalizedString(@"Add your country for future updates", nil);
    controller.form = result;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
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
    return [brands count];
    
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
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"stuff_choosing_cell.png"];
    ((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"stuff_choosing_cell_pressed.png"];
    
    
    cell.stuffTextLabel.font = [UIFont fontWithName:PROFILE_NAME_FONT size:18.0f];
    cell.stuffTextLabel.textColor = MAIN_THEME_COLOR;
    
    NSString *brandSize = [brandsSizes objectForKey:[brands objectAtIndex:indexPath.row]];
    
    if (([brandSize isEqualToString:NSLocalizedString(BRAND_DOES_NOT_HAVE_ITEM_TEXT, nil)]) || ([brandSize isEqualToString:NSLocalizedString(BRAND_DOES_NOT_HAVE_SIZE_TEXT, nil)])){
        cell.stuffTextLabel.font = [UIFont fontWithName:PROFILE_NAME_FONT size:10.0f];
        cell.stuffTextLabel.textColor = [UIColor darkGrayColor];
    }
        
    
    cell.stuffTextLabel.text = brandSize;
    
    cell.stuffImageView.image = [UIImage imageNamed:[brands objectAtIndex:indexPath.row]];
    
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
    
    PersonKind currentPersonKind = [[VSProfileManager sharedProfileManager] getCurrentProfilePersonKind];
    NSString *currentBrand = [brands objectAtIndex:indexPath.row];
    
    VSBrandsLinksManager *linksManager = [[VSBrandsLinksManager alloc] init];
    
    NSString *link = [linksManager getURLLinkForBrand:currentBrand stuffType:stuffToShowSizes country:[self getUserCountry] andPersonKind:currentPersonKind];
    
    if (link){
        NSURL *url = [[NSURL alloc] initWithString:link];
        [[UIApplication sharedApplication] openURL:url];
        [url release];
    }
    
    [linksManager release];
    
    [[LocalyticsSession shared] tagEvent:[NSString stringWithFormat:@"User goes to %@", currentBrand]];

}


@end
