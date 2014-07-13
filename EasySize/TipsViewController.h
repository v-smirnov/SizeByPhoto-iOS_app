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


@interface TipsViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate>
{
    UIScrollView *tipsScrollView;
    UIPageControl *pageControl;
    NSInteger numberOfPageToShow;
    UIActivityIndicatorView *activityIndicator;
}

@property (assign, nonatomic) id <TipsViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger numberOfPageToShow;
@property (nonatomic, retain) IBOutlet UIScrollView *tipsScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)done:(id)sender;
- (IBAction)changePage;

@end
