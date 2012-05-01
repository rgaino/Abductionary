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
#import "I18nManager.h"

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
    
    alienShipLayer = [[CCLayer alloc] init];
    
    alienShip = [CCSprite spriteWithSpriteFrameName:@"alienShip.png"];
    [alienShip setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2)];
    [alienShipLayer addChild:alienShip z:2];

    shipParticles = [CCParticleSystemQuad particleWithFile:@"alienShipParticles.plist"];
    [shipParticles setPosition:ccp(alienShip.position.x, alienShip.position.y-30)];
    [shipParticles setPosVar:ccp(60,20)];
    [alienShipLayer addChild:shipParticles z:1];
    
    
    [self addChild:alienShipLayer z:1];
    
    
    descriptionWindowLayer = [[CCLayer alloc] init];    
    
    descriptionWindow = [CCSprite spriteWithSpriteFrameName:@"descriptionWindow.png"];
    [descriptionWindow setPosition:ccp(screenSize.width/2, 0 - screenSize.height/2)];
    [descriptionWindowLayer addChild:descriptionWindow z:2];

    descriptionWindowParticles = [CCParticleSystemQuad particleWithFile:@"alienShipParticles.plist"];
    [descriptionWindowParticles setPosVar:ccp(140,20)];
    [descriptionWindowParticles setPosition:ccp(descriptionWindow.position.x, descriptionWindow.position.y-180)];
    [descriptionWindowLayer addChild:descriptionWindowParticles z:1];
    
    
    float fontSize = 25;
    CGSize maxSize = { 530, 3000 };
    NSString *message_1 = [[I18nManager getInstance] getLocalizedStringFor:@"IntroMessageLine1"];
    NSString *message_2 = [[I18nManager getInstance] getLocalizedStringFor:@"IntroMessageLine2"];
    

    float shadowOffset = 2.0f;
    CGSize actualSize_1 = [message_1 sizeWithFont:[UIFont fontWithName:kCommonFontName size:fontSize] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize containerSize_1 = { actualSize_1.width, actualSize_1.height };
    
    CCLabelTTF *descriptionMessage_1 = [CCLabelTTF labelWithString:message_1 dimensions:containerSize_1 alignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:fontSize];
    [descriptionMessage_1 setColor:ccc3(107, 205, 255)];
    [descriptionMessage_1 setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2 - descriptionWindow.contentSize.height/2 + 45)];
    [descriptionWindowLayer addChild:descriptionMessage_1 z:3];

    CCLabelTTF *shadow_1 = [CCLabelTTF labelWithString:message_1 dimensions:containerSize_1 alignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:fontSize];
    [shadow_1 setColor:ccc3(0, 0, 0)];
    [shadow_1 setOpacity:191];
    [shadow_1 setPosition:ccp(descriptionMessage_1.position.x+shadowOffset, descriptionMessage_1.position.y-shadowOffset)];
    [descriptionWindowLayer addChild:shadow_1 z:2];


    CGSize actualSize_2 = [message_2 sizeWithFont:[UIFont fontWithName:kCommonFontName size:fontSize] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize containerSize_2 = { actualSize_2.width, actualSize_2.height };
    
    CCLabelTTF *descriptionMessage_2 = [CCLabelTTF labelWithString:message_2 dimensions:containerSize_2 alignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:fontSize];
    [descriptionMessage_2 setColor:ccc3(107, 205, 255)];
    [descriptionMessage_2 setPosition:ccp(screenSize.width/2, alienShip.contentSize.height/-2 - descriptionWindow.contentSize.height/2 - 110)];
    [descriptionWindowLayer addChild:descriptionMessage_2 z:3];
                                        
    CCLabelTTF *shadow_2 = [CCLabelTTF labelWithString:message_2 dimensions:containerSize_2 alignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:fontSize];
    [shadow_2 setColor:ccc3(0, 0, 0)];
    [shadow_2 setOpacity:191];
    [shadow_2 setPosition:ccp(descriptionMessage_2.position.x+shadowOffset, descriptionMessage_2.position.y-shadowOffset)];
    [descriptionWindowLayer addChild:shadow_2 z:2];
    
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
    [alienShipLayer runAction:alienSequence];
    
    //description window moves up
    id descriptionWindowMoveUp = [CCMoveBy actionWithDuration:3.5f position:ccp(0, screenSize.height-30)];
    id descriptionWindowEaseOut = [CCEaseSineOut actionWithAction:descriptionWindowMoveUp];
    id descriptionWindowFloatCallBack = [CCCallFuncN actionWithTarget:self selector:@selector(descriptionWindowFloatForever)];
    [descriptionWindowLayer runAction:[CCSequence actionOne:descriptionWindowEaseOut two:descriptionWindowFloatCallBack]];
    
    //screen follows alien
    id delayScreenPansUp = [CCDelayTime actionWithDuration:1.0];
    id screenPansUp = [CCMoveBy actionWithDuration:20.0f position:ccp(0, -232)];    
    id screenPansUpEaseOut = [CCEaseSineOut actionWithAction:screenPansUp];
    id panScreenSequence = [CCSequence actions:delayScreenPansUp, screenPansUpEaseOut, nil];
    [introBackgroundBottom runAction:[[panScreenSequence copy] autorelease]];
    [introBackgroundTop runAction:panScreenSequence];
    
    
    [self performSelector:@selector(showTapToToContinue) withObject:nil afterDelay:15.0f];
}

-(void) alienFloatForever
{
    //alien float
    float alienFloatOffset = 20.0f;
    float alienFloatInterval = 2.0f;
    
    id floatAlienUp = [CCMoveBy actionWithDuration:alienFloatInterval position:ccp(0, alienFloatOffset)];
    id floatAlienDown = [CCMoveBy actionWithDuration:alienFloatInterval position:ccp(0, alienFloatOffset*-1)];
    
    id floatEaseUp = [CCEaseSineInOut actionWithAction:floatAlienUp];
    id floatEaseDown = [CCEaseSineInOut actionWithAction:floatAlienDown];
    
    id floatSequence = [CCSequence actionOne:floatEaseDown two:floatEaseUp];
    id floatForever = [CCRepeatForever actionWithAction:floatSequence];
    
    [alienShipLayer runAction:floatForever];
}

-(void) descriptionWindowFloatForever
{
    //screen float
    float screenFloatOffset = 20.0f;
    float screenFloatInterval = 2.0f;
    
    id floatScreenUp = [CCMoveBy actionWithDuration:screenFloatInterval position:ccp(0, screenFloatOffset)];
    id floatScreenDown = [CCMoveBy actionWithDuration:screenFloatInterval position:ccp(0, screenFloatOffset*-1)];
    
    id floatEaseUp = [CCEaseSineInOut actionWithAction:floatScreenUp];
    id floatEaseDown = [CCEaseSineInOut actionWithAction:floatScreenDown];
    
    id floatSequence = [CCSequence actionOne:floatEaseDown two:floatEaseUp];
    id floatForever = [CCRepeatForever actionWithAction:floatSequence];
    
    [descriptionWindowLayer runAction:floatForever];
}

-(void) alienFlyAway
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] stopEffect:shipSoundID];
    [[SimpleAudioEngine sharedEngine] playEffect:@"shipGoing.mp3"];

    [alienShipLayer stopAllActions];
    id alienMoveOut = [CCMoveBy actionWithDuration:1.0f position:ccp(100,100)];    
    id alienShrink = [CCScaleBy actionWithDuration:1.0f scale:0.0f];
    id alienFlyAway = [CCSpawn actionOne:alienMoveOut two:alienShrink];
    [alienShip runAction:alienFlyAway];
    
    [shipParticles setVisible:NO];
    
    [self performSelector:@selector(moveToMainMenu) withObject:nil afterDelay:1.0f];
    
}

-(void) showTapToToContinue
{
    CCLabelTTF *tapToContinue = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Tap to Continue"] fontName:kCommonFontName fontSize:20];
    [tapToContinue setColor:ccc3(200, 200, 200)];
    [tapToContinue setPosition:ccp(900, 30)];
    [tapToContinue setOpacity:0];
    [self addChild:tapToContinue z:4];
    
    id fadeInMessage = [CCFadeIn actionWithDuration:0.5f];
    [tapToContinue runAction:fadeInMessage];

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


    [alienShipLayer release];
    [descriptionWindowLayer release];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"introAnimation.plist"];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];

    [super dealloc];
}

@end
