//
//  VSMeasureManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 17.01.13.
//
//

#import "VSMeasureManager.h"

@implementation VSMeasureManager

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

#pragma mark - main functions
//************************************//

- (NSArray *)getStuffForSizeDefining
{
    
    NSArray *returnedArray;
    
    if (self.personKind == Man){
        
        returnedArray =  [NSArray arrayWithObjects:TOPS, T_SHIRT, SHIRT, JEANS, SHORTS, SWEATERS_HOODIES, COATS_JACKETS, UNDERWEAR,  SWIMWEAR,  nil];
        
    }
    else if (self.personKind == Woman){
       
        returnedArray =  [NSArray arrayWithObjects:DRESS, TOPS, T_SHIRT, SHIRT, SKIRT, PANTS, SWEATERS_HOODIES, COATS_JACKETS, BRAS, BRIEFS, SLEEPWEAR, SWIMWEAR_B, SWIMWEAR_T,nil];
    }
    else{
        returnedArray = [NSArray array];
    }
    
    return returnedArray;
}

//************************************//

- (NSSet *) getLockedBeforeSharingStuff
{
    
    NSSet *lockedStuf;
    
    if (self.personKind == Man){
        
        lockedStuf =  [NSSet setWithObjects:UNDERWEAR, nil];
        
    }
    else if (self.personKind == Woman){
        
        lockedStuf =  [NSSet setWithObjects:BRIEFS, BRAS, nil];
    }
    else{
        lockedStuf = [NSSet set];
    }
    
    return lockedStuf;
}
//************************************//


//************************************//
- (NSArray *) getStuffForSizeDefiningForAllKindsOfPeople
{
    return [NSArray arrayWithObjects:JEANS, SKIRT, T_SHIRT, SHIRT, DRESS, COATS_JACKETS, UNDERWEAR, BRAS, SWEATERS_HOODIES, TOPS, SHORTS, SWIMWEAR, BRIEFS, PANTS, SWIMWEAR_B, SWIMWEAR_T, SLEEPWEAR, nil];
    
}

//************************************//
- (NSArray *) getMeasureParamsForStuffType:(NSString *) stuffType
{
    
    NSDictionary *stuffDictionary;
    

    if (self.personKind == Man){
        
        stuffDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSArray arrayWithObjects:CHEST,  nil], T_SHIRT,
                             [NSArray arrayWithObjects:CHEST,  nil], SHIRT,
                             [NSArray arrayWithObjects:CHEST,  nil], COATS_JACKETS,
                             [NSArray arrayWithObjects:WAIST,  nil], JEANS, //+@"Inside leg"
                             [NSArray arrayWithObjects:WAIST,  nil], UNDERWEAR,
                             [NSArray arrayWithObjects:FOOT ,  nil], SHOES,
                             [NSArray arrayWithObjects:CHEST,  nil], TOPS,
                             [NSArray arrayWithObjects:CHEST,  nil], SWEATERS_HOODIES,
                             [NSArray arrayWithObjects:WAIST,  nil], SHORTS,
                             [NSArray arrayWithObjects:WAIST,  nil], SWIMWEAR,
                             nil];
    }
    else if (self.personKind == Woman){
        stuffDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             [NSArray arrayWithObjects:CHEST, WAIST, HIPS, nil], DRESS,
                             [NSArray arrayWithObjects:CHEST, WAIST, HIPS, nil], SLEEPWEAR,
                             [NSArray arrayWithObjects:CHEST, WAIST,       nil], T_SHIRT,
                             [NSArray arrayWithObjects:CHEST, WAIST,       nil], SHIRT,
                             [NSArray arrayWithObjects:CHEST, WAIST,       nil], COATS_JACKETS,
                             [NSArray arrayWithObjects:CHEST, WAIST,       nil], TOPS,
                             [NSArray arrayWithObjects:CHEST, WAIST,       nil], SWEATERS_HOODIES,
                             [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], BRAS,
                             [NSArray arrayWithObjects:HIPS,               nil], PANTS, //+@"Inside leg"
                             [NSArray arrayWithObjects:HIPS,               nil], BRIEFS,
                             [NSArray arrayWithObjects:HIPS,               nil], SWIMWEAR_B,
                             [NSArray arrayWithObjects:HIPS,               nil], SKIRT,
                             [NSArray arrayWithObjects:CHEST, UNDER_CHEST, nil], SWIMWEAR_T,
                             [NSArray arrayWithObjects:FOOT,               nil], SHOES,
                             nil];
        
    }
    else{
        stuffDictionary = [NSDictionary dictionary];
    }

    return [stuffDictionary objectForKey:stuffType];
}

//************************************//

- (NSArray *)getOrderedMeasureParams
{
    return [NSArray arrayWithObjects:CHEST, UNDER_CHEST, WAIST, HIPS, INSIDE_LEG, FOOT, nil];
}

//************************************//

- (NSArray *)getPersonKindsList
{
    return [NSArray arrayWithObjects:PK_MAN, PK_WOMAN, nil];
}

- (NSArray *)getPersonKindsImagesList
{
    return [NSArray arrayWithObjects:[UIImage imageNamed:@"gender_image_0.png"], [UIImage imageNamed:@"gender_image_1.png"], nil];
}

- (float)getMeasureCoefficientForBodyParam:(NSString *)param
{
    float koef = 3.5f;
    
    if (self.personKind == Man){
        if ([param isEqualToString:WAIST]){
            koef = 3.5f;
        }
        if ([param isEqualToString:FOOT]){
            koef = 1.0f;
        }
        if ([param isEqualToString:INSIDE_LEG]){
            koef = 1.0f;
        }
    }
    else if (self.personKind == Woman){
        if ([param isEqualToString:WAIST]){
            koef = 2.8f;
        }
        if ([param isEqualToString:CHEST]){
            koef = 3.14f;
        }
        if ([param isEqualToString:HIPS]){
            koef = 2.8f;
        }
        if ([param isEqualToString:FOOT]){
            koef = 1.0f;
        }
        if ([param isEqualToString:INSIDE_LEG]){
            koef = 1.0f;
        }
    }
    
    return koef;

}

- (NSDictionary *)getSizesForStuffType:(NSString *)stuffType andBodyParams:(NSDictionary *)bodyParams
{
    NSDictionary *stuffTypeSizes = [[self getCommonSizes] objectForKey:stuffType];
    if (!stuffTypeSizes){
        return [NSDictionary dictionaryWithObjectsAndKeys:@"?", @"firstSize", nil];
    }
    else{
        
        
        NSInteger maxSizeIndex = 0;
        NSString *additionalInfo = nil;
        
        //looking for a size for each param and finding out which of them has maximum value
        for (NSString *key in bodyParams) {
            float paramValue = [[bodyParams objectForKey:key] floatValue];
            //getting sizes array
            NSArray *sizes = [stuffTypeSizes objectForKey:@"Sizes"];
            if (!sizes){
                return [NSDictionary dictionaryWithObjectsAndKeys:@"?", @"firstSize", nil];
            }
            else{
                for (NSDictionary *item in sizes) {
                    NSArray *range = [item objectForKey:key];
                    // if current param is not using for defining size, then the range array is nil and we can continue
                    //example - Inside leg for the pants
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
        if ([stuffType isEqualToString:BRAS]){
            float difference = [[bodyParams objectForKey:CHEST] floatValue] - [[bodyParams objectForKey:UNDER_CHEST] floatValue];
            NSArray *difference_info = [stuffTypeSizes objectForKey:@"Difference"];
            for (NSDictionary *item in difference_info) {
                NSArray *range = [item objectForKey:@"Diff"];
                if (difference >= [[range objectAtIndex:0] floatValue] && difference < [[range objectAtIndex:1] floatValue]){
                    additionalInfo = [item objectForKey:@"letter"];
                    break;
                }
            }
            
        }
        
        
        NSArray *sizes = [stuffTypeSizes objectForKey:@"Sizes"];
        NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary:[sizes objectAtIndex:maxSizeIndex]];
        NSMutableArray *sizesArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_SIZE_SYSTEMS];
        
        if ([resultDictionary objectForKey:@"firstSize"]){
            
            [sizesArray addObject:[resultDictionary objectForKey:@"firstSize"]];
            //second size; if doesn't exist use first size
            if ([resultDictionary objectForKey:@"secondSize"]){
                [sizesArray addObject:[resultDictionary objectForKey:@"secondSize"]];
            }
            else{
                [sizesArray addObject:[resultDictionary objectForKey:@"firstSize"]];
            }
            //third size; if doesn't exist use first size
            if ([resultDictionary objectForKey:@"thirdSize"]){
                [sizesArray addObject:[resultDictionary objectForKey:@"thirdSize"]];
            }
            else{
                [sizesArray addObject:[resultDictionary objectForKey:@"firstSize"]];
            }
            //fourth size; if doesn't exist use first size
            if ([resultDictionary objectForKey:@"fourthSize"]){
                [sizesArray addObject:[resultDictionary objectForKey:@"fourthSize"]];
            }
            else{
                [sizesArray addObject:[resultDictionary objectForKey:@"firstSize"]];
            }
            //fifth size; if doesn't exist use first size
            if ([resultDictionary objectForKey:@"fifthSize"]){
                [sizesArray addObject:[resultDictionary objectForKey:@"fifthSize"]];
            }
            else{
                [sizesArray addObject:[resultDictionary objectForKey:@"firstSize"]];
            }
        }
        [resultDictionary removeAllObjects];
        [resultDictionary setObject:sizesArray forKey:@"Sizes"];
        [sizesArray release];
        
        //for using additional info we should add to the returned dictionary
        //value with key @"additionalInfo"
        if (additionalInfo){
            [resultDictionary setObject:additionalInfo forKey:@"additionalInfo"];
        }
        
        return resultDictionary;
    
    }
    
}


- (NSArray *)getStuffWithTheSameMeasureParamsAsGiven:(NSString *)stuff
{
    NSDictionary *retDict;
    if (self.personKind == Man){
        retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSArray arrayWithObjects:JEANS, SHORTS, SWIMWEAR, nil], UNDERWEAR,
                   [NSArray arrayWithObjects:UNDERWEAR, SHORTS, SWIMWEAR, nil], JEANS,
                   [NSArray arrayWithObjects:UNDERWEAR, JEANS, SWIMWEAR, nil], SHORTS,
                   [NSArray arrayWithObjects:UNDERWEAR, JEANS, SHORTS, nil], SWIMWEAR,
                   [NSArray arrayWithObjects:SHIRT, COATS_JACKETS, SWEATERS_HOODIES, TOPS, nil], T_SHIRT,
                   [NSArray arrayWithObjects:T_SHIRT, COATS_JACKETS, SWEATERS_HOODIES, TOPS, nil], SHIRT,
                   [NSArray arrayWithObjects:T_SHIRT, SHIRT, SWEATERS_HOODIES, TOPS, nil], COATS_JACKETS,
                   [NSArray arrayWithObjects:T_SHIRT, SHIRT, SWEATERS_HOODIES, COATS_JACKETS, nil], TOPS,
                   [NSArray arrayWithObjects:T_SHIRT, SHIRT, COATS_JACKETS, TOPS, nil], SWEATERS_HOODIES,
                   nil];
    }
    else if (self.personKind == Woman){
        retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSArray arrayWithObjects:SKIRT, JEANS, nil], UNDERWEAR,
                   [NSArray arrayWithObjects:UNDERWEAR, SKIRT, nil], JEANS,
                   [NSArray arrayWithObjects:UNDERWEAR, JEANS, nil], SKIRT,
                   [NSArray arrayWithObjects:SHIRT, COATS_JACKETS, nil], T_SHIRT,
                   [NSArray arrayWithObjects:T_SHIRT, COATS_JACKETS, nil], SHIRT,
                   [NSArray arrayWithObjects:T_SHIRT, SHIRT, nil], COATS_JACKETS,
                   nil];
    }
    else{
        
        retDict = [NSDictionary dictionary];
    }
    
    return [retDict valueForKey:stuff];
}

- (NSArray *)getAllStuffWithTheSameMeasureParams:(NSArray *)currentStuff
{
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:currentStuff];
    
    for (NSString *stuff in currentStuff) {
        
        NSArray *stuffWithTheSameMeasureParams = [self getStuffWithTheSameMeasureParamsAsGiven:stuff];
        
        for (NSString *thing in stuffWithTheSameMeasureParams) {
            if ([resultArray indexOfObject:thing] == NSNotFound){
                [resultArray addObject:thing];
            }
        }
    }

    return resultArray;
}


#pragma mark - help functions
- (NSDictionary *) getCommonSizes
{
    NSString *fileName = [@"BrandsSizes_" stringByAppendingFormat:@"%d", [self personKind]];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    return [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:@"Common_Sizes"];
}


@end
