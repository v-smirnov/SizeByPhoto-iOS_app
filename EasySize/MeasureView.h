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
    NSMutableArray *slidersArray;
    NSString *viewKey;
    UIScrollView *sizesScrollView;
    UILabel *additionalInfoLabel;
}

@property (nonatomic, retain) NSMutableArray *slidersArray;
@property (nonatomic, retain) NSString *viewKey;
@property (nonatomic, retain) UIScrollView *sizesScrollView;
@property (nonatomic, retain) UILabel *additionalInfoLabel;
@end
