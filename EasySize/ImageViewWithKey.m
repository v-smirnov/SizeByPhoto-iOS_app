//
//  ImageViewWithKey.m
//  EasySize
//
//  Created by Vladimir Smirnov on 20.12.12.
//
//

#import "ImageViewWithKey.h"

@implementation ImageViewWithKey
@synthesize key;

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
    [key release];
    [super dealloc];
}


@end
