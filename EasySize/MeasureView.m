//
//  MeasureView.m
//  EasySize
//
//  Created by Vladimir Smirnov on 29.08.12.
//
//

#import "MeasureView.h"

@implementation MeasureView

@synthesize viewKey, additionalInfoLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (void)dealloc
{
    [viewKey release];
    [additionalInfoLabel release];
    [super dealloc];
}


@end
