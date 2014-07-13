//
//  MeasureView.h
//  EasySize
//
//  Created by Vladimir Smirnov on 29.08.12.
//
//

#import <UIKit/UIKit.h>

@interface MeasureView : UIImageView
{
    NSString *viewKey;
    UILabel *additionalInfoLabel;
}

@property (nonatomic, retain) NSString *viewKey;
@property (nonatomic, retain) UILabel *additionalInfoLabel;
@end
