//
//  TruckSprite.m
//  Abductionary
//
//  Created by Rafael Gaino on 8/4/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "TruckSprite.h"

@implementation TruckSprite

+(id) truckSpriteForScene:(CCLayer*) scene
{
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"TruckAnimation.pvr.ccz"];
    [scene addChild:spriteSheet z:11];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TruckAnimation.plist"];
    
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0000.png"];
    TruckSprite *truckSprite = [self spriteWithSpriteFrame:frame];
    [spriteSheet addChild:truckSprite z:11];

    [truckSprite setPosition:ccp(1050, -3300)];
	return truckSprite;
}

-(void) runTruckAnimation
{
    NSMutableArray *rollingFrames = [NSMutableArray array];
    
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0000.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0001.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0002.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0003.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0004.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0005.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0006.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0007.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0008.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0009.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0010.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0011.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0012.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0013.png"]];
    [rollingFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"truck_rolling_0014.png"]];

    CCAnimation *rollingAnimation = [CCAnimation animationWithFrames:rollingFrames delay:0.1f];
    
    id rollingAction = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:rollingAnimation restoreOriginalFrame:NO]];
    
    [self runAction:rollingAction];

    CGPoint position = [self position];
    id truckMoveAction = [CCMoveTo actionWithDuration:kTruckAnimationMoveSpeed position:ccp(-700, position.y)];
    
    [self runAction:truckMoveAction];
}

@end
