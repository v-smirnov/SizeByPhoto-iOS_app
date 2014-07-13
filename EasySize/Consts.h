//
//  Consts.h
//  EasySize
//
//  Created by Vladimir Smirnov on 17.01.13.
//
//

#ifndef EasySize_Consts_h
#define EasySize_Consts_h
#endif


//objects
#define UNDERWEAR           @"Underwear"
#define JEANS               @"Jeans"
#define T_SHIRT             @"T-shirts"
#define SHIRT               @"Shirts"
#define COATS_JACKETS       @"Coats & Jackets"
#define RING                @"Ring"
#define SHOES               @"Shoes"
#define GLOVES              @"Gloves"
#define SKIRT               @"Skirts"
#define DRESS               @"Dresses"
#define BRAS                @"Bras"
#define SWEATERS_HOODIES    @"Sweaters & Hoodies"
#define SWIMWEAR            @"Swimwear"
#define SHORTS              @"Shorts"
#define TOPS                @"Tops"
#define PANTS               @"Pants"
#define BRIEFS              @"Briefs"
#define SLEEPWEAR           @"Sleepwear"
#define SWIMWEAR_B          @"Swimwear bottoms"
#define SWIMWEAR_T          @"Swimwear tops"

//measure params
#define CHEST       @"Chest"
#define WAIST       @"Waist"
#define HIPS        @"Hips"
#define UNDER_CHEST @"Under chest"
#define FOOT        @"Foot"
#define INSIDE_LEG  @"Inside leg"

//profile data
#define PROFILE_SEARCHING_KEY @"searchingKey"
#define PROFILE_NAME          @"name"
#define PROFILE_SURNAME       @"surname"
#define PROFILE_PHOTO         @"photo"
#define PROFILE_AGE           @"age"
#define PROFILE_GENDER        @"sex"
#define KEY_FOR_TEMP_PROFILE  @"Name_Surname"
#define PROFILE_IS_FAVORITE   @"favorite"
#define MAIN_USER_PROFILE     @"main_profile"


//person kinds
#define PK_MAN   @"Man"
#define PK_WOMAN @"Woman"


//profile's changes saving result
#define PROFILE_SAVE_RESULT_OK 1
#define PROFILE_SAVE_RESULT_PROFILE_WITH_GIVEN_KEY_ALREADY_EXIST 2
#define PROFILE_SAVE_RESULT_ERROR 0

#define NUMBER_OF_SIZE_SYSTEMS 5

//flags that show found size for choosen stuff or not
#define SIZE_UNDEFINED -1
#define SIZE_DEFINED 1

//colors
#define MAIN_THEME_COLOR [UIColor colorWithRed:0.5961f green:0.4196f blue:0.6745f alpha:1.0f]
#define PHOTO_TIPS_BG_COLOR [UIColor colorWithRed:0.7529f green:0.7529f blue:0.7529f alpha:1.0f]
#define GRAY_BACKGROUND_COLOR [UIColor colorWithRed:0.765f green:0.765f blue:0.765f alpha:0.85f]

//fonts
#define BAR_BUTTON_FONT @"Ubuntu"
#define NAV_BAR_FONT @"Ubuntu-Medium"
#define SIZE_LABEL_FONT @"Roboto-Bold"
#define SIZE_LABEL_TITLE_FONT @"Ubuntu"
#define PROFILE_NAME_FONT @"Ubuntu"
#define BUTTON_FONT @"Ubuntu"
#define FEEDBACK_LABEL_FONT @"Ubuntu-Light"
#define FEEDBACK_TEXT_FONT @"Ubuntu-Italic"
#define MEASURE_VALUE_TEXT_FONT @"Ubuntu-Italic"
//font for choosinfg stuff table
#define TABLE_STUFF_FONT @"Ubuntu"
#define SEGMENTED_CONTROL_FONT @"Ubuntu"
#define EDIT_PROFILE_TEXT_FIELD_FONT @"Ubuntu"
#define SLIDER_TEXT_FONT @"Ubuntu"
#define TIP_LABEL_FONT @"Ubuntu"

#define UBUNTU_FONT @"Ubuntu"
#define UBUNTU_MEDIUM_FONT @"Ubuntu-Medium"
//fonts-sizes
#define BAR_BUTTON_FONT_SIZE 0.0f
#define NAV_BAR_FONT_SIZE 18.0f
#define SIZE_LABEL_FONT_SIZE 13.0f
#define SIZE_LABEL_TITLE_FONT_SIZE 13.0f
#define PROFILE_NAME_FONT_SIZE 18.0f
#define BUTTON_FONT_SIZE 16.0f
#define FEEDBACK_LABEL_FONT_SIZE 13.0f
#define FEEDBACK_TEXT_FONT_SIZE 16.0f
#define PHOTO_SCREEN_BUTTON_FONT_SIZE 12.0f
#define MEASURE_VALUE_TEXT_FONT_SIZE 14.0f
#define TABLE_STUFF_FONT_SIZE 16.0f
#define SEGMENTED_CONTROL_FONT_SIZE 12.0f
#define EDIT_PROFILE_TEXT_FIELD_FONT_SIZE 14.0f
#define SLIDER_TEXT_FONT_SIZE 12.0f
#define TIP_LABEL_FONT_SIZE 16.0f
#define RATE_LABEL_FONT_SIZE 18.0f
#define FONT_SIZE_12 12.0f
#define FONT_SIZE_14 14.0f

//user defaults
#define NUMBER_OF_APP_LAUNCHES_FOR_RATE_POPUP @"NumberOfAppLaunchesForRatePopup"
#define NUMBER_OF_APP_LAUNCHES_TO_SHOW_RATE_POPUP 20
#define USER_UNLOCK_ALL_STUFF @"userUnlockAllStuff"
#define NUMBER_OF_TIPS_LAUNCHES @"numberOfTipsLaunches"

//undefined sizes
#define BRAND_DOES_NOT_HAVE_ITEM_TEXT @"This brand does not have this item"
#define BRAND_DOES_NOT_HAVE_SIZE_TEXT @"This brand does not have this size"

//motion data
#define FORWARD_D 0
#define BACK_D 1
