//
//  VSProfileManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 15.09.12.
//
//

#import <Foundation/Foundation.h>
#import "Types.h"
#import "Consts.h"

#define kDataFile @"data.plist"

@interface VSProfileManager : NSObject
{
    NSMutableArray *profilesList;
    NSMutableDictionary *currentProfile;
}

@property (nonatomic, retain) NSMutableArray *profilesList;
@property (nonatomic, retain) NSMutableDictionary *currentProfile;

+(VSProfileManager *) sharedProfileManager;


- (NSInteger) saveDataWithKey:(NSString *) key oldKey:(NSString *) oldKey andDictionary:(NSMutableDictionary *) dataDict;
- (void) getProfilesList;
- (void) deleteProfileWithKey:(NSString *) key;
- (void) deleteProfilesWithKeys:(NSArray *) keys;
- (PersonKind) getCurrentProfilePersonKind;
//- (void) setCurrentProfileCharacteristic:(NSString *) characteristic withValue:(id) value;
- (id) getCurrentProfileCharacteristic:(NSString *) characteristic;
- (float) getCurrentProfileValueForBodyParam:(NSString *) bodyParam;
- (BOOL) currentProfileNotEmpty;
- (BOOL) profilesListIsEmpty;
- (BOOL) setTempProfileAsCurrent:(NSMutableDictionary *) tempProfile;
- (void) deleteTempProfile;
- (NSMutableDictionary *) getProfileAtIndex:(NSInteger) index;
- (BOOL) profileAtIndexIsFavorite:(NSInteger) index;
- (BOOL) mainUserProfileExist;
- (BOOL) currentProfileIsMainUserProfile;
@end
