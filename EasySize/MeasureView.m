//
//  MeasureView.m
//  EasySize
//
//  Created by Vladimir Smirnov on 29.08.12.
//
//

#import "MeasureView.h"

@implementation MeasureView

@synthesize slidersArray, viewKey, sizesScrollView, additionalInfoLabel;

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
    [slidersArray release];
    [viewKey release];
    [sizesScrollView release];
    [additionalInfoLabel release];
    [super dealloc];
}


@end
