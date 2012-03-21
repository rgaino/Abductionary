//
//  FeathersSprite.m
//  Abductionary
//
//  Created by Rafael Gaino on 8/26/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "FeathersSprite.h"

@implementation FeathersSprite


+(id) feathersSpriteForScene:(CCLayer*) scene
{
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"FeathersAnimation.pvr.ccz"];
    [scene addChild:spriteSheet z:10];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"FeathersAnimation.plist"];
    
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"feathers_0022.png"];
    FeathersSprite *feathersSprite = [self spriteWithSpriteFrame:frame];
    [spriteSheet addChild:feathersSprite z:11];
    
    [feathersSprite setPosition:ccp(342, -3300)];
	return feathersSprite;
}

-(void) runFeathersAnimation
{
    NSMutableArray *animationFrames = [NSMutableArray array];
    
    for(int i=22; i<=90; i++) 
    {
        NSString *fileName = [NSString stringWithFormat:@"feathers_%04d.png", i];
        [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName]];
    }
    
    
    CCAnimation *feathersAnimation = [CCAnimation animationWithSpriteFrames:animationFrames delay:0.04f];
    
    id feathersAction = [CCAnimate actionWithAnimation:feathersAnimation];
    
    
    [self runAction:feathersAction];
}

@end
