//
//  LabeledSlider.m
//  EasySize
//
//  Created by Vladimir Smirnov on 29.08.12.
//
//

#import "LabeledSlider.h"

@implementation LabeledSlider

@synthesize nameLabel, valueLabel, viewThatOwnsScrollView, step, sliderKey;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)dealloc
{
    [nameLabel release];
    [valueLabel release];
    [sliderKey release];
    [super dealloc];
}

@end
