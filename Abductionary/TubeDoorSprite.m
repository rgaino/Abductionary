//
//  TubeDoorSprite.m
//  Abductionary
//
//  Created by Rafael Gaino on 1/20/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "TubeDoorSprite.h"
#import "cocos2d.h"

@implementation TubeDoorSprite

-(void) tubeDoorSpriteForScene:(CCLayer*) scene
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"humanTube.plist"];

    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_01.png"];
    _tubeDoorSprite = [CCSprite spriteWithSpriteFrame:frame];
    [_tubeDoorSprite setPosition:ccp(385, 382)];
    [_tubeDoorSprite setVisible:NO];
    [scene addChild:_tubeDoorSprite z:12];
    
    return;
}

-(id) closeAction
{
    
    NSMutableArray *closeAnimFrames = [NSMutableArray array];
    
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_01.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_03.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_05.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_07.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_09.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_11.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_13.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_15.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_17.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_19.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_21.png"]];
    [closeAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorClose_23.png"]];
    
    CCAnimation *closeAnimation = [CCAnimation animationWithFrames:closeAnimFrames delay:0.07f];
    
    id closeAction = [CCAnimate actionWithAnimation:closeAnimation restoreOriginalFrame:NO];

    return closeAction;
}

-(id) lightUpAction 
{
    NSMutableArray *lightUpAnimFrames = [NSMutableArray array];
    
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_01.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_02.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_03.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_04.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_05.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_06.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_07.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_08.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_09.png"]];
    [lightUpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorLight_10.png"]];

    
    CCAnimation *lightUpAnimation = [CCAnimation animationWithFrames:lightUpAnimFrames delay:0.04f];
    
    id lightUpAction = [CCAnimate actionWithAnimation:lightUpAnimation restoreOriginalFrame:NO];

    return lightUpAction;
}

-(id) openAction 
{
    NSMutableArray *openAnimFrames = [NSMutableArray array];
    
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_01.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_03.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_05.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_07.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_09.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_11.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_13.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_15.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_17.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_19.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_21.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_23.png"]];
    [openAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"tubeDoorOpen_24.png"]];
    
    CCAnimation *openAnimation = [CCAnimation animationWithFrames:openAnimFrames delay:0.07f];
    
    id openAction = [CCAnimate actionWithAnimation:openAnimation restoreOriginalFrame:NO];

    return openAction;
}

-(void) show
{
    [_tubeDoorSprite setVisible:YES];
}

-(void) hide
{
    [_tubeDoorSprite setVisible:NO];
}

-(void) runAnimation
{
    id showAction = [CCCallFunc actionWithTarget:self selector:@selector(show)];
    id hideAction = [CCCallFunc actionWithTarget:self selector:@selector(hide)];
    id animationSequence = [CCSequence actions:showAction, [self closeAction], [self lightUpAction], [self openAction], hideAction, nil];
    
    [_tubeDoorSprite runAction:animationSequence];
}

-(void) runCloseAnimation
{   
    id showAction = [CCCallFunc actionWithTarget:self selector:@selector(show)];
    
    id animationSequence = [CCSequence actions:showAction, [self closeAction], [self lightUpAction], nil];
  
    [_tubeDoorSprite runAction:animationSequence];
}

-(void) runOpenAnimation
{   
    id hideAction = [CCCallFunc actionWithTarget:self selector:@selector(hide)];
    
    id animationSequence = [CCSequence actions:[self openAction], hideAction, nil];
    
    [_tubeDoorSprite runAction:animationSequence];
}

-(void) cleanUp
{
    NSLog(@"on TubeDoorSprite cleanup");
    [_tubeDoorSprite removeFromParentAndCleanup:YES];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"humanTube.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"humanTube.pvr.ccz"];
}

-(void) dealloc
{
    NSLog(@"on TubeDoorSprite dealloc");
    [self cleanUp];
    [super dealloc];
}

@end
