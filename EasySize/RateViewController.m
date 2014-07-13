//
//  RateViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 19.04.13.
//
//

#import "RateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Consts.h"

#define APP_URL @"https://itunes.apple.com/us/app/easysize/id547895474?l=ru&ls=1&mt=8"

@interface RateViewController ()

@end

@implementation RateViewController

@synthesize headerText, messageText, rateButton, rateLaterButton, cancelButton, bgImageView;

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
    
    [[self bgImageView] setClipsToBounds:YES];
    [[[self bgImageView] layer] setCornerRadius:15.0f];
    [[[self view] layer] setCornerRadius:15.0f];
    [[[self bgImageView] layer] setBorderWidth:2.0f];
    [[[self bgImageView] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self view] setAlpha:0.0f];
    // Do any additional setup after loading the view from its nib.
    /*
     
     UIAlertView* alert = [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Love using EasySize?", nil)
     message:NSLocalizedString(@"Please rate us in the AppStore", nil)
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"No, thanks", nil)
     otherButtonTitles:NSLocalizedString(@"Rate now", nil), NSLocalizedString(@"Ask me later", nil), nil];
     [alert show];
     [alert release];

     */
    self.headerText.text = NSLocalizedString(@"Love using EasySize?", nil);
    self.headerText.font = [UIFont fontWithName:TIP_LABEL_FONT size:RATE_LABEL_FONT_SIZE];

    self.messageText.text = NSLocalizedString(@"Please rate us in the AppStore", nil);
    self.messageText.font = [UIFont fontWithName:TIP_LABEL_FONT size:RATE_LABEL_FONT_SIZE];

    
    [self.rateButton setTitle:NSLocalizedString(@"Rate now", nil) forState:UIControlStateNormal];
    [self.rateButton.titleLabel setFont:[UIFont fontWithName:BUTTON_FONT size:BUTTON_FONT_SIZE]];
    [self.rateButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed.png"] forState:UIControlStateHighlighted];
    
    [self.rateLaterButton setTitle:NSLocalizedString(@"Ask me later", nil) forState:UIControlStateNormal];
    [self.rateLaterButton.titleLabel setFont:[UIFont fontWithName:BUTTON_FONT size:BUTTON_FONT_SIZE]];
    [self.rateLaterButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed.png"] forState:UIControlStateHighlighted];
    
    [self.cancelButton setTitle:NSLocalizedString(@"No, thanks", nil) forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:BUTTON_FONT size:BUTTON_FONT_SIZE]];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed.png"] forState:UIControlStateHighlighted];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.headerText = nil;
    self.messageText = nil;
    self.rateButton = nil;
    self.rateLaterButton = nil;
    self.cancelButton = nil;
    self.bgImageView = nil;
}

- (void)dealloc
{
    [headerText release];
    [messageText release];
    [rateButton release];
    [rateLaterButton release];
    [cancelButton release];
    [bgImageView release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rateButtonTap:(id)sender
{
    
    NSURL *url = [[NSURL alloc] initWithString:APP_URL];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
    
    [self hideView];
}

-(void)rateLaterButtonTap:(id)sender
{
    [self hideView];
}

-(void)cancelButtonTap:(id)sender
{
    [self hideView];
}

-(void) hideView
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self view] setAlpha:0.0f];
    }
                     completion:^(BOOL finished) {
                         [[self view ] removeFromSuperview];
                     }];
}

@end
