//
//  ImageViewWithKey.h
//  EasySize
//
//  Created by Vladimir Smirnov on 20.12.12.
//
//

#import <UIKit/UIKit.h>

@interface ImageViewWithKey : UIImageView
{
    NSString *key;
}

@property (nonatomic, retain) NSString *key;

@end
