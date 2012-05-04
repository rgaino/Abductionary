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
#import "Dictionary.h"

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
        [self setupSprites];
        [self setupMenu];
        
    }
    
	return self;
}

-(void) setupSprites
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"I18n_Screen.plist"];
    
    CCSprite *changeIdiomBackground = [CCSprite spriteWithSpriteFrameName:@"changeIdiomBackground.png"];
    [changeIdiomBackground setAnchorPoint:ccp(0,0)];
    [changeIdiomBackground setPosition:ccp(0,0)];
    [self addChild:changeIdiomBackground z:0];
}

-(void) setupMenu
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize containerSize = CGSizeMake(300, 50);
    float xPosition = winSize.width/2;
    
    CCMenu *languagesMenu = [CCMenu menuWithItems:nil];
    [languagesMenu setPosition:CGPointZero];
    
    CCLabelTTF *englishLabel = [CCLabelTTF labelWithString:@"ENGLISH" dimensions:containerSize hAlignment:UITextAlignmentCenter fontName:kCommonFontName fontSize:30];
    [englishLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *englishButton = [CCMenuItemLabel itemWithLabel:englishLabel target:self selector:@selector(switchToLanguage:)];
    [englishButton setPosition: ccp(xPosition, 508)];	
    [englishButton setTag:1];
    [languagesMenu addChild:englishButton];

    CCLabelTTF *spanishLabel = [CCLabelTTF labelWithString:@"ESPAÑOL" dimensions:containerSize hAlignment:UITextAlignmentCenter fontName:kCommonFontName fontSize:30];
    [spanishLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *spanishButton = [CCMenuItemLabel itemWithLabel:spanishLabel target:self selector:@selector(switchToLanguage:)];
    [spanishButton setPosition: ccp(xPosition, 422)];	
    [spanishButton setTag:2];
    [languagesMenu addChild:spanishButton];

    CCLabelTTF *portugueseLabel = [CCLabelTTF labelWithString:@"PORTUGUÊS" dimensions:containerSize hAlignment:UITextAlignmentCenter fontName:kCommonFontName fontSize:30];
    [portugueseLabel setColor:ccc3(162, 209, 73)];
    CCMenuItemLabel *portugueseButton = [CCMenuItemLabel itemWithLabel:portugueseLabel target:self selector:@selector(switchToLanguage:)];
    [portugueseButton setTag:3];
    [portugueseButton setPosition: ccp(xPosition, 338)];	
    [languagesMenu addChild:portugueseButton];

    
    CCMenuItemSprite *okButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"okButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"okButton.png"] target:self selector:@selector(okButtonPressed)];
    [okButton setPosition: ccp(878, 300)];	
    [languagesMenu addChild:okButton];
    
    
    [self addChild:languagesMenu z:2];  
}


-(void) switchToLanguage:(id) sender
{
    CCMenuItemLabel *senderButton = (CCMenuItemLabel*) sender;
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick];
    
    NSString *language;
    switch(senderButton.tag)
    {
        case 1:
            language = @"en";
            break;
        case 2:
            language = @"es";
            break;
        case 3:
            language = @"pt";
            break;
        default:
            language = @"en";
    }
    
    [[I18nManager getInstance] setLanguageTo:language];
    
    [messageLabel setString:[[I18nManager getInstance] getLocalizedStringFor:@"you can change the language later on the SETTINGS menu"]];    
}

-(void) okButtonPressed
{
    [[Dictionary getInstance] setup];
    [[CCDirector sharedDirector] replaceScene:[IntroAnimationScene scene]];
}

-(void) dealloc
{
    CCLOG(@"Dealloc I18nScene: %@", self); 
    
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundMainMenuClick];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"I18n_Screen.plist"];

    [super dealloc];
}


@end
