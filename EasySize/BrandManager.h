//
//  BrandManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import <Foundation/Foundation.h>
#import "Types.h"
#import "Consts.h"

@interface BrandManager : NSObject
{
    PersonKind personKind;
}

@property (nonatomic, assign) PersonKind personKind;


-(id) init;
-(id) initWithPersonKind:(PersonKind) pKind;


//+(BrandManager *)sharedBrandManager;

- (NSArray *) getBrands;
- (NSArray *) getMeasureParamsForBrand:(NSString *)brand stuffType:(NSString *)stuff;
- (NSDictionary *) getSizesForBrand:(NSString *) brand stuffType:(NSString*) stuff andBodyParams:(NSDictionary *) bodyParams;
- (NSDictionary *) getSizesForAllBrandsForStuffType:(NSString *)stuff forCurrentProfile:(NSDictionary *)currentProfile;
@end
