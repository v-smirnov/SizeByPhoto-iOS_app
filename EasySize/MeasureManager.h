//
//  MeasureManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 10.10.12.
//
//

#import <Foundation/Foundation.h>


typedef enum
{
    Man = 0,
    Woman = 1,
    Kid = 2
    
} PersonType;

@interface MeasureManager : NSObject
{
    
}

+(MeasureManager *)sharedMeasureManager;

- (NSArray *) getClothesListForPersonType:(PersonType) personType;
- (NSMutableDictionary *) getClothesMeasureParamsForPersonType:(PersonType) personType;;
- (NSArray *)getSizesTableForClothesType:(NSString *) clothesType andPersonType:(PersonType) personType;
- (float) getMinSizeForClothesType:(NSString *) clothesType andPersonType:(PersonType) personType;
- (float) getMaxSizeForClothesType:(NSString *) clothesType andPersonType:(PersonType) personType;
//- (float) getStepSliderValueForKey:(NSString *) key andPersonType:(PersonType) personType;
- (NSInteger)findSizeForKeysAndValues:(NSDictionary *)keyAndValues andPersonType:(PersonType)personType;
- (float) getSizeValueForKey:(NSString *) key PersonType:(PersonType) personType andState:(NSInteger) state;
- (NSArray *) getGenderList;
- (NSArray *) getSizesListForClothesType:(NSString *) clothesType personType:(PersonType) personType andIndex:(NSInteger) index;
- (float) getMeasureKoefForKey:(NSString *) key personType:(PersonType) personType;
- (NSArray *)getClothesWithTheSameSizeForChoosenOne:(NSString *)clothesType andPersonType:(PersonType)personType;
- (NSString *) getLegLengthDescriptionForValue:(float) value andPersonType:(PersonType) personType;
- (NSArray *)getOrderedMeasureParams;
- (NSString *) getLetterForBrasSizeWithChest:(float) chest andUnderChest:(float) underChest;

@end
