//
//  SizesCell.m
//  EasySize
//
//  Created by Vladimir Smirnov on 10.01.13.
//
//

#import "SizesCell.h"

@implementation SizesCell

@synthesize titleLabel, infoLabel, euSizeLabel, ruSizeLabel, usSizeLabel, ukSizeLabel, intSizeLabel;

- (void)dealloc
{
    [titleLabel release];
    [infoLabel  release];
    [euSizeLabel release];
    [ruSizeLabel release];
    [usSizeLabel release];
    [ukSizeLabel release];
    [intSizeLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
