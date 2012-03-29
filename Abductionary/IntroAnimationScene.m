//
//  IntroAnimationScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 3/28/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "IntroAnimationScene.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"

@implementation IntroAnimationScene


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroAnimationScene *layer = [IntroAnimationScene node];
	[scene addChild:layer];	
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
    {
        [self setIsTouchEnabled:YES];
        [self setupSprites];
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"introMusic.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"introMusic.mp3" loop:YES];
        
        shipSoundID = [[SimpleAudioEngine sharedEngine] playEffect:@"ship.mp3" pitch:1.0f pan:0.0f gain:1.0f];
        alSourcei(shipSoundID, AL_LOOPING, 1);

        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shipGoing.mp3"];
        
        [self kickOffAnimations];
    }
    
	return self;
}

-(void) setupSprites
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"introAnimation.plist"];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    introBackgroundBottom = [CCSprite spriteWithSpriteFrameName:@"introBackgroundBottom.png"];
    [introBackgroundBottom setAnchorPoint:ccp(0,0)];
    [introBackgroundBottom setPosition:ccp(0,0)];
    [self addChild:introBackgroundBottom z:0];
   
    introBackgroundTop = [CCSprite spriteWithSpriteFrameName:@"introBackgroundTop.png"];
    [introBackgroundTop setAnchorPoint:ccp(0,0)];
    [introBackgroundTop setPosition:ccp(0, screenSize.height)];
    [self addChild:introBackgroundTop z:0];
    
    alienShip = [CCSprite spriteWithSpriteFrameName:@"alienShip.png"];
    [alienShip setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2)];
    [self addChild:alienShip z:1];
    
    descriptionWindowLayer = [[CCLayer alloc] init];
    
    
    descriptionWindow = [CCSprite spriteWithSpriteFrameName:@"descriptionWindow.png"];
    [descriptionWindow setPosition:ccp(screenSize.width/2, 0 - screenSize.height/2)];
    [descriptionWindowLayer addChild:descriptionWindow z:1];
    
    descriptionBreak_1 = [CCSprite spriteWithSpriteFrameName:@"descriptionBreak_1.png"];
    [descriptionBreak_1 setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2 - descriptionWindow.contentSize.height/2 + 45)];
    [descriptionBreak_1 setOpacity:0.0f];
    [descriptionWindowLayer addChild:descriptionBreak_1 z:1];

    descriptionBreak_2 = [CCSprite spriteWithSpriteFrameName:@"descriptionBreak_2.png"];
    [descriptionBreak_2 setOpacity:0.0f];
    [descriptionBreak_2 setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2 - descriptionWindow.contentSize.height/2 - 110)];
    [descriptionWindowLayer addChild:descriptionBreak_2 z:1];

    descriptionBreak_3 = [CCSprite spriteWithSpriteFrameName:@"descriptionBreak_3.png"];
    [descriptionBreak_3 setOpacity:0.0f];
    [descriptionBreak_3 setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2+230 - descriptionWindow.contentSize.height/2 - 340)];
    [descriptionWindowLayer addChild:descriptionBreak_3 z:1];

    [self addChild:descriptionWindowLayer z:1];
}

-(void) kickOffAnimations
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    //alien move up
    id alienMoveUp = [CCMoveBy actionWithDuration:3.0f position:ccp(0, screenSize.height)];
    id alienMoveUpEaseOut = [CCEaseSineOut actionWithAction:alienMoveUp];
    id alienFloatCallBack = [CCCallFuncN actionWithTarget:self selector:@selector(alienFloatForever)];
    id alienSequence = [CCSequence actionOne:alienMoveUpEaseOut two:alienFloatCallBack];
    [alienShip runAction:alienSequence];
    
    //description window moves up
    id descriptionWindowMoveUp = [CCMoveBy actionWithDuration:3.0f position:ccp(0, screenSize.height-30)];
    id descriptionWindowEaseOut = [CCEaseSineOut actionWithAction:descriptionWindowMoveUp];
    [descriptionWindowLayer runAction:descriptionWindowEaseOut];
    
    //screen follows alien
    id delayScreenPansUp = [CCDelayTime actionWithDuration:1.0];
    id screenPansUp = [CCMoveBy actionWithDuration:10.0f position:ccp(0, -232)];    
    id panScreenSequence = [CCSequence actionOne:delayScreenPansUp two:screenPansUp];
    [introBackgroundBottom runAction:[[panScreenSequence copy] autorelease]];
    [introBackgroundTop runAction:panScreenSequence];
    
    //fade-in words
    id delayFadeInWords = [CCDelayTime actionWithDuration:4.0f];
    id fadeInWords = [CCCallFuncN actionWithTarget:self selector:@selector(fadeInWords)];
    [descriptionWindowLayer runAction:[CCSequence actionOne:delayFadeInWords two:fadeInWords]];
}

-(void) alienFloatForever
{
    //alien float
    float alienFloatOffset = 10.0f;
    float alienFloatInterval = 2.0f;
    
    id floatAlienUp = [CCMoveBy actionWithDuration:alienFloatInterval position:ccp(0, alienFloatOffset)];
    id floatAlienDown = [CCMoveBy actionWithDuration:alienFloatInterval position:ccp(0, alienFloatOffset*-1)];
    
    id floatEaseUp = [CCEaseSineInOut actionWithAction:floatAlienUp];
    id floatEaseDown = [CCEaseSineInOut actionWithAction:floatAlienDown];
    
    id floatSequence = [CCSequence actionOne:floatEaseDown two:floatEaseUp];
    id floatForever = [CCRepeatForever actionWithAction:floatSequence];
    
    [alienShip runAction:floatForever];
}

-(void) fadeInWords
{
    id fadeIn_1 = [CCFadeIn actionWithDuration:0.5f];

    id delay_2 = [CCDelayTime actionWithDuration:2.0];
    id fadeIn_2 = [CCFadeIn actionWithDuration:0.5f];
    id sequence_2 = [CCSequence actionOne:delay_2 two:fadeIn_2];
    
    id delay_3 = [CCDelayTime actionWithDuration:5.0];
    id fadeIn_3 = [CCFadeIn actionWithDuration:0.5f];
    id sequence_3 = [CCSequence actionOne:delay_3 two:fadeIn_3];
    
    [descriptionBreak_1 runAction:fadeIn_1];
    [descriptionBreak_2 runAction:sequence_2];
    [descriptionBreak_3 runAction:sequence_3];
}

-(void) alienFlyAway
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] stopEffect:shipSoundID];
    [[SimpleAudioEngine sharedEngine] playEffect:@"shipGoing.mp3"];

    id alienMoveOut = [CCMoveBy actionWithDuration:1.0f position:ccp(100,100)];    
    id alienShrink = [CCScaleBy actionWithDuration:1.0f scale:0.0f];
    id alienFlyAway = [CCSpawn actionOne:alienMoveOut two:alienShrink];
    [alienShip runAction:alienFlyAway];

    [self performSelector:@selector(moveToMainMenu) withObject:nil afterDelay:1.5f];
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
//    [self moveToMainMenu];
    [self alienFlyAway];

}

-(void) moveToMainMenu
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuScene scene]]];
}

-(void) dealloc
{
    CCLOG(@"Dealloc IntroAnimationScene: %@", self); 
    
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"shipGoing.mp3"];
    [[SimpleAudioEngine sharedEngine] unloadEffect:@"ship.mp3"];


    [descriptionWindowLayer release];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"introAnimation.plist"];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];

    [super dealloc];
}

@end
