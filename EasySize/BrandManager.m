//
//  BrandManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 09.01.13.
//
//

#import "BrandManager.h"

#define BRAND_DOES_NOT_HAVE_ITEM @"-"
#define BRAND_DOES_NOT_HAVE_SIZE @"?"


@implementation BrandManager

@synthesize personKind;

- (id)initWithPersonKind:(PersonKind)pKind
{
    self = [super init];
    if (self) {
        self.personKind = pKind;
    }
    return self;
}

- (id)init
{
    return [self initWithPersonKind:Man];
}


#pragma mark - brand manager functions

- (NSArray *)getBrands
{
    NSString *fileName = [@"Brands_" stringByAppendingFormat:@"%d", self.personKind];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
}

- (NSDictionary *)getSizesForBrand:(NSString *)brand
{
    NSString *fileName = [@"BrandsSizes_" stringByAppendingFormat:@"%d", self.personKind];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    return [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:brand];
}




-(NSArray *)getMeasureParamsForBrand:(NSString *)brand stuffType:(NSString *)stuff
{
    
    NSDictionary *clothesDictionary;
    
    if (self.personKind == Man){
        
        clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSArray arrayWithObjects:CHEST, nil], T_SHIRT,
                             [NSArray arrayWithObjects:CHEST, nil], SHIRT,
                             [NSArray arrayWithObjects:CHEST, nil], COATS_JACKETS,
                             [NSArray arrayWithObjects:CHEST, nil], SWEATERS_HOODIES,
                             [NSArray arrayWithObjects:CHEST, nil], TOPS,
                             [NSArray arrayWithObjects:WAIST, HIPS, nil], JEANS,//+@"Inside leg"
                             [NSArray arrayWithObjects:WAIST, HIPS, nil], BRIEFS,
                             [NSArray arrayWithObjects:WAIST, HIPS, nil], SHORTS,
                             [NSArray arrayWithObjects:WAIST, HIPS, nil], SWIMWEAR,
                             [NSArray arrayWithObjects:FOOT,  nil], SHOES,
                             nil];
    }
    else if (self.personKind == Woman){
        clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                             [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                             [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                             [NSArray arrayWithObjects:CHEST, WAIST, nil], TOPS,
                             [NSArray arrayWithObjects:CHEST, WAIST, nil], SWEATERS_HOODIES,
                             [NSArray arrayWithObjects:CHEST, WAIST, nil], SLEEPWEAR,
                             [NSArray arrayWithObjects:HIPS, WAIST,   nil], PANTS,//+@"Inside leg"
                             [NSArray arrayWithObjects:HIPS, WAIST,  nil], BRIEFS,
                             [NSArray arrayWithObjects:HIPS, WAIST,  nil], SWIMWEAR_B,
                             [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], BRAS,
                             [NSArray arrayWithObjects:CHEST,        nil], SWIMWEAR_T,
                             [NSArray arrayWithObjects:HIPS, WAIST,   nil], SKIRT,
                             [NSArray arrayWithObjects:CHEST, WAIST, HIPS, nil], DRESS,
                             [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                             
                             nil];
        
    }
    else{
        clothesDictionary = [NSMutableDictionary dictionary];
    }

    
    /*
    if ([brand isEqualToString:@"American Apparel"]){
        if (self.personKind == Man){
     
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST,        nil], JEANS,
                                 [NSArray arrayWithObjects:WAIST,        nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                                 nil];
        }
        else if (self.personKind == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST,        nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:WAIST,        nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], BRAS,
                                 [NSArray arrayWithObjects:WAIST,        nil], SKIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], DRESS,
                                 [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                                 nil];
            
        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
    }
    else if ([brand isEqualToString:@"TopShop"]){ //women only brand
        if (self.personKind == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:HIPS,         nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], BRAS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], SKIRT,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], DRESS,
                                 [NSArray arrayWithObjects:FOOT,         nil],SHOES,
                                 nil]; 
            
        }
        else{
            clothesDictionary = [NSDictionary dictionary];
        }

    }
    else if ([brand isEqualToString:@"TopMan"]){//men only brand
        if (self.personKind == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST, nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:WAIST, nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:FOOT,  nil], SHOES,
                                 nil];
        }
        else{
            clothesDictionary = [NSDictionary dictionary];
        }
        
    }
    else if ([brand isEqualToString:@"ASOS"]){
        if (self.personKind == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST, nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:WAIST, nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:FOOT,  nil], SHOES,
                                 nil];
        }
        else if (self.personKind == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:HIPS,         nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], BRAS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], SKIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, HIPS, nil], DRESS,
                                 [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                                 nil];
            
        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
        
    }
    else if ([brand isEqualToString:@"Nike"]){
        if (self.personKind == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], JEANS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,   nil],UNDERWEAR,
                                 [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                                 nil];
        }

        else if (self.personKind == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:CHEST,        nil], BRAS,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], SKIRT,
                                 [NSArray arrayWithObjects:WAIST, HIPS,  nil], DRESS,
                                 [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                                 nil];
            
        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
        
    }

    else{
        if (self.personKind == Man){
            
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                
                                [NSArray arrayWithObjects:CHEST, nil], T_SHIRT,
                                [NSArray arrayWithObjects:CHEST, nil], SHIRT,
                                [NSArray arrayWithObjects:CHEST, nil], COATS_JACKETS,
                                [NSArray arrayWithObjects:CHEST, nil], SWEATERS_HOODIES,
                                [NSArray arrayWithObjects:CHEST, nil], TOPS,
                                [NSArray arrayWithObjects:WAIST, HIPS, nil], JEANS,//+@"Inside leg"
                                [NSArray arrayWithObjects:WAIST, HIPS, nil], UNDERWEAR,
                                [NSArray arrayWithObjects:WAIST, HIPS, nil], SHORTS,
                                [NSArray arrayWithObjects:WAIST, HIPS, nil], SWIMWEAR,
                                [NSArray arrayWithObjects:FOOT,  nil], SHOES,
                                nil];
        }
        else if (self.personKind == Woman){
            clothesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], T_SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], SHIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, nil], COATS_JACKETS,
                                 [NSArray arrayWithObjects:HIPS,         nil], JEANS,//+@"Inside leg"
                                 [NSArray arrayWithObjects:HIPS,         nil], UNDERWEAR,
                                 [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], BRAS,
                                 [NSArray arrayWithObjects:HIPS,         nil], SKIRT,
                                 [NSArray arrayWithObjects:CHEST, WAIST, HIPS, nil], DRESS,
                                 [NSArray arrayWithObjects:FOOT,         nil], SHOES,
                                 nil];

        }
        else{
            clothesDictionary = [NSMutableDictionary dictionary];
        }
    }*/
    
    return [clothesDictionary objectForKey:stuff];
}

- (NSDictionary *)getSizesForBrand:(NSString *)brand stuffType:(NSString *)stuff andBodyParams:(NSDictionary *) bodyParams
{
    NSDictionary *brandClothesTypeSizes = [[self getSizesForBrand:brand] objectForKey:stuff];
    if (!brandClothesTypeSizes){
        return [NSDictionary dictionaryWithObjectsAndKeys:@"-", @"firstSize", nil];
    }
    else{
        

        NSInteger maxSizeIndex = 0;
        NSString *additionalInfo = nil;
        
        //looking for a size for each param and finding out which of them has maximum value 
        for (NSString *key in bodyParams) {
            float paramValue = [[bodyParams objectForKey:key] floatValue];
            //getting sizes array
            NSArray *sizes = [brandClothesTypeSizes objectForKey:@"Sizes"];
            if (!sizes){
                return [NSDictionary dictionaryWithObjectsAndKeys:@"-", @"firstSize", nil];
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
        if ([stuff isEqualToString:BRAS]){
            float difference = [[bodyParams objectForKey:CHEST] floatValue] - [[bodyParams objectForKey:UNDER_CHEST] floatValue];
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

// return first size for selected stuff in selected brand
- (NSString *)getSizeForStuff:(NSString *)stuff forBrand:(NSString *)brand andBodyParams:(NSDictionary *)bodyParams
{
    NSDictionary *allSizes = [self getSizesForBrand:brand stuffType:stuff andBodyParams:bodyParams];
    
    NSString *firstSize = [allSizes objectForKey:@"firstSize"];
    if (firstSize){
        if ([allSizes objectForKey:@"additionalInfo"]) {
            firstSize = [NSString stringWithFormat:@"%@ %@", firstSize, [allSizes objectForKey:@"additionalInfo"]];
        }
        
        if ([firstSize isEqualToString:BRAND_DOES_NOT_HAVE_ITEM]){
            firstSize = NSLocalizedString(BRAND_DOES_NOT_HAVE_ITEM_TEXT, nil);
        }
        if ([firstSize isEqualToString:BRAND_DOES_NOT_HAVE_SIZE]){
            firstSize = NSLocalizedString(BRAND_DOES_NOT_HAVE_SIZE_TEXT, nil);
        }
    }
    else{
        //firstSize = @"-";
        firstSize = NSLocalizedString(BRAND_DOES_NOT_HAVE_ITEM_TEXT, nil);
    }
    
    return firstSize;
}

- (NSDictionary *) getSizesForAllBrandsForStuffType:(NSString *)stuff forCurrentProfile:(NSDictionary *)currentProfile
{
    
    NSArray *brands = [self getBrands];
    
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithCapacity:[brands count]];
    
    for (NSString *currentBrand  in brands) {
        NSArray *bodyParams = [self getMeasureParamsForBrand:currentBrand stuffType:stuff];
        
        NSMutableDictionary *bodyParamsWithValues = [[NSMutableDictionary alloc] initWithCapacity:[bodyParams count]];
        for (NSString *param in bodyParams) {
            [bodyParamsWithValues setObject:[NSNumber numberWithFloat:[[currentProfile objectForKey:param] floatValue]] forKey:param];
        }

        
        NSString *size = [self getSizeForStuff:stuff forBrand:currentBrand andBodyParams:bodyParamsWithValues];
        
        [resultDictionary setObject:size forKey:currentBrand];
        
        [bodyParamsWithValues release];
    }
    
    return  resultDictionary;
    
}

@end
