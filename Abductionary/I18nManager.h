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
    NSDictionary *languageDictionary;
}


+(I18nManager *) getInstance;
-(void) setLanguageTo:(NSString*) languageID;
-(NSString*) getLocalizedStringFor:(NSString*) messageString;
-(NSString*) getScrabbleAlphabet;



@end
