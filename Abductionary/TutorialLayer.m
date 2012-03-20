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

    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(50, 50, 50, 210)];
    [self addChild:colorLayer z:-1];
        
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Tutorial.plist"];

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    NSString *tutorialMessageFileName = [NSString stringWithFormat:@"tutorialScreen_%d-%d.png",tutorialNumber,part];
    NSLog(@"Tutorial file is %@", tutorialMessageFileName);
    tutorialMessage = [CCSprite spriteWithSpriteFrameName:tutorialMessageFileName];
    [tutorialMessage setPosition:ccp( winSize.width/2, winSize.height/2)];
    [self addChild:tutorialMessage z:2];
    
    closeButton = [CCSprite spriteWithSpriteFrameName:@"closeTutorialButtonOn.png"];
    [closeButton setPosition:ccp(670, 263)];
    [self addChild:closeButton z:3];
    
    
    tutorialsOnOffLabel = [CCLabelTTF labelWithString:@"X" fontName:kCommonFontName fontSize:20];
    [tutorialsOnOffLabel setColor:ccc3(255, 68, 0)];
    [tutorialsOnOffLabel setPosition:ccp(320,255)];
    [tutorialsOnOffLabel setVisible:NO];
    [self addChild:tutorialsOnOffLabel z:3];}

-(void) showTutorial
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    [tutorialMessage removeFromParentAndCleanup:YES];
    
    NSString *tutorialMessageFileName = [NSString stringWithFormat:@"tutorialScreen_%d-%d.png",tutorialNumber,part];
    NSLog(@"Tutorial file is %@", tutorialMessageFileName);
    tutorialMessage = [CCSprite spriteWithSpriteFrameName:tutorialMessageFileName];
    tutorialMessage = [CCSprite spriteWithSpriteFrameName:tutorialMessageFileName];
    [tutorialMessage setPosition:ccp( winSize.width/2, winSize.height/2)];
    [self addChild:tutorialMessage z:2];
}


-(void) registerWithTouchDispatcher
{
    NSLog(@"at TutorialLayer.registerWithTouchDispatcher");
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kCCMenuTouchPriority-1 swallowsTouches:YES];
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
 	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];

    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Tutorial.plist"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"Tutorial.pvr.ccz"];
    
    [super dealloc];
}

@end
