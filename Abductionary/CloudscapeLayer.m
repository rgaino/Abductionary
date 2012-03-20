//
//  CloudscapeLayer.m
//  Abductionary
//
//  Created by Rafael Gaino on 9/21/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "CloudscapeLayer.h"
#import "cocos2d.h"
#import "Constants.h"
#import "StarSprite.h"


@implementation CloudscapeLayer


- (id)init
{
    self = [super init];
    
    if (self) 
    {
        [self setupSprites];
        [self schedule:@selector(addNewStarSprite) interval:kCreateNewStarSpriteFrequency];
    }
    
    return self;
}

-(void) setupSprites
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

    CCSprite *cloudScapeImage = [CCSprite spriteWithSpriteFrameName:@"cloudScape.png"];
    [cloudScapeImage setPosition:ccp(0, 0)];
    [cloudScapeImage setAnchorPoint:ccp(0,0)];
    [self addChild: cloudScapeImage z:1];
    
}

-(void) addNewStarSprite
{
    StarSprite *newStarSprite = [StarSprite starSprite];
    
    [self addChild:newStarSprite z:2];

    [newStarSprite release];
    
    float speed = arc4random() % 15;
    speed+=1;
    
    id moveStarAction = [CCMoveBy actionWithDuration:speed position:ccp(1500,0)];
    id destroyStarAction = [CCCallFunc actionWithTarget:self selector:@selector(removeStarSprite)];
    
    [newStarSprite runAction: [CCSequence actions:moveStarAction, destroyStarAction, nil]];

}

-(void) removeStarSprite
{    
    for(CCNode *node in [self children]) {
        if( [node isKindOfClass:[StarSprite class]] )
        {
            if([node numberOfRunningActions] == 0) 
            {
                [node removeFromParentAndCleanup:YES];
            }
        }
    }

}

-(void) slowDownAndStop
{
    
    [self unscheduleAllSelectors];
    
    for(CCNode *node in [self children]) {
        if( [node isKindOfClass:[StarSprite class]] )
        {
            [node stopAllActions];
        }
    }
}

@end
