//
//  CustomCellCell.h
//  iBoobser
//
//  Created by User on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell{
    UILabel *customTextLabel;
    UIImageView *customImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *customTextLabel;
@property (nonatomic, retain) IBOutlet UIImageView *customImageView;

@end
