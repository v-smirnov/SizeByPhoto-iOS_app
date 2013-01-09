//
//  BrandsViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import <UIKit/UIKit.h>

@interface BrandsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *brandsTable;
}

@property (nonatomic, retain) IBOutlet UITableView *brandsTable;

@end
