//
//  SizesCell.h
//  EasySize
//
//  Created by Vladimir Smirnov on 10.01.13.
//
//

#import <UIKit/UIKit.h>

@interface SizesCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *infoLabel;
    UILabel *euSizeLabel;
    UILabel *ruSizeLabel;
    UILabel *usSizeLabel;
    UILabel *ukSizeLabel;
    UILabel *intSizeLabel;
    
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *euSizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *ruSizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *usSizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *ukSizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *intSizeLabel;

@end
