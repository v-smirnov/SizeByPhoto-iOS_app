//
//  TipsViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 16.12.12.
//
//

#import <UIKit/UIKit.h>

@class TipsViewController;

@protocol TipsViewControllerDelegate
- (void)tipsViewControllerDidFinish:(TipsViewController *)controller;
@end


@interface TipsViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *tipsScrollView;
    UIPageControl *pageControl;
    NSInteger numberOfPageToShow;
}

@property (assign, nonatomic) id <TipsViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger numberOfPageToShow;
@property (nonatomic, retain) IBOutlet UIScrollView *tipsScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (IBAction)done:(id)sender;
- (IBAction)changePage;

@end
