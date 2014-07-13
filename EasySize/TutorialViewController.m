//
//  TutorialViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 16.09.13.
//
//

#import "TutorialViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

#define RULER_TAG 10
#define LABEL_TAG 11


@interface TutorialViewController ()

@end

@implementation TutorialViewController

@synthesize tImageView, bodyPartForAnimation, personKind, pictureMode, delegate, playButton, doneButton, closeViewWhenAminationEnds, navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tImageView = nil;
    self.bodyPartForAnimation = nil;
    self.playButton = nil;
    self.doneButton = nil;
    self.navItem = nil;
    
}

- (void)dealloc
{
    [tImageView release];
    [bodyPartForAnimation release];
    [playButton release];
    [doneButton release];
    [navItem release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navItem setTitle: NSLocalizedString(@"Tutorial", nil)];
    [self.playButton setTitle: NSLocalizedString(@"PLAY", nil)];
    
    if (closeViewWhenAminationEnds){
        [[self doneButton] setEnabled:NO];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tImageTapToEndAnimation)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.tImageView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    animationAlreadyStopedByUser = false;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *imageName = @"Tip_photo";
    if (self.pictureMode == side){
        imageName = [imageName stringByAppendingString:@"_side"];
    }
    
    imageName = [imageName stringByAppendingFormat:@"_%d", self.personKind];
    
    [[self tImageView] setImage: [UIImage imageNamed:imageName]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions 

- (void) tImageTapToEndAnimation
{
    if (animationAlreadyStopedByUser){
        return;
    }

    float iOS7_y_correction = 0.0f;
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ){
        iOS7_y_correction = 20.0f;
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        if (self.personKind == Woman){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:250.0f+iOS7_y_correction xCorrection:10.8f andScaleKoef:0.71f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self bringAnimationToEndWithDistance:264.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.674f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:292.0f+iOS7_y_correction xCorrection:8.5f andScaleKoef:0.627f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:390.0f+iOS7_y_correction xCorrection:4.5f andScaleKoef:0.86f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:256.0f+iOS7_y_correction xCorrection:77.5f andScaleKoef:0.5677f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self bringAnimationToEndWithDistance:281.0f+iOS7_y_correction xCorrection:81.5f andScaleKoef:0.465f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:309.0f+iOS7_y_correction xCorrection:77.0f andScaleKoef:0.44f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:396.0f+iOS7_y_correction xCorrection:81.0f andScaleKoef:0.53f];
                }
                
            }
        }
        else if (self.personKind == Man){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:254.0f+iOS7_y_correction xCorrection:11.0f andScaleKoef:0.805f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:359.0f+iOS7_y_correction xCorrection:13.0f andScaleKoef:0.76f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:394.0f+iOS7_y_correction xCorrection:12.0f andScaleKoef:0.78f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:219.0f+iOS7_y_correction xCorrection:88.5f andScaleKoef:0.578f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:313.0f+iOS7_y_correction xCorrection:61.0f andScaleKoef:0.512f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:364.0f+iOS7_y_correction xCorrection:67.0f andScaleKoef:0.55f];
                }
                
            }
            
        }
    }
    else{
        if (self.personKind == Woman){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:200.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.66f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self bringAnimationToEndWithDistance:222.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.62f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:253.0f+iOS7_y_correction xCorrection:8.0f andScaleKoef:0.6f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:334.0f+iOS7_y_correction xCorrection:4.0f andScaleKoef:0.8f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:215.0f+iOS7_y_correction xCorrection:74.0f andScaleKoef:0.52f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self bringAnimationToEndWithDistance:237.0f+iOS7_y_correction xCorrection:77.0f andScaleKoef:0.43f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:268.0f+iOS7_y_correction xCorrection:72.0f andScaleKoef:0.42f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:349.0f+iOS7_y_correction xCorrection:76.0f andScaleKoef:0.49f];
                }
                
            }
        }
        else if (self.personKind == Man){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:215.0f+iOS7_y_correction xCorrection:11.0f andScaleKoef:0.65f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:290.0f+iOS7_y_correction xCorrection:11.0f andScaleKoef:0.63f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:350.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.67f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self bringAnimationToEndWithDistance:178.0f+iOS7_y_correction xCorrection:84.0f andScaleKoef:0.55f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self bringAnimationToEndWithDistance:260.0f+iOS7_y_correction xCorrection:58.0f andScaleKoef:0.49f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self bringAnimationToEndWithDistance:326.0f+iOS7_y_correction xCorrection:64.0f andScaleKoef:0.52f];
                }
                
            }
            
        }
        
    }
    
    animationAlreadyStopedByUser = true;
}

- (void)playAnimation:(id)sender
{
    animationAlreadyStopedByUser = false;
    [self performAnimation];
}

-(void)done:(id)sender
{
    [self.delegate TutorialViewControllerDidFinish:self];
    //[self.view.layer removeAllAnimations];
}


#pragma mark - help functions
- (void) performAnimation
{
   
    float rulerWidth = 160.0f;
    float rulerHeight = 15.0f;
    
    CGPoint rulerCenter = CGPointMake(self.tImageView.frame.size.width/2, self.tImageView.frame.size.height/2);
    
    CGRect rulerRect = CGRectMake(rulerCenter.x-rulerWidth/2, rulerCenter.y-rulerHeight/2, rulerWidth, rulerHeight);
    
    UIImageView *rulerView = (UIImageView *)[self.view viewWithTag:RULER_TAG];
    
    if (!rulerView){
        rulerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruler.png"]];
        [rulerView setFrame: rulerRect];
        [rulerView setTag: RULER_TAG];
        [rulerView setAlpha:0.0f];
        [self.view addSubview:rulerView];
        [rulerView release];
    }
    else {
        [rulerView setFrame: rulerRect];
    }
    
    UILabel *hintLabel = (UILabel *)[self.view viewWithTag:LABEL_TAG];
    
    if (!hintLabel){
        
        
        NSString *hintText = @"";
        if (self.pictureMode == side){
            hintText = [self.bodyPartForAnimation stringByAppendingString:@"_side"];
        }
        else{
            hintText = self.bodyPartForAnimation;
        }
        hintText = [hintText stringByAppendingFormat:@"_%d", self.personKind];
        
        hintLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, self.tImageView.center.y-100, self.tImageView.frame.size.width-10, 100)];
        [hintLabel setTextColor: [UIColor whiteColor]];
        [hintLabel setFont: [UIFont fontWithName:TIP_LABEL_FONT size:16.0f]];
        //[hintLabel setBackgroundColor: [UIColor clearColor]];
        [hintLabel setAlpha:0.0f];
        [hintLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Tutorial_label_background.png"]]];
        [hintLabel setNumberOfLines: 0];
        [hintLabel setTag: LABEL_TAG];
        [hintLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [hintLabel setTextAlignment: NSTextAlignmentCenter];
        [hintLabel setText: NSLocalizedString(hintText, nil)];
        //[[hintLabel layer] setCornerRadius: 15.0f];
        
        [self.tImageView addSubview:hintLabel];
        [hintLabel release];
    }
    else{
        [hintLabel setFrame:CGRectMake(5, self.tImageView.center.y-100, self.tImageView.frame.size.width-10, 100)];
    }
    
    
    float iOS7_y_correction = 0.0f;
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ){
        iOS7_y_correction = 20.0f;
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568){
        if (self.personKind == Woman){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:250.0f+iOS7_y_correction xCorrection:10.8f andScaleKoef:0.71f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self performSingleAnimationWithDistance:264.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.674f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:292.0f+iOS7_y_correction xCorrection:8.5f andScaleKoef:0.627f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:390.0f+iOS7_y_correction xCorrection:4.5f andScaleKoef:0.86f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:256.0f+iOS7_y_correction xCorrection:77.5f andScaleKoef:0.5677f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self performSingleAnimationWithDistance:281.0f+iOS7_y_correction xCorrection:81.5f andScaleKoef:0.465f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:309.0f+iOS7_y_correction xCorrection:77.0f andScaleKoef:0.44f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:396.0f+iOS7_y_correction xCorrection:81.0f andScaleKoef:0.53f];
                }

            }
        }
        else if (self.personKind == Man){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:254.0f+iOS7_y_correction xCorrection:11.0f andScaleKoef:0.805f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:359.0f+iOS7_y_correction xCorrection:13.0f andScaleKoef:0.76f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:394.0f+iOS7_y_correction xCorrection:12.0f andScaleKoef:0.78f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:219.0f+iOS7_y_correction xCorrection:88.5f andScaleKoef:0.578f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:313.0f+iOS7_y_correction xCorrection:61.0f andScaleKoef:0.512f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:364.0f+iOS7_y_correction xCorrection:67.0f andScaleKoef:0.55f];
                }
                
            }

        }
    }
    else{
        if (self.personKind == Woman){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:200.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.66f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self performSingleAnimationWithDistance:222.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.62f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:253.0f+iOS7_y_correction xCorrection:8.0f andScaleKoef:0.6f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:334.0f+iOS7_y_correction xCorrection:4.0f andScaleKoef:0.8f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:215.0f+iOS7_y_correction xCorrection:74.0f andScaleKoef:0.52f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:UNDER_CHEST]){
                    [self performSingleAnimationWithDistance:237.0f+iOS7_y_correction xCorrection:77.0f andScaleKoef:0.43f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:268.0f+iOS7_y_correction xCorrection:72.0f andScaleKoef:0.42f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:349.0f+iOS7_y_correction xCorrection:76.0f andScaleKoef:0.49f];
                }
                
            }
        }
        else if (self.personKind == Man){
            if (self.pictureMode == main){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:215.0f+iOS7_y_correction xCorrection:11.0f andScaleKoef:0.65f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:290.0f+iOS7_y_correction xCorrection:11.0f andScaleKoef:0.63f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:350.0f+iOS7_y_correction xCorrection:10.0f andScaleKoef:0.67f];
                }
            }
            else if (self.pictureMode == side){
                
                if ([self.bodyPartForAnimation isEqualToString:CHEST]){
                    [self performSingleAnimationWithDistance:178.0f+iOS7_y_correction xCorrection:84.0f andScaleKoef:0.55f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:WAIST]){
                    [self performSingleAnimationWithDistance:260.0f+iOS7_y_correction xCorrection:58.0f andScaleKoef:0.49f];
                }
                else if ([self.bodyPartForAnimation isEqualToString:HIPS]){
                    [self performSingleAnimationWithDistance:326.0f+iOS7_y_correction xCorrection:64.0f andScaleKoef:0.52f];
                }
                
            }
            
        }

    }
    
}

-(void) performSingleAnimationWithDistance:(float) distance xCorrection:(float) xCorrection andScaleKoef:(float) scaleKoef;
{
    
    [self.playButton setEnabled:NO];
    
    UIImageView *rulerView = (UIImageView *)[self.view viewWithTag:RULER_TAG];
    CGPoint rulerCenter = rulerView.center;
    
    UILabel *hintLabel = (UILabel *)[self.view viewWithTag:LABEL_TAG];
    
    
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (!animationAlreadyStopedByUser){
            [hintLabel setAlpha:0.8f];
        }
    }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                             if (!animationAlreadyStopedByUser){
                                 [hintLabel setCenter:CGPointMake(self.tImageView.center.x, self.tImageView.frame.size.height - hintLabel.frame.size.height/2)];
                             }
                         }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                                                  if (!animationAlreadyStopedByUser){
                                                      [rulerView setAlpha:0.8f];
                                                  }
                                              }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                                                                       if (!animationAlreadyStopedByUser){
                                                                           [rulerView setCenter:CGPointMake(rulerCenter.x+xCorrection, distance)];
                                                                       }
                                                                   }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveLinear animations:^{
                                                                                            //rulerView.transform = CGAffineTransformMakeScale(scaleKoef, scaleKoef);
                                                                                            if (!animationAlreadyStopedByUser){
                                                                                                rulerView.transform = CGAffineTransformScale(rulerView.transform, scaleKoef, scaleKoef);
                                                                                            }
                                                                                        }
                                                                                                         completion:^(BOOL finished) {
                                                                                                             [self.playButton setEnabled:YES];
                                                                                                             if (closeViewWhenAminationEnds){
                                                                                                                 [self performSelector:@selector(done:) withObject:nil afterDelay:1.0f];
                                                                                                                 
                                                                                                             }
                                                                                                         }];
                                                                                    }];
                                                               }];
                                          }];
                         
                     }];
    


}

-(void) bringAnimationToEndWithDistance:(float) distance xCorrection:(float) xCorrection andScaleKoef:(float) scaleKoef;
{
    
    [self.playButton setEnabled:YES];
    
    UIImageView *rulerView = (UIImageView *)[self.view viewWithTag:RULER_TAG];
    UILabel *hintLabel = (UILabel *)[self.view viewWithTag:LABEL_TAG];
    
    [rulerView.layer removeAllAnimations];
    [hintLabel.layer removeAllAnimations];
    
    [hintLabel setAlpha:0.8f];
    [rulerView setAlpha:0.8f];
    [hintLabel setCenter:CGPointMake(self.tImageView.center.x, self.tImageView.frame.size.height - hintLabel.frame.size.height/2)];
    
    CGPoint rulerCenter = CGPointMake(self.tImageView.frame.size.width/2, self.tImageView.frame.size.height/2);
    [rulerView setCenter:CGPointMake(rulerCenter.x+xCorrection, distance)];
    rulerView.transform = CGAffineTransformScale(rulerView.transform, scaleKoef, scaleKoef);
    //rulerView.transform = CGAffineTransformMakeScale(scaleKoef, scaleKoef);
    
}


@end
