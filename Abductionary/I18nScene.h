//
//  I18nScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright 2012 DOJO. All rights reserved.
//

#import "CCLayer.h"

@class CCScene;
@class CCMenuItemLabel;

@interface I18nScene : CCLayer {

    CCMenuItemLabel *englishButton;
    CCMenuItemLabel *spanishButton; 
    CCMenuItemLabel *portugueseButton;
}

+(CCScene *) scene;
-(void) setupMenu;
-(void) switchToLanguage:(id) sender;

@end
