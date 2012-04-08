//
//  I18nScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright 2012 DOJO. All rights reserved.
//

#import "CCLayer.h"

@class CCScene;
@class CCLabelTTF;

@interface I18nScene : CCLayer 
{
    CCLabelTTF *messageLabel;
}

+(CCScene *) scene;
-(void) setupMenu;
-(void) switchToLanguage:(id) sender;
-(void) okButtonPressed;

@end
