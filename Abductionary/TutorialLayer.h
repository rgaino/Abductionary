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
    CCSprite *closeButton;
    CCSprite *tutorialMessage;
    CCLabelTTF *tutorialsOnOffLabel;
}

-(id)initWithTutorialNumber:(int) _tutorialNumber;
-(void) setupTutorial;
-(void) showTutorial;
-(void) turnTutorialsOnOff;
-(void) closeTutorial;

@end
