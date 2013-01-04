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


@interface HowToMeasureViewController : UIViewController <UITabBarControllerDelegate, UINavigationBarDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIScrollView *clothesScrollView;
    UIImageView *figureView;
    UITableView *choosingSizesTableView;
    NSInteger backButtonNum;
    NSArray *tableClothesArray;
    NSMutableArray *imageViewsArray;
    NSMutableArray *clothesArray;
    NSMutableDictionary *whatWillBeMeasuredDict;
    UIImageView *wardrobeView;
    NSInteger numberOfSubviewsBeforeAddingClothes;
    UIButton *infoButton;
}

@property (nonatomic, retain) IBOutlet UIScrollView *clothesScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *figureView;
@property (nonatomic, retain) IBOutlet UITableView *choosingSizesTableView;
@property (nonatomic, assign) NSInteger backButtonNum;
@property (nonatomic, retain) IBOutlet UIImageView *wardrobeView;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction) showTips:(id)sender;

@end
