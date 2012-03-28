//
//  HumanSprite.m
//  Abductionary
//
//  Created by Rafael Gaino on 8/1/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "HumanSprite.h"
#import "cocos2d.h"
#import "Constants.h"
#import "HumanSpriteRandomizer.h"
#import "SimpleAudioEngine.h"

@implementation HumanSprite

-(void) humanSpriteForScene:(CCLayer*) scene
{

    HumanSpriteRandomizer *humanSpriteRandomizer = [HumanSpriteRandomizer getInstance];
    humanId = [humanSpriteRandomizer getNextHumanId];
    
    NSString *spriteSheetFileName = [NSString stringWithFormat:@"HumanAnimations_%03d.plist", humanId];
    NSLog(@"Rendering human spritesheet %@", spriteSheetFileName);
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:spriteSheetFileName];
//    spriteSheet = [CCSpriteBatchNode batchNodeWithFile: [NSString stringWithFormat:@"HumanAnimations_%03d.pvr.ccz", humanId]];
//    [scene addChild:spriteSheet z:10];
    
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_standing.png", humanId]];
    
    _humanSprite = [CCSprite spriteWithSpriteFrame:frame];
    [_humanSprite setPosition:ccp(390, -400)];
    [scene addChild:_humanSprite z:10];
    
    id beamHumanUp = [CCMoveTo actionWithDuration:2.0f position:ccp(390, 400)];
    id beamHumanUpEase = [CCEaseSineOut actionWithAction:beamHumanUp];
    
    id humanCallback = [CCCallFuncN actionWithTarget:self selector:@selector(makeHumanFloat)];
        
    id humanSequence = [CCSequence actionOne:beamHumanUpEase two:humanCallback];
    
    [_humanSprite runAction:humanSequence];

    NSString *humanFallingSound = [NSString stringWithFormat:kHumanFallingSound, humanId];
    [[SimpleAudioEngine sharedEngine] preloadEffect:humanFallingSound];    

    return ;
}

-(void) makeHumanFloat 
{
    float humanFloatOffset = 10.0f;
    float humanFloatInterval = 2.0f;
    
    id floatHumanUp = [CCMoveBy actionWithDuration:humanFloatInterval position:ccp(0, humanFloatOffset)];
    id floatHumanDown = [CCMoveBy actionWithDuration:humanFloatInterval position:ccp(0, humanFloatOffset*-1)];
    
    id floatEaseUp = [CCEaseSineInOut actionWithAction:floatHumanUp];
    id floatEaseDown = [CCEaseSineInOut actionWithAction:floatHumanDown];
    
    id floatSequence = [CCSequence actionOne:floatEaseDown two:floatEaseUp];
    id floatForever = [CCRepeatForever actionWithAction:floatSequence];
    
    [_humanSprite runAction:floatForever];
}


-(CCSprite*) humanSprite 
{
    return _humanSprite;
}

-(int) getHumanId
{
    return humanId;
}

-(void) hide
{
    [_humanSprite setVisible:NO];
}

-(void) runDropAndFallAnimation
{
    
    
    NSMutableArray *dropFrames = [NSMutableArray array];
    
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_001.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_002.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_003.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_004.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_005.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_006.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_007.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_008.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_009.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_010.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_011.png", humanId]]];
    [dropFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_drop_012.png", humanId]]];

    CCAnimation *dropAnimation = [CCAnimation animationWithSpriteFrames:dropFrames delay:0.05f];

    id delayDropHuman = [CCDelayTime actionWithDuration:1.0f];
    id dropAction = [CCAnimate actionWithAnimation:dropAnimation];
    
    id sequence =[CCSequence actions:delayDropHuman, dropAction, [CCCallFuncN actionWithTarget:self selector:@selector(fallLoop)], nil];

    [_humanSprite runAction:sequence];
}

-(void) fallLoop
{
    
    NSMutableArray *fallFrames = [NSMutableArray array];
    
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_001.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_002.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_003.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_004.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_005.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_006.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_007.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_008.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_009.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_010.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_011.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_012.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_013.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_014.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_015.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_016.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_015.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_014.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_013.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_012.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_011.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_010.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_009.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_008.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_007.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_006.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_005.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_004.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_003.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_002.png", humanId]]];
    [fallFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_fall_001.png", humanId]]];
    
    CCAnimation *fallAnimation = [CCAnimation animationWithSpriteFrames:fallFrames delay:0.02f];

    id fallAction = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:fallAnimation]];
    

    [_humanSprite runAction:fallAction];
    
}

-(void) blinkAnimation
{
    NSMutableArray *blinkFrames = [NSMutableArray array];
    
    [blinkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_blink_001.png", humanId]]];
    [blinkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_blink_002.png", humanId]]];
    [blinkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_blink_001.png", humanId]]];
    [blinkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"human_%03d_standing.png", humanId]]];
    
    CCAnimation *blinkAnimation = [CCAnimation animationWithSpriteFrames:blinkFrames delay:0.08f];
    
    id blinkAction = [CCAnimate actionWithAnimation:blinkAnimation];
    
    [_humanSprite runAction:blinkAction];
}

-(void) cleanUp
{
    NSString *humanFallingSound = [NSString stringWithFormat:kHumanFallingSound, humanId];
    [[SimpleAudioEngine sharedEngine] unloadEffect:humanFallingSound];    

    [_humanSprite removeFromParentAndCleanup:YES];
    [spriteSheet removeFromParentAndCleanup:YES];

    NSString *spriteSheetFileName = [NSString stringWithFormat:@"HumanAnimations_%03d.plist", humanId];
    NSString *textureFileName = [NSString stringWithFormat:@"HumanAnimations_%03d.pvr.ccz", humanId];
    NSLog(@"Removing human spritesheet %@ and texture %@", spriteSheetFileName, textureFileName);
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:spriteSheetFileName];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:textureFileName];
}

-(void) dealloc
{
    NSLog(@"On dealloc for humanSprite");
    [super dealloc];
}

@end


