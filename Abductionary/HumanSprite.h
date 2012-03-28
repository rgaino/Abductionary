//
//  HumanSprite.h
//  Abductionary
//
//  Created by Rafael Gaino on 8/1/11.
//  Copyright 2011 DOJO. All rights reserved.
//


@class CCSpriteBatchNode;
@class CCSprite;
@class CCLayer;

@interface HumanSprite : NSObject
{
    CCSpriteBatchNode *spriteSheet;
    CCSprite *_humanSprite;
    int humanId;
}


-(void) humanSpriteForScene:(CCLayer*) scene;
-(CCSprite*) humanSprite;
-(void) runDropAndFallAnimation;
-(void) fallLoop;
-(void) blinkAnimation;
-(void) cleanUp;
-(void) hide;
-(int) getHumanId;
-(void) makeHumanFloat;

@end
