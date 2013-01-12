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

- (NSDictionary *)getSizesForBrand:(NSString *)brand andPersonType:(PersonType)personType
{
    NSString *fileName = [@"BrandsSizes_" stringByAppendingFormat:@"%d", personType];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    return [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:brand];
}

-(NSArray *)getMeasureParamsForBrand:(NSString *)brand clothesType:(NSString *)clothesType andPersonType:(PersonType)personType
{
    
    NSDictionary *clothesDictionary;
    
    if ([brand isEqualToString:@"American Apparel"]){
        if (personType == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Foot", nil], @"Shoes",
                                 nil];
        }
        else if (personType == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Chest", @"Under chest", nil], @"Bras",
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Skirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Dress",
                                 [NSArray arrayWithObjects:@"Foot", nil], @"Shoes",
                                 nil];
            
        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
    }
    else if ([brand isEqualToString:@"TopShop (TopMan)"]){
        if (personType == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Foot", nil], @"Shoes",
                                 nil];
        }
        else if (personType == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Waist", @"Hips", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Hips", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Chest", @"Under chest", nil], @"Bras",
                                 [NSArray arrayWithObjects:@"Waist", @"Hips", nil], @"Skirt",
                                 [NSArray arrayWithObjects:@"Waist", @"Hips", nil], @"Dress",
                                 [NSArray arrayWithObjects:@"Foot", nil],@"Shoes",
                                 nil];
            
        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }

    }
    else if ([brand isEqualToString:@"ASOS"]){
        if (personType == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Waist", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Foot", nil], @"Shoes",
                                 nil];
        }
        else if (personType == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Waist", @"Hips", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Hips", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Chest", @"Under chest", nil], @"Bras",
                                 [NSArray arrayWithObjects:@"Waist", @"Hips", nil], @"Skirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", @"Hips", nil], @"Dress",
                                 [NSArray arrayWithObjects:@"Foot", nil],@"Shoes",
                                 nil];
            
        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
        
    }
    else{
        if (personType == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                
                                [NSArray arrayWithObjects:@"Chest", nil], @"T-shirt",
                                [NSArray arrayWithObjects:@"Chest", nil], @"Shirt",
                                [NSArray arrayWithObjects:@"Chest", nil], @"Coats & jackets",
                                [NSArray arrayWithObjects:@"Waist", nil], @"Jeans",//+@"Inside leg"
                                [NSArray arrayWithObjects:@"Waist", nil], @"Underwear",
                                [NSArray arrayWithObjects:@"Foot", nil], @"Shoes",
                                nil];
        }
        else if (personType == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"T-shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Shirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", nil], @"Coats & jackets",
                                 [NSArray arrayWithObjects:@"Hips", nil], @"Jeans",//+@"Inside leg"
                                 [NSArray arrayWithObjects:@"Hips", nil], @"Underwear",
                                 [NSArray arrayWithObjects:@"Chest", @"Under chest", nil], @"Bras",
                                 [NSArray arrayWithObjects:@"Hips", nil], @"Skirt",
                                 [NSArray arrayWithObjects:@"Chest", @"Waist", @"Hips", nil], @"Dress",
                                 [NSArray arrayWithObjects:@"Foot", nil],@"Shoes",
                                 nil];

        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
    }
    
    return [clothesDictionary objectForKey:clothesType];
}

- (NSDictionary *)getSizesForBrand:(NSString *)brand ClothesType:(NSString *)clothesType BodyParams:(NSDictionary *) bodyParams andPersonType:(PersonType)personType
{
    NSDictionary *brandClothesTypeSizes = [[self getSizesForBrand:brand andPersonType:personType] objectForKey:clothesType];
    if (!brandClothesTypeSizes){
        return [NSDictionary dictionaryWithObjectsAndKeys:@"?", @"firstSize", nil];
    }
    else{
        

        NSInteger maxSizeIndex = 0;
        NSString *additionalInfo = nil;
        
        //looking for a size for each param and finding out what of them has maximum value 
        for (NSString *key in bodyParams) {
            float paramValue = [[bodyParams objectForKey:key] floatValue];
            //getting sizes array
            NSArray *sizes = [brandClothesTypeSizes objectForKey:@"Sizes"];
            if (!sizes){
                return [NSDictionary dictionaryWithObjectsAndKeys:@"?", @"firstSize", nil];
            }
            else{
                for (NSDictionary *item in sizes) {
                    NSArray *range = [item objectForKey:key];
                    // if current param not using for defining size, then the range array is nil and we can continue
                    //example - Inside leg for pants
                    if (!range){
                        continue;
                    }
                    // if param in range and maxSizeIndex < previous maxSizeIndex, setting new maxSizeIndex
                    if (paramValue >= [[range objectAtIndex:0] floatValue] && paramValue < [[range objectAtIndex:1] floatValue]){
                        if (maxSizeIndex < [sizes indexOfObject:item]){
                            maxSizeIndex = [sizes indexOfObject:item];
                            break;
                        }
                    }
                }
            }
           
        }
    
        // for bras finding out letter and writing it to additionalInfo
        if ([clothesType isEqualToString:@"Bras"]){
            float difference = [[bodyParams objectForKey:@"Chest"] floatValue] - [[bodyParams objectForKey:@"Under chest"] floatValue];
            NSArray *difference_info = [brandClothesTypeSizes objectForKey:@"Difference"];
            for (NSDictionary *item in difference_info) {
                NSArray *range = [item objectForKey:@"Diff"];
                if (difference >= [[range objectAtIndex:0] floatValue] && difference < [[range objectAtIndex:1] floatValue]){
                        additionalInfo = [item objectForKey:@"letter"];
                        break;
                }
            }

        }
        
        
        NSArray *sizes = [brandClothesTypeSizes objectForKey:@"Sizes"];
        NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary:[sizes objectAtIndex:maxSizeIndex]];
    
        //for using additional info we should add to the returned dictionary
        //value with key @"additionalInfo"
        if (additionalInfo){
            [resultDictionary setObject:additionalInfo forKey:@"additionalInfo"];
        }
        
        return resultDictionary;
        
    }
    
}


@end
