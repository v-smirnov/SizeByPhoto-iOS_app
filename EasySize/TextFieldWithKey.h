//
//  TextFieldWithKey.h
//  EasySize
//
//  Created by Vladimir Smirnov on 15.09.12.
//
//

#import <UIKit/UIKit.h>

@interface TextFieldWithKey : UITextField
{
    NSString *key;
}
@property (nonatomic, retain) NSString *key;

@end
