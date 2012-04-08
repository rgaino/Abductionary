//
//  I18nScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright 2012 DOJO. All rights reserved.
//

#import "I18nScene.h"
#import "cocos2d.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"

@implementation I18nScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	I18nScene *layer = [I18nScene node];
	[scene addChild:layer];	
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundMainMenuClick];
        [self setIsTouchEnabled:YES];
        [self setupMenu];
    }
    
	return self;
}


-(void) setupMenu
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float xPosition = 570;
    float spacing = 100;
    
    CCMenu *languagesMenu = [CCMenu menuWithItems:nil];
    [languagesMenu setPosition:CGPointZero];
    
    CCLabelTTF *englishLabel = [CCLabelTTF labelWithString:@"ENGLISH" fontName:kCommonFontName fontSize:30];
    [englishLabel setColor:ccc3(162, 209, 73)];
    englishButton = [CCMenuItemLabel itemWithLabel:englishLabel target:self selector:@selector(switchToLanguage:)];
    [englishButton setPosition: ccp(winSize.width/2, xPosition-=spacing)];	
    [englishButton setTag:1];
    [languagesMenu addChild:englishButton];

    CCLabelTTF *spanishLabel = [CCLabelTTF labelWithString:@"ESPAÑOL" fontName:kCommonFontName fontSize:30];
    [spanishLabel setColor:ccc3(162, 209, 73)];
    spanishButton = [CCMenuItemLabel itemWithLabel:spanishLabel target:self selector:@selector(switchToLanguage:)];
    [spanishButton setPosition: ccp(winSize.width/2, xPosition-=spacing)];	
    [spanishButton setTag:2];
    [languagesMenu addChild:spanishButton];

    CCLabelTTF *portugueseLabel = [CCLabelTTF labelWithString:@"PORTUGUÊS" fontName:kCommonFontName fontSize:30];
    [portugueseLabel setColor:ccc3(162, 209, 73)];
    portugueseButton = [CCMenuItemLabel itemWithLabel:portugueseLabel target:self selector:@selector(switchToLanguage:)];
    [portugueseButton setTag:3];
    [portugueseButton setPosition: ccp(winSize.width/2, xPosition-=spacing)];	
    [languagesMenu addChild:portugueseButton];
 
    
    [self addChild:languagesMenu z:2];  
}


-(void) switchToLanguage:(id) sender
{
    CCMenuItemLabel *senderButton = (CCMenuItemLabel*) sender;
    NSLog(@"Switching language to %d", senderButton.tag);
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick];
}


-(void) dealloc
{
    CCLOG(@"Dealloc IntroAnimationScene: %@", self); 
    
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundMainMenuClick];
    
    [super dealloc];
}

@end
