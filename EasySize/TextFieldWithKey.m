//
//  TextFieldWithKey.m
//  EasySize
//
//  Created by Vladimir Smirnov on 15.09.12.
//
//

#import "TextFieldWithKey.h"

@implementation TextFieldWithKey

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
