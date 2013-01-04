//
//  LabeledSlider.h
//  EasySize
//
//  Created by Vladimir Smirnov on 29.08.12.
//
//

#import <UIKit/UIKit.h>

@interface LabeledSlider : UISlider
{
    UILabel *nameLabel;
    UILabel *valueLabel;
    UIView *viewThatOwnsScrollView;
    NSString *sliderKey;
    float step;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *valueLabel;
@property (nonatomic, retain) NSString *sliderKey;
@property (nonatomic, assign) UIView *viewThatOwnsScrollView;
@property (nonatomic, assign) float step;

@end
