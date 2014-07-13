//
//  types.h
//  EasySize
//
//  Created by Vladimir Smirnov on 11.01.13.
//
//

#ifndef EasySize_types_h
#define EasySize_types_h



#endif

typedef enum
{
    Man = 0,
    Woman = 1,
    Kid = 2,
    NotDefined
    
} PersonKind;

typedef enum
{
    backButtonAction_goToProfiles = 0,
    backButtonAction_goToResults = 1,
    
} backButtonActionType;

typedef enum
{
    saveButtonAction_save = 0,
    saveButtonAction_saveAndStartMeasure = 1,
    
} saveButtonActionType;

typedef enum
{
    standartButton,
    rootButton
    
} backButtonType;

typedef enum
{
    standartEditButton,
    saveAsButton,
    noButton
    
} editButtonType;

typedef enum
{
    main = 0,
    side = 1
    
} pictureMode;

typedef enum
{
    rightSwipe = 0,
    leftSwipe = 1
}
swipeDirectionType;


typedef enum
{
    firstPage = 0,
    lastPage = 1
}
pageType;

typedef enum
{
    usual = 0,
    back = 1
}
barButtonStyle;

typedef enum
{
    general,
    result
}
formType;

typedef enum
{
    cm_system,
    inch_system
}
measureSystemType;

typedef enum
{
    startingFromMainView,
    startingFromOtherView
}
startDialogType;



