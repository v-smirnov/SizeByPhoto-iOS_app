//
//  VSBrandsLinksManager.h
//  EasySize
//
//  Created by Vladimir Smirnov on 06.09.13.
//
//

#import <Foundation/Foundation.h>
#import "Types.h"

@interface VSBrandsLinksManager : NSObject

- (NSString *)getURLLinkForBrand:(NSString *)brand stuffType:(NSString *)stuffType country:(NSString *) country andPersonKind:(PersonKind) personKind;

@end
