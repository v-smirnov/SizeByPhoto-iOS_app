//
//  startDialogViewController.m
//  EasySize
//
//  Created by Vladimir Smirnov on 25.06.13.
//
//

#import "StartDialogViewController.h"
#import "MeasureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Consts.h"
#import "LocalyticsSession.h"

@interface StartDialogViewController ()

@end

@implementation StartDialogViewController

@synthesize bgImageView, closeButton, delegate, scrollView, maleGenderImageView, femaleGenderImageView, startingFrom, galleryImageView, cameraImageView, smallView;

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
    
    [[self bgImageView] setClipsToBounds:YES];
    //[[[self bgImageView] layer] setCornerRadius:15.0f];
    //[[[self smallView] layer] setCornerRadius:15.0f];
    [[[self bgImageView] layer] setBorderWidth:2.0f];
    [[[self bgImageView] layer] setBorderColor:[MAIN_THEME_COLOR CGColor]];
    //[[self bgImageView] setBackgroundColor:GRAY_BACKGROUND_COLOR];
    //[[self bgImageView] setAlpha:0.4f];
    //[[self view] setAlpha:0.4f];
    
      
    //[self.twoNewPhotosButton setTitle:NSLocalizedString(@"Use two new photos", nil) forState:UIControlStateNormal];
    //[self.twoNewPhotosButton.titleLabel setFont:[UIFont fontWithName:BUTTON_FONT size:BUTTON_FONT_SIZE]];
    //[self.twoNewPhotosButton setBackgroundImage:[UIImage imageNamed:@"cameraActive.png"] forState:UIControlStateHighlighted];
    
    
    UITapGestureRecognizer *maleIVTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaleIVTap:)];
    maleIVTapRecognizer.numberOfTapsRequired = 1;
    [self.maleGenderImageView addGestureRecognizer:maleIVTapRecognizer];
    [maleIVTapRecognizer release];
    
    UITapGestureRecognizer *femaleIVTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onFemaleIVTap:)];
    femaleIVTapRecognizer.numberOfTapsRequired = 1;
    [self.femaleGenderImageView addGestureRecognizer:femaleIVTapRecognizer];
    [femaleIVTapRecognizer release];

    UITapGestureRecognizer *galleryIVTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGalleryIVTap:)];
    galleryIVTapRecognizer.numberOfTapsRequired = 1;
    [self.galleryImageView addGestureRecognizer:galleryIVTapRecognizer];
    [galleryIVTapRecognizer release];

    UITapGestureRecognizer *cameraIVTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCameraIVTap:)];
    cameraIVTapRecognizer.numberOfTapsRequired = 1;
    [self.cameraImageView addGestureRecognizer:cameraIVTapRecognizer];
    [cameraIVTapRecognizer release];
    
    if (startingFrom == startingFromMainView){
        [self.scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height)];
        
        UILabel *genderTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 10, self.scrollView.frame.size.width-80, 40)];
        genderTitleLabel.textColor = MAIN_THEME_COLOR;
        genderTitleLabel.font = [UIFont fontWithName:UBUNTU_MEDIUM_FONT size:16.0f];
        genderTitleLabel.backgroundColor = [UIColor clearColor];
        genderTitleLabel.numberOfLines = 0;
        genderTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        genderTitleLabel.textAlignment =NSTextAlignmentCenter;
        genderTitleLabel.text = NSLocalizedString(@"Choose gender of measured person", nil);
        [self.scrollView addSubview:genderTitleLabel];
        [genderTitleLabel release];
        
        [self.maleGenderImageView setFrame:CGRectMake(self.scrollView.center.x-20-self.maleGenderImageView.frame.size.width, self.scrollView.center.y-self.maleGenderImageView.frame.size.height/2+15, self.maleGenderImageView.frame.size.width, self.maleGenderImageView.frame.size.height)];
        [self.femaleGenderImageView setFrame:CGRectMake(self.scrollView.center.x+15, self.scrollView.center.y-self.femaleGenderImageView.frame.size.height/2+15, self.femaleGenderImageView.frame.size.width, self.femaleGenderImageView.frame.size.height)];
        [self.scrollView addSubview:self.maleGenderImageView];
        [self.scrollView addSubview:self.femaleGenderImageView];
        
        
        UILabel *actionTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.scrollView.frame.size.width+40, 10, self.scrollView.frame.size.width-80, 40)];
        actionTitleLabel.textColor = MAIN_THEME_COLOR;
        actionTitleLabel.font = [UIFont fontWithName:UBUNTU_MEDIUM_FONT size:16.0f];
        actionTitleLabel.backgroundColor = [UIColor clearColor];
        actionTitleLabel.numberOfLines = 0;
        actionTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        actionTitleLabel.textAlignment =NSTextAlignmentCenter;
        actionTitleLabel.text = NSLocalizedString(@"Choose or take 2 photos", nil);
        [self.scrollView addSubview:actionTitleLabel];
        [actionTitleLabel release];
        
        float x = self.scrollView.frame.size.width+(self.scrollView.center.x-20-self.galleryImageView.frame.size.width);
        float y = self.scrollView.center.y-self.galleryImageView.frame.size.height/2+15;
        
        CGRect imgFrame = CGRectMake(x, y, self.galleryImageView.frame.size.width, self.galleryImageView.frame.size.height);
        
        [self.galleryImageView setFrame:imgFrame];
        
        UILabel *galeryTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(x-10, y+self.galleryImageView.frame.size.height, 100, 20)];
        galeryTitleLabel.textColor = MAIN_THEME_COLOR;
        galeryTitleLabel.font = [UIFont fontWithName:UBUNTU_FONT size:13.0f];
        galeryTitleLabel.backgroundColor = [UIColor clearColor];
        galeryTitleLabel.numberOfLines = 0;
        galeryTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        galeryTitleLabel.textAlignment =NSTextAlignmentCenter;
        galeryTitleLabel.text = NSLocalizedString(@"from gallery", nil);
        [self.scrollView addSubview:galeryTitleLabel];
        [galeryTitleLabel release];

        
        x = self.scrollView.frame.size.width+(self.scrollView.center.x+20);
        y = self.scrollView.center.y-self.cameraImageView.frame.size.height/2+15;
        imgFrame = CGRectMake(x, y, self.cameraImageView.frame.size.width, self.cameraImageView.frame.size.height);
        
        [self.cameraImageView setFrame:imgFrame];
        
        UILabel *cameraTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(x, y+self.cameraImageView.frame.size.height, 80, 20)];
        cameraTitleLabel.textColor = MAIN_THEME_COLOR;
        cameraTitleLabel.font = [UIFont fontWithName:UBUNTU_FONT size:13.0f];
        cameraTitleLabel.backgroundColor = [UIColor clearColor];
        cameraTitleLabel.numberOfLines = 0;
        cameraTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cameraTitleLabel.textAlignment =NSTextAlignmentCenter;
        cameraTitleLabel.text = NSLocalizedString(@"new", nil);
        [self.scrollView addSubview:cameraTitleLabel];
        [cameraTitleLabel release];

        
        [self.scrollView addSubview:self.galleryImageView];
        [self.scrollView addSubview:self.cameraImageView];
    }
    else if (startingFrom == startingFromOtherView){
        [self.scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
        
        UILabel *actionTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(40, 10, self.scrollView.frame.size.width-80, 40)];
        actionTitleLabel.textColor = MAIN_THEME_COLOR;
        actionTitleLabel.font = [UIFont fontWithName:UBUNTU_MEDIUM_FONT size:16.0f];
        actionTitleLabel.backgroundColor = [UIColor clearColor];
        actionTitleLabel.numberOfLines = 0;
        actionTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        actionTitleLabel.textAlignment =NSTextAlignmentCenter;
        actionTitleLabel.text = NSLocalizedString(@"Choose or take 2 photos", nil);
        [self.scrollView addSubview:actionTitleLabel];
        [actionTitleLabel release];
        
        
        float x = (self.scrollView.center.x-20-self.galleryImageView.frame.size.width);
        float y = self.scrollView.center.y-self.galleryImageView.frame.size.height/2+15;
        
        CGRect imgFrame = CGRectMake(x, y, self.galleryImageView.frame.size.width, self.galleryImageView.frame.size.height);
        
        [self.galleryImageView setFrame:imgFrame];
        
        UILabel *galeryTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(x-10, y+self.galleryImageView.frame.size.height, 100, 20)];
        galeryTitleLabel.textColor = MAIN_THEME_COLOR;
        galeryTitleLabel.font = [UIFont fontWithName:UBUNTU_FONT size:13.0f];
        galeryTitleLabel.backgroundColor = [UIColor clearColor];
        galeryTitleLabel.numberOfLines = 0;
        galeryTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        galeryTitleLabel.textAlignment =NSTextAlignmentCenter;
        galeryTitleLabel.text = NSLocalizedString(@"from gallery", nil);
        [self.scrollView addSubview:galeryTitleLabel];
        [galeryTitleLabel release];
        
        x = self.scrollView.center.x+20;
        y = self.scrollView.center.y-self.cameraImageView.frame.size.height/2+15;
        
        imgFrame = CGRectMake(x, y, self.cameraImageView.frame.size.width, self.cameraImageView.frame.size.height);
        
        [self.cameraImageView setFrame:imgFrame];
        
        UILabel *cameraTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(x, y+self.cameraImageView.frame.size.height, 80, 20)];
        cameraTitleLabel.textColor = MAIN_THEME_COLOR;
        cameraTitleLabel.font = [UIFont fontWithName:UBUNTU_FONT size:13.0f];
        cameraTitleLabel.backgroundColor = [UIColor clearColor];
        cameraTitleLabel.numberOfLines = 0;
        cameraTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cameraTitleLabel.textAlignment =NSTextAlignmentCenter;
        cameraTitleLabel.text = NSLocalizedString(@"new", nil);
        [self.scrollView addSubview:cameraTitleLabel];
        [cameraTitleLabel release];

        
        [self.scrollView addSubview:self.galleryImageView];
        [self.scrollView addSubview:self.cameraImageView];
    }

    
    selectedGender = NotDefined;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.bgImageView = nil;
    self.closeButton = nil;
    self.scrollView = nil;
    self.maleGenderImageView = nil;
    self.femaleGenderImageView = nil;
    self.galleryImageView = nil;
    self.cameraImageView = nil;
    self.smallView = nil;
}

- (void)dealloc
{
    [bgImageView release];
    [closeButton release];
    [scrollView release];
    [maleGenderImageView release];
    [femaleGenderImageView release];
    [galleryImageView release];
    [cameraImageView release];
    [smallView release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions


- (void)onMaleIVTap:(UITapGestureRecognizer *)tapRecognizer
{
    [[LocalyticsSession shared] tagEvent:@"Choosen male gender"];
    
    if (selectedGender == NotDefined){
        [self.maleGenderImageView setImage:[UIImage imageNamed:@"man_selected.png"]];
        selectedGender = Man;
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    }
    else if (selectedGender == Woman){
        selectedGender = Man;
        [self.maleGenderImageView setImage:[UIImage imageNamed:@"man_selected.png"]];
        [self.femaleGenderImageView setImage:[UIImage imageNamed:@"woman_notselected.png"]];
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
        
    }
    
}

- (void)onFemaleIVTap:(UITapGestureRecognizer *)tapRecognizer
{
    [[LocalyticsSession shared] tagEvent:@"Choosen female gender"];
    
    if (selectedGender == NotDefined){
        [self.femaleGenderImageView setImage:[UIImage imageNamed:@"woman_selected.png"]];
        selectedGender = Woman;
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    }
    else if (selectedGender == Man){
        selectedGender = Woman;
        [self.maleGenderImageView setImage:[UIImage imageNamed:@"man_notselected.png"]];
        [self.femaleGenderImageView setImage:[UIImage imageNamed:@"woman_selected.png"]];
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];

    }
    
    
}


-(void) onGalleryIVTap:(UITapGestureRecognizer *)tapRecognizer
{
    [[LocalyticsSession shared] tagEvent:@"Measure with 2 existing photos"];
    
    [self.galleryImageView setImage:[UIImage imageNamed:@"galleryActive.png"]];
    
    if (startingFrom == startingFromMainView){
        if (selectedGender == NotDefined){
            selectedGender = Man;
        }
        
        [[self delegate] startMeasureUsingPhotoSource:UIImagePickerControllerSourceTypePhotoLibrary andSelectedPersonKind:selectedGender];
    }
    else if (startingFrom == startingFromOtherView){
        [[self delegate] startMeasureUsingPhotoSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [self closeView];
    
}
-(void) onCameraIVTap:(UITapGestureRecognizer *)tapRecognizer
{
    [[LocalyticsSession shared] tagEvent:@"Measure with new photos"];
    
    [self.cameraImageView setImage:[UIImage imageNamed:@"cameraActive.png"]];
    
    if (startingFrom == startingFromMainView){
        if (selectedGender == NotDefined){
            selectedGender = Man;
        }
        
        [[self delegate] startMeasureUsingPhotoSource:UIImagePickerControllerSourceTypeCamera andSelectedPersonKind:selectedGender];
    }
    else if (startingFrom == startingFromOtherView){
        [[self delegate] startMeasureUsingPhotoSource:UIImagePickerControllerSourceTypeCamera];
    }
    [self closeView];
}
-(IBAction) onCloseButtonTap{
    [self closeView];
}

#pragma mark - help functions
-(void) closeView
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self view] setAlpha:0.0f];
    }
                     completion:^(BOOL finished) {
                         [[self view ] removeFromSuperview];
                     }];
}


@end
