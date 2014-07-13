//
//  VSBrandsLinksManager.m
//  EasySize
//
//  Created by Vladimir Smirnov on 06.09.13.
//
//

#import "VSBrandsLinksManager.h"

@implementation VSBrandsLinksManager


- (NSString *)getURLLinkForBrand:(NSString *)brand stuffType:(NSString *)stuffType country:(NSString *) country andPersonKind:(PersonKind) personKind{
   
    NSString *fileName = [@"BrandsLinks_" stringByAppendingFormat:@"%d", personKind];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    NSDictionary *links = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:brand];
    NSDictionary *stuffLinks = [links objectForKey:stuffType];
    
    return [stuffLinks objectForKey:country];
}

@end
