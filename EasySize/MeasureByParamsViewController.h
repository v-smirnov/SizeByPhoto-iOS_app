//
//  MeasureByParamsViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 26.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MeasureManager.h"
#import "LabeledSlider.h"
#import "MeasureView.h"
#import "ResultViewController.h"
#import "DataManager.h"

@interface MeasureByParamsViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *viewsStateArray;
    NSMutableArray *whatToMeasureArray;
    UIScrollView *scrollView;
    BOOL inchesSelected;
}

@property (nonatomic, retain) NSMutableArray *whatToMeasureArray;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

-(void) anyButtonPressed:(id)sender;
- (IBAction) showTips:(id)sender;

@end
