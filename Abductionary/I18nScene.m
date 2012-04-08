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
#import "IntroAnimationScene.h"
#import "I18nManager.h"

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
    float xPosition = 700;
    float spacing = 100;
    
    CCMenu *languagesMenu = [CCMenu menuWithItems:nil];
    [languagesMenu setPosition:CGPointZero];
    
    CCLabelTTF *englishLabel = [CCLabelTTF labelWithString:@"ENGLISH" fontName:kCommonFontName fontSize:30];
    [englishLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *englishButton = [CCMenuItemLabel itemWithLabel:englishLabel target:self selector:@selector(switchToLanguage:)];
    [englishButton setPosition: ccp(winSize.width/2, xPosition-=spacing)];	
    [englishButton setTag:kLanguageEnglish];
    [languagesMenu addChild:englishButton];

    CCLabelTTF *spanishLabel = [CCLabelTTF labelWithString:@"ESPAÑOL" fontName:kCommonFontName fontSize:30];
    [spanishLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *spanishButton = [CCMenuItemLabel itemWithLabel:spanishLabel target:self selector:@selector(switchToLanguage:)];
    [spanishButton setPosition: ccp(winSize.width/2, xPosition-=spacing)];	
    [spanishButton setTag:kLanguageSpanish];
    [languagesMenu addChild:spanishButton];

    CCLabelTTF *portugueseLabel = [CCLabelTTF labelWithString:@"PORTUGUÊS" fontName:kCommonFontName fontSize:30];
    [portugueseLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *portugueseButton = [CCMenuItemLabel itemWithLabel:portugueseLabel target:self selector:@selector(switchToLanguage:)];
    [portugueseButton setTag:kLanguagePortuguese];
    [portugueseButton setPosition: ccp(winSize.width/2, xPosition-=spacing)];	
    [languagesMenu addChild:portugueseButton];

    
    CCLabelTTF *okLabel = [CCLabelTTF labelWithString:@"OK" fontName:kCommonFontName fontSize:30];
    [okLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *okButton = [CCMenuItemLabel itemWithLabel:okLabel target:self selector:@selector(okButtonPressed)];
    [okButton setPosition: ccp(800, 150)];	
    [languagesMenu addChild:okButton];
    
    [self addChild:languagesMenu z:2];  

    //Message label below "OK"
    NSString *messageText = @"(you can change the language later \n on the SETTINGS menu)";
    float fontSize = 20;
    CGSize maxSize = { 450, 2000 };
    
    CGSize actualSize = [messageText sizeWithFont:[UIFont fontWithName:kCommonFontName size:fontSize] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize containerSize = { actualSize.width, actualSize.height };

    messageLabel = [CCLabelTTF labelWithString:messageText dimensions:containerSize alignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:20];
    [messageLabel setColor:ccc3(162, 209, 73)];
    [messageLabel setPosition: ccp(okButton.position.x, 100)];	
    [self addChild:messageLabel];
}


-(void) switchToLanguage:(id) sender
{
    CCMenuItemLabel *senderButton = (CCMenuItemLabel*) sender;
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick];
    
    [[I18nManager getInstance] setLanguageTo:senderButton.tag];
    
    [messageLabel setString:[[I18nManager getInstance] getLanguageMenuMessageString]];    
}

-(void) okButtonPressed
{
    [[CCDirector sharedDirector] replaceScene:[IntroAnimationScene scene]];
}

-(void) dealloc
{
    CCLOG(@"Dealloc IntroAnimationScene: %@", self); 
    
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundMainMenuClick];
    
    [super dealloc];
}

@end
