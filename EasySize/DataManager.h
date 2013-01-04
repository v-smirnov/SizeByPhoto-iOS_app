//
//  DataManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 15.09.12.
//
//

#import <Foundation/Foundation.h>
#define kDataFile @"data.plist"

@interface DataManager : NSObject
{
    NSMutableArray *profilesList;
    NSMutableDictionary *currentProfile;
}

@property (nonatomic, retain) NSMutableArray *profilesList;
@property (nonatomic, retain) NSMutableDictionary *currentProfile;

+(DataManager *)sharedDataManager;

- (NSInteger) saveDataWithKey:(NSString *) key oldKey:(NSString *) oldKey andDictionary:(NSMutableDictionary *) dataDict;
- (void) getProfileList;
- (void) deleteProfileWithKey:(NSString *) key;
- (void) deleteProfilesWithKeys:(NSArray *) keys;

@end
