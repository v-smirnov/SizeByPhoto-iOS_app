//
//  BrandManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import "BrandManager.h"
static BrandManager *manager = nil;

@implementation BrandManager

+(BrandManager *)sharedBrandManager {
    @synchronized(self) {
        if (!manager) {
            manager = [[BrandManager alloc] init];
        }
    }
    return manager;
}
/*
 - (id)init
 {
 self = [super init];
 if (self) {
 
 }
 return self;
 }
 */

- (id) retain
{
    return self;
}

- (oneway void) release
{
    // Does nothing here.
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}

#pragma mark - brand manager functions

- (NSArray *)getBrands
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Brands" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
}


@end
