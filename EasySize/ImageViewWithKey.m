//
//  ImageViewWithKey.m
//  EasySize
//
//  Created by Vladimir Smirnov on 20.12.12.
//
//

#import "ImageViewWithKey.h"

@implementation ImageViewWithKey
@synthesize key, imageName;

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
    [imageName release];
    [super dealloc];
}


@end
