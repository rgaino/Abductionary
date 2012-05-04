//
//  TutorialLayer.m
//  Abductionary
//
//  Created by Rafael Gaino on 1/23/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "TutorialLayer.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "I18nManager.h"

@implementation TutorialLayer

-(id)initWithTutorialNumber:(int) _tutorialNumber
{
    tutorialNumber = _tutorialNumber;
    
    if ((self = [super init])) 
    {
        [self setupTutorial];
    }
    return self;
}


-(void) setupTutorial
{
    self.isTouchEnabled = YES;
    
    part=1;
    tutorialFontSize = 18.0f;
    
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(50, 50, 50, 210)];
    [self addChild:colorLayer z:-1];
        
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Tutorial.plist"];

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    NSString *tutorialMessageFileName;
    
    if( tutorialNumber < 4 ) 
    {
        tutorialMessageFileName = [NSString stringWithFormat:@"tutorialScreen_1.png"];
    } else {
        tutorialMessageFileName = [NSString stringWithFormat:@"tutorialScreen_%d-%d.png",tutorialNumber,part];
    }
    NSLog(@"Tutorial file is %@", tutorialMessageFileName);
    
    tutorialMessageSprite = [CCSprite spriteWithSpriteFrameName:tutorialMessageFileName];
    [tutorialMessageSprite setPosition:ccp( winSize.width/2, winSize.height/2)];
    [self addChild:tutorialMessageSprite z:2];
    
    closeButton = [CCSprite spriteWithSpriteFrameName:@"closeTutorialButtonOn.png"];
    [closeButton setPosition:ccp(670, 263)];
    [self addChild:closeButton z:3]; 
    
    
    CCLabelTTF *skipTutorialLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Skip Tutorial"]dimensions:CGSizeMake(147, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:13];
    [skipTutorialLabel setColor:ccc3(255, 68, 0)];
    [skipTutorialLabel setPosition:ccp(393,238)];
    [self addChild:skipTutorialLabel z:3];
    
    tutorialsOnOffLabel = [CCLabelTTF labelWithString:@"X" fontName:kCommonFontName fontSize:tutorialFontSize];
    [tutorialsOnOffLabel setColor:ccc3(255, 68, 0)];
    [tutorialsOnOffLabel setPosition:ccp(320,255)];
    [tutorialsOnOffLabel setVisible:NO];
    [self addChild:tutorialsOnOffLabel z:3];
    
    if (tutorialNumber < 4) {
        
        NSString *tutorialTextKey = [NSString stringWithFormat:@"Tutorial_%d-%d",tutorialNumber,part];
        NSString *tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:tutorialTextKey];
        
        CGSize containerSize = CGSizeMake(370, 190);    
        tutorialMessageLabel = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
        [tutorialMessageLabel setColor:ccc3(164, 185, 0)];
        [tutorialMessageLabel setPosition: ccp(525, 415)];	
        [self addChild:tutorialMessageLabel z:5];                                   
    } else if (tutorialNumber == 4 )
    {
        if( part == 1)
        {
            NSString *tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-1-1"];
            
            CGSize containerSize = CGSizeMake(380, 190);    
            tutorialMessageLabel = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
            [tutorialMessageLabel setColor:ccc3(164, 185, 0)];
            [tutorialMessageLabel setPosition: ccp(515, 415)];	
            [self addChild:tutorialMessageLabel z:5];     
            
            tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-1-2"];
            containerSize = CGSizeMake(340, 190);
            tutorialMessageLabel_2 = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
            [tutorialMessageLabel_2 setColor:ccc3(164, 185, 0)];
            [tutorialMessageLabel_2 setPosition:ccp(538, 365)];	
            [self addChild:tutorialMessageLabel_2 z:5];     
        }
   
    }
}

-(void) showTutorial
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    [tutorialMessageSprite removeFromParentAndCleanup:YES];
    
    NSString *tutorialMessageFileName;
    
    if( tutorialNumber < 4 ) 
    {
        tutorialMessageFileName = [NSString stringWithFormat:@"tutorialScreen_1.png"];
    } else {
        tutorialMessageFileName = [NSString stringWithFormat:@"tutorialScreen_%d-%d.png",tutorialNumber,part];
    }
    NSLog(@"Tutorial file is %@", tutorialMessageFileName);

    tutorialMessageSprite = [CCSprite spriteWithSpriteFrameName:tutorialMessageFileName];
    [tutorialMessageSprite setPosition:ccp( winSize.width/2, winSize.height/2)];
    [self addChild:tutorialMessageSprite z:2];
    
    
    if (tutorialNumber < 4) {
        
        NSString *tutorialTextKey = [NSString stringWithFormat:@"Tutorial_%d-%d",tutorialNumber,part];
        [tutorialMessageLabel setString:[[I18nManager getInstance] getLocalizedStringFor:tutorialTextKey]];
    }  
    if( tutorialNumber == 4 && part == 2)
    {
        [tutorialMessageLabel removeFromParentAndCleanup:YES];
        [tutorialMessageLabel_2 removeFromParentAndCleanup:YES];
        
        NSString *tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-2-1"];
        
        CGSize containerSize = CGSizeMake(380, 190);    
        tutorialMessageLabel = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
        [tutorialMessageLabel setColor:ccc3(164, 185, 0)];
        [tutorialMessageLabel setPosition: ccp(515, 418)];	
        [self addChild:tutorialMessageLabel z:5];     
        
        tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-2-2"];
        containerSize = CGSizeMake(340, 190);
        tutorialMessageLabel_2 = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
        [tutorialMessageLabel_2 setColor:ccc3(164, 185, 0)];
        [tutorialMessageLabel_2 setPosition:ccp(538, 340)];	
        [self addChild:tutorialMessageLabel_2 z:5];     
        
        tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-2-3"];
        containerSize = CGSizeMake(340, 190);
        tutorialMessageLabel_3 = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
        [tutorialMessageLabel_3 setColor:ccc3(164, 185, 0)];
        [tutorialMessageLabel_3 setPosition:ccp(538, 290)];	
        [self addChild:tutorialMessageLabel_3 z:5];     
    } 
    if( tutorialNumber == 4 && part == 3)
    {
        [tutorialMessageLabel removeFromParentAndCleanup:YES];
        [tutorialMessageLabel_2 removeFromParentAndCleanup:YES];
        [tutorialMessageLabel_3 removeFromParentAndCleanup:YES];
        
        NSString *tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-3-1"];
        CGSize containerSize = CGSizeMake(340, 190);
        tutorialMessageLabel_2 = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
        [tutorialMessageLabel_2 setColor:ccc3(164, 185, 0)];
        [tutorialMessageLabel_2 setPosition:ccp(538, 418)];	
        [self addChild:tutorialMessageLabel_2 z:5];     
        
        tutorialTextString = [[I18nManager getInstance] getLocalizedStringFor:@"Tutorial_4-3-2"];
        containerSize = CGSizeMake(340, 190);
        tutorialMessageLabel_3 = [CCLabelTTF labelWithString:tutorialTextString dimensions:containerSize hAlignment:UITextAlignmentLeft fontName:kCommonFontName fontSize:tutorialFontSize];
        [tutorialMessageLabel_3 setColor:ccc3(164, 185, 0)];
        [tutorialMessageLabel_3 setPosition:ccp(538, 310)];	
        [self addChild:tutorialMessageLabel_3 z:5];     
    } 
}


-(void) registerWithTouchDispatcher
{
    NSLog(@"at TutorialLayer.registerWithTouchDispatcher");
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-129 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"at TutorialLayer.ccTouchBegan");
    
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        
    if( CGRectContainsPoint([closeButton boundingBox], touchLocation))
    {
        [self closeTutorial];
    }

    CGRect switchTutorialOnOff = CGRectMake(300,245, 240, 50);
    if( CGRectContainsPoint(switchTutorialOnOff, touchLocation))
    {
        [self turnTutorialsOnOff];
    }
    
    return YES;
}

-(void) turnTutorialsOnOff
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick];

    [tutorialsOnOffLabel setVisible:![tutorialsOnOffLabel visible]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:[NSNumber numberWithBool:[tutorialsOnOffLabel visible]] forKey:kSkipTutorials];
}

-(void) closeTutorial
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *tutorialKey = [NSString stringWithFormat:kTutorialDefaultsString, tutorialNumber];
    
    [prefs setValue:[NSNumber numberWithBool:YES] forKey:tutorialKey];
    
    bool skipTutorial = [[prefs objectForKey:kSkipTutorials] boolValue];

    NSLog(@"SkipTutorial is %@", skipTutorial?@"YES":@"NO");
    
    if(!skipTutorial && ((tutorialNumber==1 && part==1) || (tutorialNumber==4 && part<3)))
    {
        part++;
        [self showTutorial];
    } else
    {
        [[CCDirector sharedDirector] resume];
        [self removeFromParentAndCleanup:YES];
    }
}


-(void) dealloc
{
    NSLog(@"on dealloc for Tutorial Scene: %@", self);
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Tutorial.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"Tutorial.pvr.ccz"];
    
    [super dealloc];
}

@end
