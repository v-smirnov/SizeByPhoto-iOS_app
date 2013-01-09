//
//  BrandManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import <Foundation/Foundation.h>

@interface BrandManager : NSObject
{
    
}

+(BrandManager *)sharedBrandManager;

- (NSArray *) getBrands;

@end
