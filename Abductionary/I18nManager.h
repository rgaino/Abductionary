//
//  I18nManager.h
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "Constants.h"

@interface I18nManager : NSObject
{
    kLanguage currentLanguage;
}


+(I18nManager *) getInstance;
-(void) setLanguageTo:(kLanguage) languageID;


-(NSString*) getLanguageMenuMessageString;

//Main Menu
-(NSString*) getMainMenuNewGameString;
-(NSString*) getMainMenuSettingsString;
-(NSString*) getMainMenuLeaderboardsString;
-(NSString*) getMainMenuEasyString;
-(NSString*) getMainMenuMediumString;
-(NSString*) getMainMenuHardString;



@end
