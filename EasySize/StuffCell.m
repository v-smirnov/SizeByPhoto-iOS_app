//
//  StuffCell.m
//  EasySize
//
//  Created by Vladimir Smirnov on 20.07.13.
//
//

#import "StuffCell.h"

@implementation StuffCell

@synthesize stuffImageView, stuffTextLabel, lockImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [stuffImageView release];
    [stuffTextLabel release];
    [lockImageView release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
