//
//  HowToMeasureViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 01.08.12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MeasureViewController.h"
#import "MeasureByParamsViewController.h"
#import "MeasureManager.h"


@interface HowToMeasureViewController : UIViewController <UITabBarControllerDelegate, UINavigationBarDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
{
    UIScrollView *clothesScrollView;
    UIImageView *figureView;
    NSInteger backButtonNum;
    NSArray *tableClothesArray;
    NSMutableArray *imageViewsArray;
    NSMutableArray *clothesArray;
    NSMutableDictionary *whatWillBeMeasuredDict;
    UIImageView *wardrobeView;
    UIButton *infoButton;
    UIScrollView *tableScrollView;
    UIButton *rightArrowButton;
    UIButton *leftArrowButton;
}

@property (nonatomic, retain) IBOutlet UIScrollView *clothesScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *figureView;
@property (nonatomic, assign) NSInteger backButtonNum;
@property (nonatomic, retain) IBOutlet UIImageView *wardrobeView;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIScrollView *tableScrollView;
@property (nonatomic, retain) IBOutlet UIButton *rightArrowButton;
@property (nonatomic, retain) IBOutlet UIButton *leftArrowButton;

- (IBAction) showTips:(id)sender;
- (IBAction) rightArrowBtnClick:(id)sender;
- (IBAction) leftArrowBtnClick:(id)sender;

@end
