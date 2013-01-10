//
//  BrandSizesViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 10.01.13.
//
//

#import <UIKit/UIKit.h>

@interface BrandSizesViewController : UIViewController<UITableViewDelegate>
{
    UITableView *brandSizesTable;
    NSMutableArray *measuredClothesType; //clothes, that have already measured;
}

@property (nonatomic, retain) IBOutlet UITableView *brandSizesTable;
@end
