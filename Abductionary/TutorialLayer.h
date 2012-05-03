//
//  TutorialLayer.h
//  Abductionary
//
//  Created by Rafael Gaino on 1/23/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "cocos2d.h"

@interface TutorialLayer : CCLayer
{
    int tutorialNumber;
    int part;
    float tutorialFontSize;
    
    CCSprite *closeButton;
    CCSprite *tutorialMessageSprite;
    CCLabelTTF *tutorialsOnOffLabel;
    CCLabelTTF *tutorialMessageLabel;
    CCLabelTTF *tutorialMessageLabel_2;
    CCLabelTTF *tutorialMessageLabel_3;
}

-(id)initWithTutorialNumber:(int) _tutorialNumber;
-(void) setupTutorial;
-(void) showTutorial;
-(void) turnTutorialsOnOff;
-(void) closeTutorial;

@end
