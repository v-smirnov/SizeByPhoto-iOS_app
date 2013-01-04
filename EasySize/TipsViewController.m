//
//  TipsViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 16.12.12.
//
//

#import "TipsViewController.h"
#define TIPS_NUMBER 5 

@interface TipsViewController ()

@end

@implementation TipsViewController

@synthesize delegate, tipsScrollView, pageControl, numberOfPageToShow;


- (void) dealloc
{
    [tipsScrollView release];
    [pageControl release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tipsScrollView = nil;
    self.pageControl = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Tips", nil);
    
    self.pageControl.numberOfPages =TIPS_NUMBER;
    self.pageControl.currentPage = 0;
    
    self.tipsScrollView.delegate = self;
    
    self.tipsScrollView.contentSize = CGSizeMake(self.tipsScrollView.frame.size.width*TIPS_NUMBER, self.tipsScrollView.frame.size.height);
    for (int i = 1; i <= TIPS_NUMBER; i++) {
        [self createNewTipsWithNumber:i andPlaceItToView:self.tipsScrollView];
    }
    
    CGRect visibleRect = CGRectMake(self.tipsScrollView.frame.size.width * self.numberOfPageToShow, 0, self.tipsScrollView.frame.size.width, self.tipsScrollView.frame.size.height);
    
    [self.tipsScrollView scrollRectToVisible:visibleRect animated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - actions&selectors
- (IBAction)done:(id)sender
{
    [self.delegate tipsViewControllerDidFinish:self];
}
#pragma mark - help funtions
-(void) createNewTipsWithNumber:(int) number andPlaceItToView:(UIScrollView *) sView
{
    NSString *tipsName = [@"HelpTip" stringByAppendingString:[NSString stringWithFormat:@"%d",number]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(sView.frame.size.width*(number-1)+5, 10, sView.frame.size.width-10, 10)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.textAlignment =UITextAlignmentLeft;
    label.text = NSLocalizedString(tipsName, nil);
    [label sizeToFit];
    [sView addSubview:label];
    [label release];

}

- (IBAction)changePage
{
    int page = self.pageControl.currentPage;
    CGRect currentFrame = self.tipsScrollView.frame;
    currentFrame.origin.x = currentFrame.size.width * page;
    currentFrame.origin.y = 0;
    [self.tipsScrollView scrollRectToVisible:currentFrame animated:YES];
    
}

#pragma mark - UIScrillDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth = self.tipsScrollView.frame.size.width;
    int page = floor((self.tipsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
}

@end
