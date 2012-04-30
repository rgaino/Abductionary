//
//  IntroAnimationScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/28/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"

@interface IntroAnimationScene : CCLayer 
{
    CCSprite *introBackgroundBottom;
    CCSprite *introBackgroundTop;
    CCSprite *alienShip;
    CCSprite *descriptionWindow;
    
    CCLayer *descriptionWindowLayer;
    CCLayer *alienShipLayer;
    
    CCParticleSystemQuad *shipParticles;
    CCParticleSystemQuad *descriptionWindowParticles;

    unsigned int shipSoundID;
}

+(CCScene *) scene;
-(void) setupSprites;
-(void) kickOffAnimations;
-(void) alienFloatForever;
-(void) moveToMainMenu;
-(void) descriptionWindowFloatForever;
-(void) showTapToToContinue;

@end
