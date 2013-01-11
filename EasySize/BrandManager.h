//
//  BrandManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import <Foundation/Foundation.h>
#import "types.h"

@interface BrandManager : NSObject
{
    
}

+(BrandManager *)sharedBrandManager;

- (NSArray *) getBrands;
- (NSArray *) getMeasureParamsForClothesType:(NSString*) clothesType andPersonType:(PersonType)personType;
- (NSDictionary *) getSizesForBrand:(NSString *) brand ClothesType:(NSString*) clothesType BodyParams:(NSDictionary *) bodyParams andPersonType:(PersonType) personType;
@end
