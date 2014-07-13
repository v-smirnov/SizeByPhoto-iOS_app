//
//  VSProfileManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 15.09.12.
//
//

#import "VSProfileManager.h"
static VSProfileManager *manager = nil;

@implementation VSProfileManager
@synthesize profilesList, currentProfile;

- (void)dealloc
{
    [profilesList release];
    [currentProfile release];
    [super dealloc];
}

+(VSProfileManager *)sharedProfileManager {
    @synchronized(self) {
        if (!manager) {
            manager = [[VSProfileManager alloc] init];
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
    NSInteger returnedValue = PROFILE_SAVE_RESULT_OK; // ok
    
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
        returnedValue  = PROFILE_SAVE_RESULT_PROFILE_WITH_GIVEN_KEY_ALREADY_EXIST;
    }
    else{
        [dict setObject:dataDict forKey:key];
        if (![dict writeToFile:filePath atomically:YES]){
            returnedValue = PROFILE_SAVE_RESULT_ERROR; // writing problem
        }
    }
    
    [dict release];
    
    return returnedValue;
    
}
- (void) getProfilesList
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
        //BOOL reverseSort = NO;
        //sorting array;
        [sortedKeys sortUsingFunction:alphabeticSort context:(void *)NO];
        
        //first step: add to profiles list main profile
        for (NSString *key in sortedKeys) {
            NSMutableDictionary *profile = [dict objectForKey:key];
            if ([self givenProfileIsMainUserProfile:profile]){
                [self.profilesList addObject:profile];
            }
        }

        //second step: add to profiles list favorite profiles
        for (NSString *key in sortedKeys) {
            NSMutableDictionary *profile = [dict objectForKey:key];
            if (([self givenProfileIsFavorite:profile]) && (![self givenProfileIsMainUserProfile:profile])){
                [self.profilesList addObject:profile];
            }
        }
        
        //third step: add to profiles list other profiles
        for (NSString *key in sortedKeys) {
            NSMutableDictionary *profile = [dict objectForKey:key];
            if ((![self givenProfileIsFavorite:profile]) && (![self givenProfileIsMainUserProfile:profile])){
                [self.profilesList addObject:profile];
            }
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
/*
- (void)setCurrentProfileCharacteristic:(NSString *)characteristic withValue:(id)value
{
    [[self currentProfile] setObject:value forKey:characteristic];
}
*/
- (id) getCurrentProfileCharacteristic:(NSString *)characteristic
{
    return [[self currentProfile] objectForKey:characteristic];
}

- (float)getCurrentProfileValueForBodyParam:(NSString *)bodyParam
{
    if ([[self currentProfile] objectForKey:bodyParam]){
        return [[[self currentProfile] objectForKey:bodyParam] floatValue];
    }
    else{
        return 0.0f;
    }
}

- (PersonKind)getCurrentProfilePersonKind
{
    return (PersonKind)[[[self currentProfile] objectForKey:PROFILE_GENDER] integerValue];
}
- (BOOL)currentProfileNotEmpty
{
    if ([self currentProfile]){
        return TRUE;
    }
    else{
        return FALSE;
    }
}

- (BOOL)profilesListIsEmpty
{
    return ([[self profilesList] count] == 0);
}

- (BOOL)setTempProfileAsCurrent:(NSMutableDictionary *)tempProfile
{
    NSInteger retValue = [self saveDataWithKey:KEY_FOR_TEMP_PROFILE oldKey:KEY_FOR_TEMP_PROFILE andDictionary:tempProfile];
    
    if (retValue == PROFILE_SAVE_RESULT_OK){
        [self setCurrentProfile:tempProfile];
        [self getProfilesList];
        return true;
    }
    else{
        return false;
    }

}
- (void)deleteTempProfile
{
    [self deleteProfileWithKey:KEY_FOR_TEMP_PROFILE];
}

- (NSMutableDictionary *)getProfileAtIndex:(NSInteger)index
{
    return [[self profilesList] objectAtIndex:index];
}

- (BOOL)profileAtIndexIsFavorite:(NSInteger)index
{
    NSMutableDictionary *profile = [[self profilesList] objectAtIndex:index];
    if ([profile objectForKey:PROFILE_IS_FAVORITE]){
        return ([[profile objectForKey:PROFILE_IS_FAVORITE] integerValue] == 1);
    }
    else{
        return false;
    }
        
}

- (BOOL) givenProfileIsFavorite:(NSMutableDictionary *) profile
{
    if ([profile objectForKey:PROFILE_IS_FAVORITE]){
        return ([[profile objectForKey:PROFILE_IS_FAVORITE] integerValue] == 1);
    }
    else{
        return false;
    }

}

- (BOOL)mainUserProfileExist
{
    BOOL mainUserProfileExist = false;
    
    for (NSMutableDictionary *profile in [self profilesList]) {
        if ([profile objectForKey:MAIN_USER_PROFILE]){
            if ([[profile objectForKey:MAIN_USER_PROFILE] integerValue] == 1){
                mainUserProfileExist = true;
                break;
            }
        }
    }
    
    return mainUserProfileExist;
}

- (BOOL)currentProfileIsMainUserProfile
{
    BOOL currentProfileIsMain = false;
    
    if ([[self currentProfile] objectForKey:MAIN_USER_PROFILE]){
        if ([[[self currentProfile] objectForKey:MAIN_USER_PROFILE] integerValue] == 1){
            currentProfileIsMain = true;
        }
    }
   
    return  currentProfileIsMain;
}

- (BOOL)givenProfileIsMainUserProfile:(NSMutableDictionary *) profile
{
        
    if ([profile objectForKey:MAIN_USER_PROFILE]){
        return ([[profile objectForKey:MAIN_USER_PROFILE] integerValue] == 1);
    }
    else{
        return false;
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
