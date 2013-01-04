//
//  DataManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 15.09.12.
//
//

#import "DataManager.h"
static DataManager *manager = nil;

@implementation DataManager
@synthesize profilesList, currentProfile;

- (void)dealloc
{
    [profilesList release];
    [currentProfile release];
    [super dealloc];
}

+(DataManager *)sharedDataManager {
    @synchronized(self) {
        if (!manager) {
            manager = [[DataManager alloc] init];
        }
    }
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        profilesList = [[NSMutableArray alloc] init];
        currentProfile = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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

#pragma mark instance functions
- (NSInteger) saveDataWithKey:(NSString *)key oldKey:(NSString *) oldKey andDictionary:(NSMutableDictionary *) dataDict;
{
    NSInteger returnedValue = 1; // ok
    
    NSString *filePath = [self dataFilePath];
    NSMutableDictionary *dict;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        // remove old value
        if (![oldKey isEqualToString:@""]){
            [dict removeObjectForKey:oldKey];
        }
    }
    else
    {
        dict = [[NSMutableDictionary alloc] init];
    }
    
    //is value with key already exist?
    if ([dict objectForKey:key]){
        returnedValue  = 2; // person with given key already exist
    }
    else{
        [dict setObject:dataDict forKey:key];
        if (![dict writeToFile:filePath atomically:YES]){
            returnedValue = 0; // writing problem
        }
    }
    
    [dict release];
    
    return returnedValue;
    
}
- (void) getProfileList
{
    NSString *filePath = [self dataFilePath];
    NSMutableDictionary *dict;
    
    [[self profilesList] removeAllObjects];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        
        NSMutableArray *sortedKeys = [[NSMutableArray alloc] init];
        
        for (NSString *key in dict){
            [sortedKeys addObject:key];
        }
        BOOL reverseSort = NO;
        //sorting array;
        [sortedKeys sortUsingFunction:alphabeticSort context:(void *)reverseSort];
        
        for (NSString *key in sortedKeys) {
            [self.profilesList addObject:[dict objectForKey:key]];
        }
        
        [sortedKeys release];
        [dict release];
    }
    
    
}
- (void) deleteProfileWithKey:(NSString *)key
{
    NSString *filePath = [self dataFilePath];
    NSMutableDictionary *dict;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [dict removeObjectForKey:key];
        [dict writeToFile:filePath atomically:YES];
        [dict release];
    }
    
}

- (void) deleteProfilesWithKeys:(NSArray *)keys
{
    NSString *filePath = [self dataFilePath];
    NSMutableDictionary *dict;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        [dict removeObjectsForKeys:keys];
        [dict writeToFile:filePath atomically:YES];
        [dict release];
    }
    
}


#pragma mark help functions
- (NSString *) dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDataFile];
    return path;
}

// for array sorting
NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
    if (reverse) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    } else {
        return [string1 localizedCaseInsensitiveCompare:string2];
    }
}



@end
