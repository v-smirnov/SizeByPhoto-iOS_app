//
//  MeasureManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 10.10.12.
//
//

#import <Foundation/Foundation.h>
#import "Types.h"



@interface MeasureManager : NSObject
{
    
}

+(MeasureManager *)sharedMeasureManager;

- (NSArray *) getClothesListForPersonType:(PersonKind) personType; //+

- (NSArray *) getClothesListForAllGenders; //+

- (NSMutableDictionary *) getClothesMeasureParamsForPersonType:(PersonKind) personType;//+

- (NSArray *)getSizesTableForClothesType:(NSString *) clothesType andPersonType:(PersonKind) personType;

- (float) getMinSizeForClothesType:(NSString *) clothesType andPersonType:(PersonKind) personType;//+

- (float) getMaxSizeForClothesType:(NSString *) clothesType andPersonType:(PersonKind) personType;//+

//- (float) getStepSliderValueForKey:(NSString *) key andPersonType:(PersonType) personType;

- (NSInteger)findSizeForKeysAndValues:(NSDictionary *)keyAndValues andPersonType:(PersonKind)personType;

- (float) getSizeValueForKey:(NSString *) key PersonType:(PersonKind) personType andState:(NSInteger) state;

- (NSArray *) getGenderList;//+

- (NSArray *) getSizesListForClothesType:(NSString *) clothesType personType:(PersonKind) personType andIndex:(NSInteger) index;

- (float) getMeasureKoefForKey:(NSString *) key personType:(PersonKind) personType;//+

- (NSArray *)getClothesWithTheSameSizeForChoosenOne:(NSString *)clothesType andPersonType:(PersonKind)personType;

- (NSString *) getLegLengthDescriptionForValue:(float) value andPersonType:(PersonKind) personType;

- (NSArray *)getOrderedMeasureParams;

- (NSString *) getLetterForBrasSizeWithChest:(float) chest andUnderChest:(float) underChest;

- (BOOL) needToUpdateSizesForClothesWithTheSameParameters:(NSArray *) clothesArray forPersonType:(PersonKind)personType;

- (NSInteger) getCurrentProfileGender;

- (float) getCurrentProfileBodyParam:(NSString *) bodyParam;



@end
