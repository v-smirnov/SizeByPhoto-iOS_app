//
//  SizesViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 20.07.13.
//
//

#import <UIKit/UIKit.h>
#import "VSBrandsLinksManager.h"
#import "LocalyticsSession.h"


@interface SizesViewController : UIViewController
{
    NSDictionary *brandsSizes;
    NSArray *brands;
}

@property (nonatomic, retain) NSString *stuffToShowSizes;
@property (nonatomic, retain) IBOutlet UITableView *brandsSizesTable;


@end
