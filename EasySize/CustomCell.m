//
//  CustomCellCell.m
//  iBoobs
//
//  Created by User on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize customImageView, customTextLabel, favoriteImageView;


- (void)dealloc
{
    [customImageView release];
    [customTextLabel release];
    [favoriteImageView release];
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
