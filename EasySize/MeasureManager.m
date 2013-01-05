//
//  MeasureManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 10.10.12.
//
//

#import "MeasureManager.h"
static MeasureManager *manager = nil;

@implementation MeasureManager

+(MeasureManager *)sharedMeasureManager {
    @synchronized(self) {
        if (!manager) {
            manager = [[MeasureManager alloc] init];
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


- (NSArray *)getClothesListForPersonType:(PersonType)personType
{
    
    NSArray *returnedArray;
    
    if (personType == Man){
        //returnedArray =  [NSArray arrayWithObjects:@"Underwear", @"Trousers & jeans", @"T-shirt", @"Shirt", @"Coats & jackets",@"Ring", @"Shoes", @"Gloves", nil];
        returnedArray =  [NSArray arrayWithObjects:@"Trousers & jeans",@"T-shirt", @"Shirt", @"Coats & jackets", @"Underwear", nil];

    }
    else if (personType == Woman){
        //returnedArray = [NSArray arrayWithObjects:@"Underwear", @"Bras", @"Trousers & jeans", @"Skirt", @"T-shirt", @"Shirt", @"Dress", @"Coats & jackets", @"Ring", @"Shoes", @"Gloves", nil];
        returnedArray =  [NSArray arrayWithObjects:@"Trousers & jeans", @"Skirt", @"T-shirt", @"Shirt", @"Dress", @"Coats & jackets", @"Underwear", @"Bras", nil];
    }
    else{
        returnedArray = [NSArray array];
    }
    
    return returnedArray;
}

- (NSArray *) getClothesListForAllGenders
{
    return [NSArray arrayWithObjects:@"Trousers & jeans", @"Skirt", @"T-shirt", @"Shirt", @"Dress", @"Coats & jackets", @"Underwear", @"Bras", nil];

}

- (NSArray *)getClothesWithTheSameSizeForChoosenOne:(NSString *)clothesType andPersonType:(PersonType)personType
{
    NSDictionary *retDict;
    if (personType == Man){
        retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSArray arrayWithObjects:@"Trousers & jeans", nil], @"Underwear",
                   [NSArray arrayWithObjects:@"Underwear", nil], @"Trousers & jeans",
                   [NSArray arrayWithObjects:@"Shirt", @"Coats & jackets", nil], @"T-shirt",
                   [NSArray arrayWithObjects:@"T-shirt", @"Coats & jackets", nil], @"Shirt",
                   [NSArray arrayWithObjects:@"T-shirt", @"Shirt", nil], @"Coats & jackets",
                   nil];
    }
    else if (personType == Woman){
        retDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSArray arrayWithObjects:@"Skirt",@"Trousers & jeans", nil], @"Underwear",
                   [NSArray arrayWithObjects:@"Underwear", @"Skirt", nil], @"Trousers & jeans",
                   [NSArray arrayWithObjects:@"Underwear", @"Trousers & jeans", nil], @"Skirt",
                   [NSArray arrayWithObjects:@"Shirt", @"Coats & jackets", nil], @"T-shirt",
                   [NSArray arrayWithObjects:@"T-shirt", @"Coats & jackets", nil], @"Shirt",
                   [NSArray arrayWithObjects:@"T-shirt", @"Shirt", nil], @"Coats & jackets",
                   nil];
    }
    else{
        
        retDict = [NSDictionary dictionary];
    }
    
    return [retDict valueForKey:clothesType];
}



- (NSMutableDictionary *)getClothesMeasureParamsForPersonType:(PersonType)personType
{
    
    NSMutableDictionary *returnedDictionary;
    
    if (personType == Man){
        
        returnedDictionary = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil], nil],
                               @"T-shirt",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil], nil],
                               @"Shirt",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil], nil],
                               @"Coats & jackets",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Waist", @"?", nil], nil],
                                //[NSMutableArray arrayWithObjects:@"Inside leg", @"?", nil], nil],
                               @"Trousers & jeans",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Waist", @"?", nil], nil],
                               @"Underwear",
                               [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"Foot", @"?", nil], nil],
                               @"Shoes",
                               
                               nil] autorelease];
    }
    else if (personType == Woman){
        returnedDictionary = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil],
                                [NSMutableArray arrayWithObjects:@"Waist", @"?",nil], nil],
                               @"T-shirt",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil],
                                [NSMutableArray arrayWithObjects:@"Waist", @"?",nil], nil],
                               @"Shirt",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil],
                                [NSMutableArray arrayWithObjects:@"Waist", @"?",nil], nil],
                               @"Coats & jackets",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Hips", @"?", nil], nil],
                                //[NSMutableArray arrayWithObjects:@"Inside leg", @"?", nil], nil],
                               @"Trousers & jeans",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Hips", @"?", nil], nil],
                               @"Underwear",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil],
                                [NSMutableArray arrayWithObjects:@"Under chest", @"?",nil], nil],
                               @"Bras",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Hips", @"?", nil], nil],
                               @"Skirt",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Chest", @"?",nil],
                                [NSMutableArray arrayWithObjects:@"Waist", @"?",nil],
                                [NSMutableArray arrayWithObjects:@"Hips", @"?",nil], nil],
                               @"Dress",
                               [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"Foot", @"?", nil], nil],
                               @"Shoes",
                               
                               nil] autorelease];

    }
    else{
        returnedDictionary = [NSMutableDictionary dictionary];
    }
    
    return returnedDictionary;
}

- (NSArray *)getSizesTableForClothesType:(NSString *)clothesType andPersonType:(PersonType)personType
{
    //EU RU US UK INT
    NSDictionary *sizesDict;
    
    if (personType == Man){
        
        sizesDict   =   [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"40", @"40", @"26", @"26", @"3XS", nil],
                          [NSArray arrayWithObjects:@"42", @"42", @"28", @"28", @"2XS", nil],
                          [NSArray arrayWithObjects:@"44", @"44", @"30", @"30", @"XS", nil],
                          [NSArray arrayWithObjects:@"46", @"46", @"32", @"32", @"S", nil],
                          [NSArray arrayWithObjects:@"48", @"48", @"34", @"34", @"S", nil],
                          [NSArray arrayWithObjects:@"50", @"50", @"36", @"36", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"38", @"38", @"M", nil],
                          [NSArray arrayWithObjects:@"54", @"54", @"40", @"40", @"L", nil],
                          [NSArray arrayWithObjects:@"56", @"56", @"42", @"42", @"L", nil],
                          [NSArray arrayWithObjects:@"58", @"58", @"44", @"44", @"XL", nil],
                          [NSArray arrayWithObjects:@"60", @"60", @"46", @"46", @"XL", nil],
                          [NSArray arrayWithObjects:@"62", @"62", @"48", @"48", @"2XL", nil],
                          [NSArray arrayWithObjects:@"64", @"64", @"50", @"50", @"3XL", nil],
                          [NSArray arrayWithObjects:@"66", @"66", @"52", @"52", @"4XL", nil],
                          [NSArray arrayWithObjects:@"68", @"68", @"54", @"54", @"5XL", nil],
                          [NSArray arrayWithObjects:@"70", @"70", @"56", @"56", @"6XL", nil],
                          [NSArray arrayWithObjects:@"72", @"72", @"58", @"58", @"7XL", nil], nil],
                         
                         @"T-shirt",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"40", @"40", @"26", @"26", @"3XS", nil],
                          [NSArray arrayWithObjects:@"42", @"42", @"28", @"28", @"2XS", nil],
                          [NSArray arrayWithObjects:@"44", @"44", @"30", @"30", @"XS", nil],
                          [NSArray arrayWithObjects:@"46", @"46", @"32", @"32", @"S", nil],
                          [NSArray arrayWithObjects:@"48", @"48", @"34", @"34", @"S", nil],
                          [NSArray arrayWithObjects:@"50", @"50", @"36", @"36", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"38", @"38", @"M", nil],
                          [NSArray arrayWithObjects:@"54", @"54", @"40", @"40", @"L", nil],
                          [NSArray arrayWithObjects:@"56", @"56", @"42", @"42", @"L", nil],
                          [NSArray arrayWithObjects:@"58", @"58", @"44", @"44", @"XL", nil],
                          [NSArray arrayWithObjects:@"60", @"60", @"46", @"46", @"XL", nil],
                          [NSArray arrayWithObjects:@"62", @"62", @"48", @"48", @"2XL", nil],
                          [NSArray arrayWithObjects:@"64", @"64", @"50", @"50", @"3XL", nil],
                          [NSArray arrayWithObjects:@"66", @"66", @"52", @"52", @"4XL", nil],
                          [NSArray arrayWithObjects:@"68", @"68", @"54", @"54", @"5XL", nil],
                          [NSArray arrayWithObjects:@"70", @"70", @"56", @"56", @"6XL", nil],
                          [NSArray arrayWithObjects:@"72", @"72", @"58", @"58", @"7XL", nil], nil],
                         @"Shirt",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"40", @"40", @"26", @"26", @"3XS", nil],
                          [NSArray arrayWithObjects:@"42", @"42", @"28", @"28", @"2XS", nil],
                          [NSArray arrayWithObjects:@"44", @"44", @"30", @"30", @"XS", nil],
                          [NSArray arrayWithObjects:@"46", @"46", @"32", @"32", @"S", nil],
                          [NSArray arrayWithObjects:@"48", @"48", @"34", @"34", @"S", nil],
                          [NSArray arrayWithObjects:@"50", @"50", @"36", @"36", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"38", @"38", @"M", nil],
                          [NSArray arrayWithObjects:@"54", @"54", @"40", @"40", @"L", nil],
                          [NSArray arrayWithObjects:@"56", @"56", @"42", @"42", @"L", nil],
                          [NSArray arrayWithObjects:@"58", @"58", @"44", @"44", @"XL", nil],
                          [NSArray arrayWithObjects:@"60", @"60", @"46", @"46", @"XL", nil],
                          [NSArray arrayWithObjects:@"62", @"62", @"48", @"48", @"2XL", nil],
                          [NSArray arrayWithObjects:@"64", @"64", @"50", @"50", @"3XL", nil],
                          [NSArray arrayWithObjects:@"66", @"66", @"52", @"52", @"4XL", nil],
                          [NSArray arrayWithObjects:@"68", @"68", @"54", @"54", @"5XL", nil],
                          [NSArray arrayWithObjects:@"70", @"70", @"56", @"56", @"6XL", nil],
                          [NSArray arrayWithObjects:@"72", @"72", @"58", @"58", @"7XL", nil], nil],
                         @"Coats & jackets",

                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"40", @"40", @"26", @"26", @"3XS", nil],
                          [NSArray arrayWithObjects:@"42", @"42", @"28", @"28", @"2XS", nil],
                          [NSArray arrayWithObjects:@"44", @"44", @"30", @"30", @"XS", nil],
                          [NSArray arrayWithObjects:@"46", @"46", @"31", @"31", @"S", nil],
                          [NSArray arrayWithObjects:@"48", @"48", @"32", @"32", @"S", nil],
                          [NSArray arrayWithObjects:@"50", @"50", @"33", @"33", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"34", @"34", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"35", @"35", @"M", nil],
                          [NSArray arrayWithObjects:@"54", @"54", @"36", @"36", @"L", nil],
                          [NSArray arrayWithObjects:@"56", @"56", @"38", @"38", @"L", nil],
                          [NSArray arrayWithObjects:@"58", @"58", @"40", @"40", @"XL", nil],
                          [NSArray arrayWithObjects:@"60", @"60", @"42", @"42", @"XL", nil],
                          [NSArray arrayWithObjects:@"62", @"62", @"44", @"44", @"2XL", nil],
                          [NSArray arrayWithObjects:@"64", @"64", @"46", @"46", @"3XL", nil],
                          [NSArray arrayWithObjects:@"66", @"66", @"48", @"48", @"4XL", nil],
                          [NSArray arrayWithObjects:@"68", @"68", @"50", @"50", @"5XL", nil], nil],
                         @"Underwear",

                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"40", @"40", @"26", @"26", @"3XS", nil],
                          [NSArray arrayWithObjects:@"42", @"42", @"28", @"28", @"2XS", nil],
                          [NSArray arrayWithObjects:@"44", @"44", @"30", @"30", @"XS", nil],
                          [NSArray arrayWithObjects:@"46", @"46", @"31", @"31", @"S", nil],
                          [NSArray arrayWithObjects:@"48", @"48", @"32", @"32", @"S", nil],
                          [NSArray arrayWithObjects:@"50", @"50", @"33", @"33", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"34", @"34", @"M", nil],
                          [NSArray arrayWithObjects:@"52", @"52", @"35", @"35", @"M", nil],
                          [NSArray arrayWithObjects:@"54", @"54", @"36", @"36", @"L", nil],
                          [NSArray arrayWithObjects:@"56", @"56", @"38", @"38", @"L", nil],
                          [NSArray arrayWithObjects:@"58", @"58", @"40", @"40", @"XL", nil],
                          [NSArray arrayWithObjects:@"60", @"60", @"42", @"42", @"XL", nil],
                          [NSArray arrayWithObjects:@"62", @"62", @"44", @"44", @"2XL", nil],
                          [NSArray arrayWithObjects:@"64", @"64", @"46", @"46", @"3XL", nil],
                          [NSArray arrayWithObjects:@"66", @"66", @"48", @"48", @"4XL", nil],
                          [NSArray arrayWithObjects:@"68", @"68", @"50", @"50", @"5XL", nil], nil],
                         @"Trousers & jeans",

                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"39",    @"38",      @"6.5",   @"5.5",   @"24", nil],
                          [NSArray arrayWithObjects:@"39.5",  @"38.5",    @"7",     @"6",     @"24.5", nil],
                          [NSArray arrayWithObjects:@"40",    @"39",      @"7.5",   @"6.5",   @"25", nil],
                          [NSArray arrayWithObjects:@"41",    @"40",      @"8",     @"7",     @"25.5", nil],
                          [NSArray arrayWithObjects:@"41.5",  @"40.5",    @"8.5",   @"7.5",   @"25.5", nil],
                          [NSArray arrayWithObjects:@"42",    @"41",      @"9",     @"8",     @"26", nil],
                          [NSArray arrayWithObjects:@"42.5",  @"41.5",    @"9.5",   @"8.5",   @"26.5", nil],
                          [NSArray arrayWithObjects:@"43",    @"42",      @"10",    @"9",     @"27", nil],
                          [NSArray arrayWithObjects:@"43.5",  @"42.5",    @"10.5",  @"9.5",   @"27.5", nil],
                          [NSArray arrayWithObjects:@"44",    @"43",      @"11",    @"10",    @"28", nil],
                          [NSArray arrayWithObjects:@"44.5",  @"43.5",    @"11.5",  @"10.5",  @"28.5", nil],
                          [NSArray arrayWithObjects:@"45",    @"44",      @"12",    @"11",    @"28.5", nil],
                          [NSArray arrayWithObjects:@"46",    @"45",      @"12.5",  @"11.5",  @"29", nil],
                          [NSArray arrayWithObjects:@"47",    @"46",      @"13",    @"12",    @"29.5", nil],
                          [NSArray arrayWithObjects:@"47.5",  @"46.5",    @"13.5",  @"12.5",  @"30", nil],
                          [NSArray arrayWithObjects:@"48",    @"47",      @"14",    @"13",    @"30.5", nil],
                          [NSArray arrayWithObjects:@"48.5",  @"47.5",    @"14.5",  @"13.5",  @"31", nil],
                          [NSArray arrayWithObjects:@"49",    @"48",      @"15",    @"14",    @"31.5", nil],
                          [NSArray arrayWithObjects:@"49.5",  @"48.5",    @"15.5",  @"14.5",  @"32", nil],
                          [NSArray arrayWithObjects:@"50",    @"49",      @"16",    @"15",    @"32.5", nil], nil],
                         
                         @"Shoes",
                         
                         nil];
    }
    //EU RU US UK INT
    else if (personType == Woman){
        
        sizesDict   =   [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                        @"T-shirt",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                         @"Shirt",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                         @"Coats & jackets",

                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                         @"Trousers & jeans",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                         @"Underwear",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"65",  @"65",  @"30", @"30", @"65", nil],
                          [NSArray arrayWithObjects:@"70",  @"70",  @"32", @"32", @"70", nil],
                          [NSArray arrayWithObjects:@"75",  @"75",  @"34", @"34", @"75", nil],
                          [NSArray arrayWithObjects:@"80",  @"80",  @"36", @"36", @"80", nil],
                          [NSArray arrayWithObjects:@"85",  @"85",  @"38", @"38", @"85", nil],
                          [NSArray arrayWithObjects:@"90",  @"90",  @"40", @"40", @"90", nil],
                          [NSArray arrayWithObjects:@"95",  @"95",  @"",   @"",   @"95", nil],
                          [NSArray arrayWithObjects:@"100", @"100", @"",   @"",   @"100", nil],
                          [NSArray arrayWithObjects:@"105", @"105", @"",   @"",   @"105", nil],
                          [NSArray arrayWithObjects:@"110", @"110", @"",   @"",   @"110", nil],
                          [NSArray arrayWithObjects:@"115", @"115", @"",   @"",   @"115", nil],
                          [NSArray arrayWithObjects:@"120", @"120", @"",   @"",   @"120", nil], nil],
                         
                         @"Bras",

                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                         @"Skirt",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"32", @"38", @"1",  @"4",  @"2XS", nil],
                          [NSArray arrayWithObjects:@"34", @"40", @"2",  @"6",  @"XS", nil],
                          [NSArray arrayWithObjects:@"36", @"42", @"4",  @"8",  @"S", nil],
                          [NSArray arrayWithObjects:@"38", @"44", @"6",  @"10", @"S", nil],
                          [NSArray arrayWithObjects:@"40", @"46", @"8",  @"12", @"M", nil],
                          [NSArray arrayWithObjects:@"42", @"48", @"10", @"14", @"M", nil],
                          [NSArray arrayWithObjects:@"44", @"50", @"12", @"16", @"L", nil],
                          [NSArray arrayWithObjects:@"46", @"52", @"14", @"18", @"L", nil],
                          [NSArray arrayWithObjects:@"48", @"54", @"16", @"20", @"XL", nil],
                          [NSArray arrayWithObjects:@"50", @"56", @"18", @"22", @"XL", nil],
                          [NSArray arrayWithObjects:@"52", @"58", @"20", @"24", @"2XL", nil],
                          [NSArray arrayWithObjects:@"54", @"60", @"22", @"26", @"2XL", nil], nil],
                         
                         @"Dress",

                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:@"34", @"33", @"4",    @"2",   @"34", nil],
                          [NSArray arrayWithObjects:@"35", @"34", @"4.5",  @"2.5", @"35", nil],
                          [NSArray arrayWithObjects:@"35", @"34", @"5",    @"3",   @"35", nil],
                          [NSArray arrayWithObjects:@"36", @"35", @"5.5",  @"3.5", @"36", nil],
                          [NSArray arrayWithObjects:@"37", @"36", @"6",    @"4",   @"37", nil],
                          [NSArray arrayWithObjects:@"37", @"36", @"6.5",  @"4.5", @"37", nil],
                          [NSArray arrayWithObjects:@"38", @"37", @"7",    @"5",   @"38", nil],
                          [NSArray arrayWithObjects:@"38", @"37", @"7.5",  @"5.5", @"38", nil],
                          [NSArray arrayWithObjects:@"39", @"38", @"8",    @"6",   @"39", nil],
                          [NSArray arrayWithObjects:@"40", @"39", @"8.5",  @"6.5", @"40", nil],
                          [NSArray arrayWithObjects:@"40", @"39", @"9",    @"7",   @"40", nil],
                          [NSArray arrayWithObjects:@"41", @"40", @"9.5",  @"7.5", @"41", nil],
                          [NSArray arrayWithObjects:@"42", @"41", @"10",   @"8",   @"42", nil],
                          [NSArray arrayWithObjects:@"42", @"41", @"10.5", @"8.5", @"42", nil],
                          [NSArray arrayWithObjects:@"43", @"42", @"11",   @"9",   @"43", nil],
                          [NSArray arrayWithObjects:@"44", @"43", @"11.5", @"9.5", @"44", nil],
                          [NSArray arrayWithObjects:@"44", @"43", @"12",   @"10",  @"44", nil], nil],
                         
                         @"Shoes",
                         
                         nil];
    }
    else{
        sizesDict = [NSDictionary dictionary];
    }
    
    return [sizesDict objectForKey:clothesType];
    
}


- (float)getMinSizeForClothesType:(NSString *)clothesType andPersonType:(PersonType) personType
{
    if (personType == Man){
        NSDictionary *valuesDict =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:24.0f], @"Foot",
                                      [NSNumber numberWithFloat:76.0f], @"Chest",
                                      [NSNumber numberWithFloat:66.0f], @"Waist",
                                      [NSNumber numberWithFloat:0.0f],  @"Inside leg",
                                      nil];
        
        return [[valuesDict valueForKey:clothesType] floatValue];
        
    }
    else if (personType == Woman){
        NSDictionary *valuesDict =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:21.0f], @"Foot",
                                      [NSNumber numberWithFloat:74.0f], @"Chest",
                                      [NSNumber numberWithFloat:63.0f], @"Under chest",
                                      [NSNumber numberWithFloat:55.0f], @"Waist",
                                      [NSNumber numberWithFloat:83.0f], @"Hips",
                                      [NSNumber numberWithFloat:0.0f],  @"Inside leg",
                                      nil];
        return [[valuesDict valueForKey:clothesType] floatValue];
    }
    else{
        return 0.0f;
    }
    return 0.0f;
}

- (float)getMaxSizeForClothesType:(NSString *)clothesType andPersonType:(PersonType) personType
{
    if (personType == Man){
        NSDictionary *valuesDict =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:33.0f], @"Foot",
                                      [NSNumber numberWithFloat:150.0f], @"Chest",
                                      [NSNumber numberWithFloat:130.0f], @"Waist",
                                      [NSNumber numberWithFloat:200.0f], @"Inside leg",
                                      nil];
        
        return [[valuesDict valueForKey:clothesType] floatValue];
        
    }
    else if (personType == Woman){
        NSDictionary *valuesDict =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:28.4f],  @"Foot",
                                      [NSNumber numberWithFloat:140.0f], @"Chest",
                                      [NSNumber numberWithFloat:130.0f], @"Under chest",
                                      [NSNumber numberWithFloat:120.0f], @"Waist",
                                      [NSNumber numberWithFloat:140.0f], @"Hips",
                                      [NSNumber numberWithFloat:200.0f], @"Inside leg",
                                      nil];
        
        return [[valuesDict valueForKey:clothesType] floatValue];

    }
    else{
        return 99999.0f;
    }
    return 99999.0f;
}

 /*
- (float)getStepSliderValueForKey:(NSString *)key andPersonType:(PersonType) personType
{
    if (personType == Man){
        NSDictionary *valuesDict =   [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:0.4f], @"Foot",
                                      [NSNumber numberWithFloat:1.0f], @"Chest",
                                      [NSNumber numberWithFloat:1.0f], @"Waist",
                                      nil];
        
        return [[valuesDict valueForKey:key] floatValue];
        
    }
    else if (personType == Woman){
        
    }
    else{
        return 1.0f;
    }
    return 1.0f;
     
}*/

//returned value is scrollview offset koef
- (NSInteger)findSizeForKeysAndValues:(NSDictionary *)keyAndValues andPersonType:(PersonType)personType
{
    NSInteger maxValue = 0;
    
    for (NSString *clothesType in keyAndValues) {
        float currentValue = [[keyAndValues objectForKey:clothesType] floatValue];
        NSArray *sizesIntervals = [self getSizesIntervalsForClothesType:clothesType andPersonType:personType];
        
        for (NSArray *object in sizesIntervals) {
            if ((currentValue >= [[object objectAtIndex:0] floatValue]) && (currentValue < [[object objectAtIndex:1] floatValue])){
                if (maxValue < [sizesIntervals indexOfObject:object]) {
                    maxValue = [sizesIntervals indexOfObject:object];
                }
            }
        }
        
    }
    
    return maxValue;
}

- (float)getSizeValueForKey:(NSString *)key PersonType:(PersonType)personType andState:(NSInteger)state
{
    NSArray *sizesIntervals = [self getSizesIntervalsForClothesType:key andPersonType:personType];
    // return min value from interval
    return [[[sizesIntervals objectAtIndex:state] objectAtIndex:0] floatValue];
}

#pragma mark help functions

- (NSArray *)getSizesIntervalsForClothesType:(NSString *)clothesType andPersonType:(PersonType) personType
{
    
    NSDictionary *sizesDict;
    
    if (personType == Man){
        
        sizesDict   =   [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:24.4f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:24.4f], [NSNumber numberWithFloat:25.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:25.0f], [NSNumber numberWithFloat:25.4f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:25.4f], [NSNumber numberWithFloat:25.7f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:25.7f], [NSNumber numberWithFloat:26.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:26.0f], [NSNumber numberWithFloat:26.5f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:26.5f], [NSNumber numberWithFloat:27.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:27.0f], [NSNumber numberWithFloat:27.5f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:27.5f], [NSNumber numberWithFloat:27.9f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:27.9f], [NSNumber numberWithFloat:28.3f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:28.3f], [NSNumber numberWithFloat:28.6f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:28.6f], [NSNumber numberWithFloat:29.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:29.0f], [NSNumber numberWithFloat:29.4f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:29.4f], [NSNumber numberWithFloat:29.9f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:29.9f], [NSNumber numberWithFloat:30.4f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:30.4f], [NSNumber numberWithFloat:30.9f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:30.9f], [NSNumber numberWithFloat:31.4f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:31.4f], [NSNumber numberWithFloat:31.8f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:31.8f], [NSNumber numberWithFloat:32.5f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:32.5f], [NSNumber numberWithFloat:999.0f], nil], nil],
                         
                         @"Foot",
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:81.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:81.0f], [NSNumber numberWithFloat:84.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:84.0f], [NSNumber numberWithFloat:87.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:87.0f], [NSNumber numberWithFloat:90.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:90.0f], [NSNumber numberWithFloat:94.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:94.0f], [NSNumber numberWithFloat:98.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:98.0f], [NSNumber numberWithFloat:101.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:101.0f], [NSNumber numberWithFloat:105.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:105.0f], [NSNumber numberWithFloat:109.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:109.0f], [NSNumber numberWithFloat:113.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:113.0f], [NSNumber numberWithFloat:117.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:117.0f], [NSNumber numberWithFloat:121.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:121.0f], [NSNumber numberWithFloat:125.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:125.0f], [NSNumber numberWithFloat:130.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:130.0f], [NSNumber numberWithFloat:135.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:135.0f], [NSNumber numberWithFloat:140.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:140.0f], [NSNumber numberWithFloat:999.0f], nil],nil],
                         @"Chest",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:71.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:71.0f], [NSNumber numberWithFloat:76.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:76.0f], [NSNumber numberWithFloat:78.5f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:78.5f], [NSNumber numberWithFloat:81.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:81.0f], [NSNumber numberWithFloat:83.5f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:83.5f], [NSNumber numberWithFloat:86.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:86.0f], [NSNumber numberWithFloat:88.5f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:88.5f], [NSNumber numberWithFloat:91.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:91.0f], [NSNumber numberWithFloat:96.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:96.0f], [NSNumber numberWithFloat:101.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:101.0f], [NSNumber numberWithFloat:106.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:106.0f], [NSNumber numberWithFloat:111.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:111.0f], [NSNumber numberWithFloat:116.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:116.0f], [NSNumber numberWithFloat:121.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:121.0f], [NSNumber numberWithFloat:126.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:126.0f], [NSNumber numberWithFloat:999.0f], nil], nil],
                         
                         @"Waist",

                         
                         nil];
    }
    else if (personType == Woman){
        sizesDict   =   [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:21.5f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:21.5f], [NSNumber numberWithFloat:21.9f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:21.9f], [NSNumber numberWithFloat:22.3f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:22.3f], [NSNumber numberWithFloat:22.8f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:22.8f], [NSNumber numberWithFloat:23.2f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:23.2f], [NSNumber numberWithFloat:23.6f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:23.6f], [NSNumber numberWithFloat:24.1f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:24.1f], [NSNumber numberWithFloat:24.5f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:24.5f], [NSNumber numberWithFloat:25.0f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:25.0f], [NSNumber numberWithFloat:25.4f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:25.4f], [NSNumber numberWithFloat:25.8f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:25.8f], [NSNumber numberWithFloat:26.2f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:26.2f], [NSNumber numberWithFloat:26.7f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:26.7f], [NSNumber numberWithFloat:27.1f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:27.1f], [NSNumber numberWithFloat:27.5f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:27.5f], [NSNumber numberWithFloat:27.9f], nil],
                         [NSArray arrayWithObjects:[NSNumber numberWithFloat:27.9f], [NSNumber numberWithFloat:999.0f], nil], nil],
                         
                         @"Foot",
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],   [NSNumber numberWithFloat:78.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:78.0f],  [NSNumber numberWithFloat:81.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:81.0f],  [NSNumber numberWithFloat:86.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:86.0f],  [NSNumber numberWithFloat:91.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:91.0f],  [NSNumber numberWithFloat:96.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:96.0f],  [NSNumber numberWithFloat:101.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:101.0f], [NSNumber numberWithFloat:106.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:106.0f], [NSNumber numberWithFloat:111.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:111.0f], [NSNumber numberWithFloat:116.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:116.0f], [NSNumber numberWithFloat:121.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:121.0f], [NSNumber numberWithFloat:126.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:126.0f], [NSNumber numberWithFloat:999.0f], nil],nil],
                         @"Chest",

                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],   [NSNumber numberWithFloat:67.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:67.0f],  [NSNumber numberWithFloat:72.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:72.0f],  [NSNumber numberWithFloat:77.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:77.0f],  [NSNumber numberWithFloat:82.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:82.0f],  [NSNumber numberWithFloat:87.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:87.0f],  [NSNumber numberWithFloat:92.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:92.0f],  [NSNumber numberWithFloat:97.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:97.0f],  [NSNumber numberWithFloat:102.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:102.0f], [NSNumber numberWithFloat:107.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:107.0f], [NSNumber numberWithFloat:112.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:112.0f], [NSNumber numberWithFloat:117.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:117.0f], [NSNumber numberWithFloat:999.0f], nil],nil],
                         @"Under chest",

                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],   [NSNumber numberWithFloat:60.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:60.0f],  [NSNumber numberWithFloat:63.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:63.0f],  [NSNumber numberWithFloat:68.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:68.0f],  [NSNumber numberWithFloat:73.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:73.0f],  [NSNumber numberWithFloat:78.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:78.0f],  [NSNumber numberWithFloat:83.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:83.0f],  [NSNumber numberWithFloat:88.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:88.0f],  [NSNumber numberWithFloat:93.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:93.0f],  [NSNumber numberWithFloat:98.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:98.0f],  [NSNumber numberWithFloat:103.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:103.0f], [NSNumber numberWithFloat:108.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:108.0f], [NSNumber numberWithFloat:999.0f], nil], nil],
                      
                         @"Waist",
                         
                         [NSArray arrayWithObjects:
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:85.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:85.0f], [NSNumber numberWithFloat:87.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:87.0f], [NSNumber numberWithFloat:92.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:92.0f], [NSNumber numberWithFloat:97.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:97.0f], [NSNumber numberWithFloat:102.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:102.0f], [NSNumber numberWithFloat:107.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:107.0f], [NSNumber numberWithFloat:112.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:112.0f], [NSNumber numberWithFloat:117.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:117.0f], [NSNumber numberWithFloat:122.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:122.0f], [NSNumber numberWithFloat:127.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:127.0f], [NSNumber numberWithFloat:132.0f], nil],
                          [NSArray arrayWithObjects:[NSNumber numberWithFloat:132.0f], [NSNumber numberWithFloat:999.0f], nil], nil],
                         
                         @"Hips",


                         nil];

    }
    else{
        sizesDict = [NSDictionary dictionary];
    }
    
    return [sizesDict objectForKey:clothesType];
    
    
}

- (NSArray *)getGenderList
{
    return [NSArray arrayWithObjects:@"Man", @"Woman", nil];
}

- (NSArray *)getSizesListForClothesType:(NSString *)clothesType personType:(PersonType)personType andIndex:(NSInteger)index
{
    return [[self getSizesTableForClothesType:clothesType andPersonType:personType] objectAtIndex:index];
}

- (float)getMeasureKoefForKey:(NSString *)key personType:(PersonType)personType
{
    float koef = 3.5f;
    
    if (personType == Man){
        if ([key isEqualToString:@"Waist"]){
            koef = 3.5f;
        }
        if ([key isEqualToString:@"Foot"]){
            koef = 1.0f;
        }
        if ([key isEqualToString:@"Inside leg"]){
            koef = 1.0f;
        }
    }
    else if (personType == Woman){
        if ([key isEqualToString:@"Waist"]){
            koef = 2.8f;
        }
        if ([key isEqualToString:@"Chest"]){
            koef = 3.14f;
        }
        if ([key isEqualToString:@"Hips"]){
            koef = 2.8f;
        }
        if ([key isEqualToString:@"Foot"]){
            koef = 1.0f;
        }
        if ([key isEqualToString:@"Inside leg"]){
            koef = 1.0f;
        }
    }
    
    return koef;
}

-(NSString *)getLegLengthDescriptionForValue:(float)value andPersonType:(PersonType) personType
{
    NSString *retDescription = @"";
    
    if (personType == Man){
        if ((value >=0) && (value < 76)){
            retDescription = @"32(short)";
        }
        else if ((value >=76) && (value < 86)){
            retDescription = @"34(regular)";
        }
        else if ((value >=86) && (value < 201)){
            retDescription = @"36(long)";
        }
    }
    else if (personType == Woman){
        if ((value >=0) && (value < 76)){
            retDescription = @"30(short)";
        }
        else if ((value >=76) && (value < 86)){
            retDescription = @"32(regular)";
        }
        else if ((value >=86) && (value < 201)){
            retDescription = @"34(long)";
        }

    }
    
    return retDescription;
}

- (NSString *)getLetterForBrasSizeWithChest:(float)chest andUnderChest:(float)underChest
{
    NSString *letter = @"?";
    float diff = chest - underChest;
    if ((diff >= -20) && (diff < 12)){
        letter = @"AA";
    }
    else if ((diff >= 12) && (diff < 14)){
        letter = @"A";
    }
    else if ((diff >= 14) && (diff < 16)){
        letter = @"B";
    }
    else if ((diff >= 16) && (diff < 18)){
        letter = @"C";
    }
    else if ((diff >= 18) && (diff < 20)){
        letter = @"D";
    }
    else if ((diff >= 20) && (diff < 22)){
        letter = @"E";
    }
    else if ((diff >= 22) && (diff < 24)){
        letter = @"F";
    }
    else if ((diff >= 24) && (diff < 26)){
        letter = @"G";
    }
    else if ((diff >= 26) && (diff < 28)){
        letter = @"H";
    }
    
    
    return letter;
}

- (NSArray *)getOrderedMeasureParams
{
    return [NSArray arrayWithObjects:@"Chest", @"Under chest", @"Waist", @"Hips", @"Inside leg", @"Foot", nil];
}

@end
