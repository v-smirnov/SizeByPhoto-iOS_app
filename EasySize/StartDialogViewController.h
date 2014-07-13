//
//  startDialogViewController.h
//  EasySize
//
//  Created by Vladimir Smirnov on 25.06.13.
//
//

#import <UIKit/UIKit.h>
#import "VSMeasureManager.h"
#import "Types.h"

@protocol StartDialogViewControllerDelegate;

@interface StartDialogViewController : UIViewController
{
    PersonKind selectedGender;
}


@property (nonatomic, assign) id <StartDialogViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *maleGenderImageView;
@property (nonatomic, retain) IBOutlet UIImageView *femaleGenderImageView;
@property (nonatomic, assign) startDialogType startingFrom;
@property (nonatomic, retain) IBOutlet UIImageView *galleryImageView;
@property (nonatomic, retain) IBOutlet UIImageView *cameraImageView;
@property (nonatomic, retain) IBOutlet UIView *smallView;



-(IBAction) onCloseButtonTap;


@end

@protocol StartDialogViewControllerDelegate
@optional
-(void) startMeasureUsingPhotoSource:(UIImagePickerControllerSourceType) sourceType andSelectedPersonKind:(PersonKind) personKind;
-(void) startMeasureUsingPhotoSource:(UIImagePickerControllerSourceType) sourceType;

@end