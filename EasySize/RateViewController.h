//
//  RateViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 19.04.13.
//
//

#import <UIKit/UIKit.h>

@interface RateViewController : UIViewController
{
    UILabel *headerText;
    UILabel *messageText;
    UIButton *rateButton;
    UIButton *rateLaterButton;
    UIButton *cancelButton;
    UIImageView *bgImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *headerText;
@property (nonatomic, retain) IBOutlet UILabel *messageText;
@property (nonatomic, retain) IBOutlet UIButton *rateButton;
@property (nonatomic, retain) IBOutlet UIButton *rateLaterButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;

-(IBAction)rateButtonTap:(id)sender;
-(IBAction)rateLaterButtonTap:(id)sender;
-(IBAction)cancelButtonTap:(id)sender;

@end
