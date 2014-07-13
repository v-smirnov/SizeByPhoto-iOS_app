//
//  VSMeasureManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 17.01.13.
//
//

#import <Foundation/Foundation.h>
#import "Types.h"
#import "Consts.h"

@interface VSMeasureManager : NSObject
{
    PersonKind personKind;
}

@property (nonatomic, assign) PersonKind personKind;


-(id) init;
-(id) initWithPersonKind:(PersonKind) pKind;


- (NSArray *) getStuffForSizeDefining;

- (NSSet *) getLockedBeforeSharingStuff;

- (NSArray *) getStuffForSizeDefiningForAllKindsOfPeople;

- (NSArray *) getMeasureParamsForStuffType:(NSString *) stuffType;

- (NSArray *) getOrderedMeasureParams;

- (float) getMeasureCoefficientForBodyParam:(NSString *) param; //for one-photo mode

- (NSDictionary *) getSizesForStuffType:(NSString*) stuffType andBodyParams:(NSDictionary *) bodyParams;

- (NSArray *) getPersonKindsList;
- (NSArray *) getPersonKindsImagesList;

- (NSArray *)getStuffWithTheSameMeasureParamsAsGiven:(NSString *)stuff;

- (NSArray *)getAllStuffWithTheSameMeasureParams:(NSArray *) currentStuff;
@end
