//
//  MainMenuScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 3/3/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "MainMenuScene.h"
#import "AppDelegate.h"
#import "LoadingScene.h"
#import "GameCenterManager.h"
#import "GameCenterPlayerScore.h"
#import "PlaytomicManager.h"
#import "cocos2d.h"
#import "MainMenuSoundManager.h"
#import "AlienSprite.h"
#import "LeaderboardsLayer.h"
#import "Constants.h"
#import "VolumeKnob.h"


@implementation MainMenuScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuScene *layer = [MainMenuScene node];
	[scene addChild: layer];
	return scene;
}


-(id) init
{
	if( (self=[super init])) 
    {
        mainMenuSoundManager = [[MainMenuSoundManager alloc] init];
        [mainMenuSoundManager playBackgroundMusic];

        [self setIsTouchEnabled:YES];
        [self setupVariablesAndObjects];
        [self setupSprites_RGBA4444];
        [self setupLeaderboardsLayer];
        [self setupMenu];
        [self setupNewGameConsole];
        [self setupAnimations];
        [self schedule:@selector(alienMovement:) interval:kAlienMovementFrequency];
	}
	return self;
}

-(void) setupVariablesAndObjects
{
     AppController *appDelegate = (AppController*) [[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeMedium];
    
    currentLeaderboardGameMode = kLeaderboardGameModeMedium;
    currentLeaderboardScope = kLeaderboardScopeGlobal;
    currentLeaderboardTimePeriod = kLeaderboardTimePeriodAllTime;
    isNewGameConsoleUp = NO;
}

-(void) setupSprites_RGBA4444
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainMenuBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainMenuScreen.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Leaderboards.plist"];


    CCSprite *mainMenuPanelImage = [CCSprite spriteWithSpriteFrameName:@"mainMenuPanel.png"];
    [mainMenuPanelImage setPosition: ccp(0, 0) ];
    [mainMenuPanelImage setAnchorPoint:ccp(0,0)];
    [self addChild:mainMenuPanelImage z:5];

    alienSprite = [[AlienSprite alloc] init];
    [alienSprite alienSpriteForScene:self];
    [alienSprite.alienSprite setPosition:ccp(100, 150)];


    CCSprite *settingsBackgroundImage = [CCSprite spriteWithSpriteFrameName:@"settingsBackground.png"];
    [settingsBackgroundImage setPosition: ccp(0+winSize.width, 0) ];
    [settingsBackgroundImage setAnchorPoint:ccp(0,0)];
    [self addChild:settingsBackgroundImage z:0];
    
    CCSprite *leaderboardsBackgroundImage = [CCSprite spriteWithSpriteFrameName:@"leaderboardsBackground.png"];
    [leaderboardsBackgroundImage setPosition: ccp(0-winSize.width, 0) ];
    [leaderboardsBackgroundImage setAnchorPoint:ccp(0,0)];
    [self addChild:leaderboardsBackgroundImage z:0];
    
    
    CCSprite *backgroundImage = [CCSprite spriteWithSpriteFrameName:@"galaxyBackground.png"];
    [backgroundImage setPosition: ccp(0,0) ];
    [backgroundImage setAnchorPoint:ccp(0,0)];
    [self addChild:backgroundImage z:0];
    
    vortexSprite = [CCSprite spriteWithSpriteFrameName:@"vortex.png"];
    [vortexSprite setAnchorPoint:ccp(0.5,0.5)];
    [vortexSprite setPosition: ccp(winSize.width/2, winSize.height/2)];
    [self addChild:vortexSprite z:1];
    
    stars1Sprite = [CCSprite spriteWithSpriteFrameName:@"stars1.png"];
    [stars1Sprite setAnchorPoint:ccp(0.5,0.5)];
    [stars1Sprite setPosition: ccp(winSize.width/2, winSize.height/2)];
    [self addChild:stars1Sprite z:2];
    
    stars2Sprite = [CCSprite spriteWithSpriteFrameName:@"stars2.png"];
    [stars2Sprite setAnchorPoint:ccp(0.5,0.5)];
    [stars2Sprite setPosition: ccp(winSize.width/2, winSize.height/2)];
    [self addChild:stars2Sprite z:3];
    
    stars3Sprite = [CCSprite spriteWithSpriteFrameName:@"stars3.png"];
    [stars3Sprite setAnchorPoint:ccp(0.5,0.5)];
    [stars3Sprite setPosition: ccp(winSize.width/2, winSize.height/2)];
    [self addChild:stars3Sprite z:4];
    
    
    
    int spacing=76;
    int x=65;
    int y=800;
    
    mainMenuLetter_01a = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_01a.png"];
    [mainMenuLetter_01a setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_01a setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_01a z:5];
    
    x+=spacing;
    mainMenuLetter_02b = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_02b.png"];
    [mainMenuLetter_02b setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_02b setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_02b z:5];
    
    x+=spacing;
    mainMenuLetter_03d = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_03d.png"];
    [mainMenuLetter_03d setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_03d setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_03d z:5];
    
    x+=spacing;
    mainMenuLetter_04u = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_04u.png"];
    [mainMenuLetter_04u setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_04u setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_04u z:5];
    
    x+=spacing;
    mainMenuLetter_05c = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_05c.png"];
    [mainMenuLetter_05c setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_05c setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_05c z:5];
    
    x+=spacing;
    mainMenuLetter_06t = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_06t.png"];
    [mainMenuLetter_06t setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_06t setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_06t z:5];
    
    x+=spacing;
    mainMenuLetter_07i = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_07i.png"];
    [mainMenuLetter_07i setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_07i setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_07i z:5];
    
    x+=spacing;
    mainMenuLetter_08o = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_08o.png"];
    [mainMenuLetter_08o setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_08o setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_08o z:5];
    
    x+=spacing;
    mainMenuLetter_09n = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_09n.png"];
    [mainMenuLetter_09n setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_09n setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_09n z:5];
    
    x+=spacing;
    mainMenuLetter_10a = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_10a.png"];
    [mainMenuLetter_10a setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_10a setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_10a z:5];
    
    x+=spacing;
    mainMenuLetter_11r = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_11r.png"];
    [mainMenuLetter_11r setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_11r setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_11r z:5];
    
    x+=spacing;
    mainMenuLetter_12y = [CCSprite spriteWithSpriteFrameName:@"mainMenuLetter_12y.png"];
    [mainMenuLetter_12y setAnchorPoint:ccp(0,0)];
    [mainMenuLetter_12y setPosition: ccp(x,y) ];
    [self addChild:mainMenuLetter_12y z:5];
    
    
    
    
    musicVolumeKnobUpState = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"volumeKnobUpState.png"]];
    [musicVolumeKnobUpState setType:kCCProgressTimerTypeRadial];
    [musicVolumeKnobUpState setVisible:NO];
    [musicVolumeKnobUpState setPosition:ccp(winSize.width+277, 453)];
    [musicVolumeKnobUpState setMidpoint:ccp(0.4, 0.4)];
    [self addChild:musicVolumeKnobUpState z:5];
    
    soundFXVolumeKnobUpState = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"volumeKnobUpState.png"]];
    [soundFXVolumeKnobUpState setVisible:NO];
    [soundFXVolumeKnobUpState setType:kCCProgressTimerTypeRadial];
    [soundFXVolumeKnobUpState setMidpoint:ccp(0.4, 0.4)];
    [soundFXVolumeKnobUpState setPosition:ccp(winSize.width+745, 453)];
    [self addChild:soundFXVolumeKnobUpState z:5];
    

    musicVolumeKnob = [[VolumeKnob alloc] initWithType:kVolumeKnobTypeMusic volumeKnobUpState:musicVolumeKnobUpState andGain:[mainMenuSoundManager backgroundMusicGain]];
    [musicVolumeKnob setPosition:ccp(winSize.width+277, 453)];
    [musicVolumeKnob setMainMenuSoundManager:mainMenuSoundManager];
    [self addChild:musicVolumeKnob z:5];
    
    soundFXVolumeKnob = [[VolumeKnob alloc] initWithType:kVolumeKnobTypeSoundFX volumeKnobUpState:soundFXVolumeKnobUpState andGain:[mainMenuSoundManager soundFXGain]];
    [soundFXVolumeKnob setPosition:ccp(winSize.width+745, 453)];
    [soundFXVolumeKnob setMainMenuSoundManager:mainMenuSoundManager];
    [self addChild:soundFXVolumeKnob z:5];
    
    
    CCLabelTTF *musicKnobLabel = [CCLabelTTF labelWithString:@"MUSIC" fontName:kCommonFontName fontSize:30];		
    [musicKnobLabel setColor:ccc3(162, 209, 73)];
    [musicKnobLabel setPosition:ccp( winSize.width + 275 , 634)];
    [self addChild:musicKnobLabel];
    
    CCLabelTTF *soundFXKnobLabel = [CCLabelTTF labelWithString:@"SOUND FX" fontName:kCommonFontName fontSize:30];		
    [soundFXKnobLabel setColor:ccc3(162, 209, 73)];
    [soundFXKnobLabel setPosition:ccp( winSize.width + 747 , 634)];
    [self addChild:soundFXKnobLabel];
    

    
    CCMenu *leaderboardsMenu = [CCMenu menuWithItems:nil];
    [leaderboardsMenu setPosition:ccp(winSize.width*-1,0)];
    
    
    leaderboardsEasyButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsEasyButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsEasyButtonUp.png"] target:self selector:@selector(loadEasyLeaderboards)];
	[leaderboardsEasyButton setPosition:ccp(326, 346)];
    [leaderboardsEasyButton setOpacity:0];
	[leaderboardsMenu addChild:leaderboardsEasyButton];
    
    leaderboardsMediumButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsMediumButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsMediumButtonUp.png"] target:self selector:@selector(loadMediumLeaderboards)];
	[leaderboardsMediumButton setPosition:ccp(509, 346)];
    [leaderboardsMediumButton setOpacity:255];
	[leaderboardsMenu addChild:leaderboardsMediumButton];
    
    leaderboardsHardButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsHardButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsHardButtonUp.png"] target:self selector:@selector(loadHardLeaderboards)];
    [leaderboardsHardButton setPosition:ccp(690, 346)];
    [leaderboardsHardButton setOpacity:0];
	[leaderboardsMenu addChild:leaderboardsHardButton];
    
    
    
    leaderboardsAllTimeButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsAllTimeButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsAllTimeButtonUp.png"] target:self selector:@selector(loadAllTimeLeaderboards)];
	[leaderboardsAllTimeButton setPosition:ccp(117, 608)];
    [leaderboardsAllTimeButton setOpacity:255];
	[leaderboardsMenu addChild:leaderboardsAllTimeButton];
    
    
    leaderboardsWeekButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsWeekButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsWeekButtonUp.png"] target:self selector:@selector(loadWeekLeaderboards)];
	[leaderboardsWeekButton setPosition:ccp(117, 555)];
    [leaderboardsWeekButton setOpacity:0];
	[leaderboardsMenu addChild:leaderboardsWeekButton];
    
    leaderboardsTodayButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsTodayButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsTodayButtonUp.png"] target:self selector:@selector(loadTodayLeaderboards)];
	[leaderboardsTodayButton setPosition:ccp(117, 503)];
    [leaderboardsTodayButton setOpacity:0];
	[leaderboardsMenu addChild:leaderboardsTodayButton];
    
    
    
    leaderboardsGlobalButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsGlobalButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsGlobalButtonUp.png"] target:self selector:@selector(loadGlobalLeaderboards)];
	[leaderboardsGlobalButton setPosition:ccp(900, 607)];
    [leaderboardsGlobalButton setOpacity:255];
	[leaderboardsMenu addChild:leaderboardsGlobalButton];
    
    leaderboardsFriendsButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsFriendsButtonUp.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsFriendsButtonUp.png"] target:self selector:@selector(loadFriendsLeaderboards)];
	[leaderboardsFriendsButton setPosition:ccp(900, 557)];
    [leaderboardsFriendsButton setOpacity:0];
	[leaderboardsMenu addChild:leaderboardsFriendsButton];
    
    CCMenuItemImage *leaderboardsDoneButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsDoneButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"leaderboardsDoneButton.png"] target:self selector:@selector(doneLeaderboards)];
	[leaderboardsDoneButton setPosition:ccp(924, 292)];
	[leaderboardsMenu addChild:leaderboardsDoneButton];

    [self addChild:leaderboardsMenu z:10];

    creditsScreen = [CCSprite spriteWithSpriteFrameName:@"creditsScreen.png"];
    [creditsScreen setPosition:ccp((winSize.width+(winSize.width/2)), (430+683))];
    [self addChild:creditsScreen z:11];
}

-(void) setupLeaderboardsLayer
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    leaderboardsLayer = [[[LeaderboardsLayer alloc] init] autorelease];
    [leaderboardsLayer setPosition:ccp(-winSize.width+235, 398)];
    [self addChild:leaderboardsLayer];
}

-(void) setupNewGameConsole
{
    newGameConsole = [CCSprite spriteWithSpriteFrameName:@"newGameConsole.png"];
    [newGameConsole setPosition: ccp(381, 23-500) ];
    [newGameConsole setAnchorPoint:ccp(0,0)];
    [self addChild:newGameConsole z:20];
    
    newGameConsoleDoor = [CCSprite spriteWithSpriteFrameName:@"newGameConsoleDoor.png"];
    [newGameConsoleDoor setPosition: ccp(408,23-500) ];
    [newGameConsoleDoor setAnchorPoint:ccp(0,0)];
    [self addChild:newGameConsoleDoor z:21];
    
    newGameConsoleBottom = [CCSprite spriteWithSpriteFrameName:@"newGameConsoleBottom.png"];
    [newGameConsoleBottom setPosition: ccp(381,0-500) ];
    [newGameConsoleBottom setAnchorPoint:ccp(0,0)];
    [self addChild:newGameConsoleBottom z:22];

    
	gameModeLabel = [CCLabelTTF labelWithString:@"MEDIUM" dimensions:CGSizeMake(147, 50) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:30];
	[gameModeLabel setPosition:ccp(510, 180-500)];
    [gameModeLabel setColor:ccc3(255, 255, 255)];
    [self addChild:gameModeLabel z:20];
    
    CCMenu *newGameMenu = [CCMenu menuWithItems:nil];
    [newGameMenu setPosition:CGPointZero];
    
    CCLabelTTF *startLabel = [CCLabelTTF labelWithString:@"START" fontName:kCommonFontName fontSize:20];
    startLabelButton = [CCMenuItemLabel itemWithLabel:startLabel target:self selector:@selector(startGame)];
	[startLabelButton setPosition:ccp(485, 285-500)];
    [startLabelButton setColor:ccc3(232, 98, 51)];
    [newGameMenu addChild:startLabelButton z:20];


    startButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"startButtonSelected.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"startButtonSelected.png"] target:self selector:@selector(startGame)];
    [startButton setPosition:ccp(562, 284-500)];
    [newGameMenu addChild:startButton z:20];

    gameModeSwitchEasy = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameModeSwitchEasy.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameModeSwitchEasy.png"] target:self selector:@selector(switchGameModeEasy)];
    [gameModeSwitchEasy setPosition:ccp(473,122-500)];
    [gameModeSwitchEasy setOpacity:0];
    [newGameMenu addChild:gameModeSwitchEasy z:20];

    gameModeSwitchMedium = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameModeSwitchMedium.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameModeSwitchMedium.png"] target:self selector:@selector(switchGameModeMedium)];
    [gameModeSwitchMedium setPosition:ccp(515,122-500)];
    [newGameMenu addChild:gameModeSwitchMedium z:20];

    gameModeSwitchHard = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameModeSwitchHard.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameModeSwitchHard.png"] target:self selector:@selector(switchGameModeHard)];
    [gameModeSwitchHard setPosition:ccp(556,122-500)];
    [gameModeSwitchHard setOpacity:0];
    [newGameMenu addChild:gameModeSwitchHard z:20];

    [self addChild:newGameMenu z:20];
    
}

-(void) setupMenu
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCMenu *mainMenu = [CCMenu menuWithItems:nil];
    [mainMenu setPosition:CGPointZero];
    
    CCLabelTTF *newGameLabel = [CCLabelTTF labelWithString:@"NEW GAME" fontName:kCommonFontName fontSize:30];
    [newGameLabel setColor:ccc3(162, 209, 73)];
    newGameButton = [CCMenuItemLabel itemWithLabel:newGameLabel target:self selector:@selector(animateNewGameConsoleUp)];
    [newGameButton setPosition: ccp(510, 570)];	
    [newGameButton setVisible:NO];
    [newGameButton setOpacity:0];
    [mainMenu addChild:newGameButton];
    
    CCLabelTTF *settingsLabel = [CCLabelTTF labelWithString:@"SETTINGS" fontName:kCommonFontName fontSize:30];
    [settingsLabel setColor:ccc3(136, 117, 82)];
    settingsButton = [CCMenuItemLabel itemWithLabel:settingsLabel target:self selector:@selector(moveToSettings)];
    [settingsButton setPosition: ccp(510, 510)];	
    [settingsButton setOpacity:0];
    [settingsButton setVisible:NO];
    [mainMenu addChild:settingsButton];
    
    CCLabelTTF *leaderboardsLabel = [CCLabelTTF labelWithString:@"LEADERBOARDS" fontName:kCommonFontName fontSize:30];
    [leaderboardsLabel setColor:ccc3(136, 117, 82)];
    leaderboardsButton = [CCMenuItemLabel itemWithLabel:leaderboardsLabel target:self selector:@selector(moveToLeaderboards)];
    [leaderboardsButton setPosition: ccp(510, 445)];	
    [leaderboardsButton setOpacity:0];
    [leaderboardsButton setVisible:NO];
    [mainMenu addChild:leaderboardsButton];
        

    CCMenuItemImage *settingsDoneButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"settingsDoneButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"settingsDoneButton.png"] target:self selector:@selector(doneSettings)];
	[settingsDoneButton setPosition:ccp(winSize.width+90, 289)];
	[mainMenu addChild:settingsDoneButton];
        
    CCMenuItemImage *creditsButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"creditsButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"creditsButton.png"] target:self selector:@selector(showHideCredits)];
	[creditsButton setPosition:ccp(winSize.width+930, 289)];
	[mainMenu addChild:creditsButton];

    CCMenuItemImage *resetTutorialsButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"resetTutorialDown.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"resetTutorialUp.png"] target:self selector:@selector(resetTutorial)];
	[resetTutorialsButton setPosition:ccp(winSize.width+(winSize.width/2), 300)];
	[mainMenu addChild:resetTutorialsButton];

    [self addChild:mainMenu z:10];
}

-(void) setupAnimations
{
    id rotateVortexAction = [CCRotateBy actionWithDuration:100.0f angle:-360.0f];
    id repeatRotateVortexAction = [CCRepeatForever actionWithAction:rotateVortexAction];
    [vortexSprite runAction:repeatRotateVortexAction];
    
    id rotateStars1Action = [CCRotateBy actionWithDuration:20.0f angle:-360.0f];
    id repeatRotateStars1Action = [CCRepeatForever actionWithAction:rotateStars1Action];
    [stars1Sprite runAction:repeatRotateStars1Action];
    
    id rotateStars2Action = [CCRotateBy actionWithDuration:10.0f angle:-360.0f];
    id repeatRotateStars2Action = [CCRepeatForever actionWithAction:rotateStars2Action];
    [stars2Sprite runAction:repeatRotateStars2Action];
    
    id rotateStars3Action = [CCRotateBy actionWithDuration:5.0f angle:-360.0f];
    id repeatRotateStars3Action = [CCRepeatForever actionWithAction:rotateStars3Action];
    [stars3Sprite runAction:repeatRotateStars3Action];
    
    
    dropLetterAnimatedDelay = 0.0f;
    [self dropLetterAnimated:mainMenuLetter_01a];
    [self dropLetterAnimated:mainMenuLetter_02b];
    [self dropLetterAnimated:mainMenuLetter_03d];
    [self dropLetterAnimated:mainMenuLetter_04u];
    [self dropLetterAnimated:mainMenuLetter_05c];
    [self dropLetterAnimated:mainMenuLetter_06t];
    [self dropLetterAnimated:mainMenuLetter_07i];
    [self dropLetterAnimated:mainMenuLetter_08o];
    [self dropLetterAnimated:mainMenuLetter_09n];
    [self dropLetterAnimated:mainMenuLetter_10a];
    [self dropLetterAnimated:mainMenuLetter_11r];
    [self dropLetterAnimated:mainMenuLetter_12y];
    
    
    fadeInButtonDelay = 0.5f;
    [self fadeInButton:newGameButton];
    [self fadeInButton:settingsButton];
    [self fadeInButton:leaderboardsButton];
}

-(void) fadeInButton:(CCMenuItemLabel*) button
{    
    id delayAction = [CCDelayTime actionWithDuration:fadeInButtonDelay];
    id fadeInAction = [CCFadeIn actionWithDuration:0.3f];
    
    [button setVisible:YES];
    [button runAction: [CCSequence actions:delayAction, fadeInAction, nil]];
    
    fadeInButtonDelay+=0.5f;
}


-(void) dropLetterAnimated:(CCSprite*) letterSprite
{
    id delayAction = [CCDelayTime actionWithDuration:dropLetterAnimatedDelay];
    id letterDropAction = [CCMoveBy actionWithDuration:3.0f position:ccp(0, -140)];
    id letterEaseElastic = [CCEaseElasticOut actionWithAction:letterDropAction];
    
    [letterSprite runAction: [CCSequence actions:delayAction, letterEaseElastic, nil]];
    
    dropLetterAnimatedDelay+=0.2f;
}

-(void) animateNewGameConsoleUp
{
    [mainMenuSoundManager playMainMenuClickSound];
    
    if(isNewGameConsoleUp) {return;}
    isNewGameConsoleUp = YES;
    
    id moveNewGameConsoleUp = [CCMoveTo actionWithDuration:1.0f position:ccp(381, 23)];
    [newGameConsole runAction:moveNewGameConsoleUp];
    
    id moveStartLabelUp = [CCMoveTo actionWithDuration:1.0f position:ccp(485, 285)];
    [startLabelButton runAction:moveStartLabelUp];
    
    id moveStartButtonUp = [CCMoveTo actionWithDuration:1.0f position:ccp(562, 284)];
    [startButton runAction:moveStartButtonUp];
    
    id moveGameModeLabel = [CCMoveTo actionWithDuration:1.0f position:ccp(510, 180)];
    [gameModeLabel runAction:moveGameModeLabel];
    
    id moveNewGameConsoleBottomUp = [CCMoveTo actionWithDuration:1.0f position:ccp(381,0)];
    [newGameConsoleBottom runAction:moveNewGameConsoleBottomUp];

    id moveNewGameConsoleDoorUp = [CCMoveTo actionWithDuration:1.0f position:ccp(408,23)];
    id delayNewGameConsoleDoor = [CCDelayTime actionWithDuration:0.5f];
    id moveNewGameConsoleDoorDown = [CCMoveTo actionWithDuration:1.0f position:ccp(408,23-500)];

    [newGameConsoleDoor runAction: [CCSequence actions:moveNewGameConsoleDoorUp, delayNewGameConsoleDoor,moveNewGameConsoleDoorDown, nil]];

    
    id moveGameModeSwitchEasy = [CCMoveTo actionWithDuration:1.0f position:ccp(473, 122)];
    [gameModeSwitchEasy runAction:moveGameModeSwitchEasy];
    
    id moveGameModeSwitchMedium = [CCMoveTo actionWithDuration:1.0f position:ccp(515, 122)];
    [gameModeSwitchMedium runAction:moveGameModeSwitchMedium];

    id moveGameModeSwitchHard = [CCMoveTo actionWithDuration:1.0f position:ccp(556, 122)];
    [gameModeSwitchHard runAction:moveGameModeSwitchHard];
    
    [mainMenuSoundManager playNewGameConsoleInSound];
}

-(void) animateNewGameConsoleDown
{
    if(!isNewGameConsoleUp) {return;}
    isNewGameConsoleUp = NO;

    id moveNewGameConsoleDoorUp = [CCMoveTo actionWithDuration:1.0f position:ccp(408,23)];
    [newGameConsoleDoor runAction:moveNewGameConsoleDoorUp];
    
    id delayNewGameConsole = [CCDelayTime actionWithDuration:1.0f];
    id moveNewGameConsoleDown = [CCMoveTo actionWithDuration:1.0f position:ccp(381, 23-500)];
    [newGameConsole runAction: [CCSequence actions:delayNewGameConsole, moveNewGameConsoleDown, nil]];
    
    id delayNewGameConsoleDoor = [CCDelayTime actionWithDuration:1.0f];
    id moveNewGameConsoleDoorDown = [CCMoveTo actionWithDuration:1.0f position:ccp(408, 23-500)];
    [newGameConsoleDoor runAction: [CCSequence actions:delayNewGameConsoleDoor, moveNewGameConsoleDoorDown, nil]];
    
    id delayNewGameConsoleBottom = [CCDelayTime actionWithDuration:1.0f];
    id moveNewGameConsoleBottomDown = [CCMoveTo actionWithDuration:1.0f position:ccp(381, 0-500)];
    [newGameConsoleBottom runAction: [CCSequence actions:delayNewGameConsoleBottom, moveNewGameConsoleBottomDown, nil]];
    

    id delayStartLabel = [CCDelayTime actionWithDuration:1.0f];
    id moveStartLabelUp = [CCMoveTo actionWithDuration:1.0f position:ccp(485, 285-500)];
    [startLabelButton runAction:[CCSequence actions:delayStartLabel, moveStartLabelUp, nil]];
    
    id delayStartButton = [CCDelayTime actionWithDuration:1.0f];
    id moveStartButtonUp = [CCMoveTo actionWithDuration:1.0f position:ccp(562, 284-500)];
    [startButton runAction:[CCSequence actions:delayStartButton, moveStartButtonUp, nil]];
    
    id delayGameModeLabel = [CCDelayTime actionWithDuration:1.0f];
    id moveGameModeLabel = [CCMoveTo actionWithDuration:1.0f position:ccp(510, 180-500)];
    [gameModeLabel runAction:[CCSequence actions:delayGameModeLabel, moveGameModeLabel, nil]];



    id delayGameModeSwitchEasy = [CCDelayTime actionWithDuration:1.0f];
    id moveGameModeSwitchEasy = [CCMoveTo actionWithDuration:1.0f position:ccp(473, 122-500)];
    [gameModeSwitchEasy runAction:[CCSequence actions:delayGameModeSwitchEasy, moveGameModeSwitchEasy, nil]];
    
    id delayGameModeSwitchMedium = [CCDelayTime actionWithDuration:1.0f];
    id moveGameModeSwitchMedium = [CCMoveTo actionWithDuration:1.0f position:ccp(515, 122-500)];
    [gameModeSwitchMedium runAction:[CCSequence actions:delayGameModeSwitchMedium, moveGameModeSwitchMedium, nil]];
    
    id delayGameModeSwitchHard = [CCDelayTime actionWithDuration:1.0f];
    id moveGameModeSwitchHard = [CCMoveTo actionWithDuration:1.0f position:ccp(556, 122-500)];
    [gameModeSwitchHard runAction:[CCSequence actions:delayGameModeSwitchHard, moveGameModeSwitchHard, nil]];

    [mainMenuSoundManager playNewGameConsoleOutSound];
}

-(void) startGameEasy
{
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeEasy];
    [self startGame];
}

-(void) startGameMedium
{
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeMedium];
    [self startGame];
}

-(void) startGameHard
{
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeHard];
    [self startGame];
}

-(void) startGame 
{
    if(isStartingGame) { return; }
    
    isStartingGame = YES;
    [self showLoadingImageWithFade:YES];
    
    [mainMenuSoundManager playMainMenuClickSound];
    [mainMenuSoundManager stopBackgroundMusic];

    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setPlayerScore:0];
    [appDelegate setFailCounterValue:0];
    [appDelegate setPowerUpValue:0];
    
    [[GameCenterManager getInstance] retrySavedFailedScores];
    
    [self performSelector:@selector(goToGameScene) withObject:nil afterDelay:1.0f];
    
}

-(void) goToGameScene
{
    [[CCDirector sharedDirector] replaceScene:[LoadingScene scene]];
}

-(void) switchGameModeEasy
{
    [mainMenuSoundManager playMainMenuClickSound];

    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeEasy];
    [gameModeLabel setString:@"EASY"];
 
    id fadeInAction = [CCFadeIn actionWithDuration:kGameModeSwitchAnimationDuration];
    [gameModeSwitchEasy runAction:fadeInAction];
    
    id fadeOutAction = [CCFadeOut actionWithDuration:kGameModeSwitchAnimationDuration];
    if( [gameModeSwitchMedium opacity] > 0 ) { [gameModeSwitchMedium runAction:fadeOutAction]; }
    if( [gameModeSwitchHard opacity] > 0 ) { [gameModeSwitchHard runAction:fadeOutAction]; }    
}

-(void) switchGameModeMedium
{
    [mainMenuSoundManager playMainMenuClickSound];

    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeMedium];
    [gameModeLabel setString:@"MEDIUM"];

    id fadeInAction = [CCFadeIn actionWithDuration:kGameModeSwitchAnimationDuration];
    [gameModeSwitchMedium runAction:fadeInAction];
    
    id fadeOutAction = [CCFadeOut actionWithDuration:kGameModeSwitchAnimationDuration];
    if( [gameModeSwitchEasy opacity] > 0 ) { [gameModeSwitchEasy runAction:fadeOutAction]; }
    if( [gameModeSwitchHard opacity] > 0 ) { [gameModeSwitchHard runAction:fadeOutAction]; }    
}

-(void) switchGameModeHard
{
    [mainMenuSoundManager playMainMenuClickSound];

    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setCurrentGameMode:kGameModeHard];
    [gameModeLabel setString:@"HARD"];
    
    id fadeInAction = [CCFadeIn actionWithDuration:kGameModeSwitchAnimationDuration];
    [gameModeSwitchHard runAction:fadeInAction];

    id fadeOutAction = [CCFadeOut actionWithDuration:kGameModeSwitchAnimationDuration];
    if( [gameModeSwitchEasy opacity] > 0 ) { [gameModeSwitchEasy runAction:fadeOutAction]; }    
    if( [gameModeSwitchMedium opacity] > 0 ) { [gameModeSwitchMedium runAction:fadeOutAction]; }
}


-(void) moveToSettings
{
    [mainMenuSoundManager playMainMenuClickSound];

    [self animateNewGameConsoleDown];

    [alienSprite.alienSprite stopAllActions];

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint alienPosition = [alienSprite.alienSprite position];
    
    [alienSprite startWalkAnimation];
    
    id moveAlien = [CCMoveTo actionWithDuration:kMainMenuAlienWalkSpeed position:ccp(screenSize.width+kAlienOffsetPositionInSettingsScreen, alienPosition.y)];
    id stopWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(stopWalkAnimation)];
    [alienSprite.alienSprite runAction: [CCSequence actions:moveAlien, stopWalkAnimation, nil]];
    
    
    id delayPan = [CCDelayTime actionWithDuration:1.0f];
    id panToSettingsAction = [CCMoveTo actionWithDuration:kMainMenuPanSpeed position:ccp(screenSize.width*-1, 0)];
    [self runAction:[CCSequence actions:delayPan, panToSettingsAction, nil]];
    
    [self performSelector:@selector(showVolumeKnobsUpstate) withObject:nil afterDelay:3.5f];
}

-(void) doneSettings
{
    [mainMenuSoundManager playMainMenuClickSound];

    [alienSprite.alienSprite stopAllActions];
    
    CGPoint alienPosition = [alienSprite.alienSprite position];
    
    [alienSprite startWalkAnimation];
    
    id moveAlien = [CCMoveTo actionWithDuration:kMainMenuAlienWalkSpeed position:ccp(100, alienPosition.y)];
    id stopWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(stopWalkAnimation)];
    [alienSprite.alienSprite runAction: [CCSequence actions:moveAlien, stopWalkAnimation, nil]];
    
    id panToMainMenuAction = [CCMoveTo actionWithDuration:kMainMenuPanSpeed position:ccp(0, 0)];
    [self runAction:panToMainMenuAction];
    
//    [self performSelector:@selector(hideVolumeKnobsUpstate) withObject:nil afterDelay:3.5f];
    [self hideVolumeKnobsUpstate];
}

-(void) showVolumeKnobsUpstate 
{
    [musicVolumeKnobUpState setVisible:YES];
    [soundFXVolumeKnobUpState setVisible:YES];
}

-(void) hideVolumeKnobsUpstate
{
    [musicVolumeKnobUpState setVisible:NO];
    [soundFXVolumeKnobUpState setVisible:NO];
}


-(void) moveToLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [self animateNewGameConsoleDown];
    [self loadLeaderboards];
    
    [alienSprite.alienSprite stopAllActions];

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint alienPosition = [alienSprite.alienSprite position];
    
    [alienSprite startWalkAnimation];
    
    id moveAlien = [CCMoveTo actionWithDuration:kMainMenuAlienWalkSpeed position:ccp((screenSize.width*-1)+100, alienPosition.y)];
    id stopWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(stopWalkAnimation)];
    [alienSprite.alienSprite runAction: [CCSequence actions:moveAlien, stopWalkAnimation, nil]];
    
    id delayPan = [CCDelayTime actionWithDuration:1.0f];
    id panToLeaderboardsAction = [CCMoveTo actionWithDuration:kMainMenuPanSpeed position:ccp(screenSize.width, 0)];
    [self runAction:[CCSequence actions:delayPan, panToLeaderboardsAction, nil]];
}

-(void) doneLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [alienSprite.alienSprite stopAllActions];

    CGPoint alienPosition = [alienSprite.alienSprite position];
    
    [alienSprite startWalkAnimation];
    
    id moveAlien = [CCMoveTo actionWithDuration:kMainMenuAlienWalkSpeed position:ccp(100, alienPosition.y)];
    id stopWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(stopWalkAnimation)];
    [alienSprite.alienSprite runAction: [CCSequence actions:moveAlien, stopWalkAnimation, nil]];
    
    id panToMainMenuAction = [CCMoveTo actionWithDuration:kMainMenuPanSpeed position:ccp(0, 0)];
    [self runAction:panToMainMenuAction];
}


#pragma mark Touch Events

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
	if([[event allTouches] count] > 1) { 
        touchedKnob = nil;
        return; 
    }
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
	UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];   
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = CGPointMake(touchLocation.x+winSize.width, touchLocation.y);
    
    if( CGRectContainsPoint( [musicVolumeKnob boundingBox], touchLocation)) {
        touchedKnob = musicVolumeKnob;
    } else if( CGRectContainsPoint( [soundFXVolumeKnob boundingBox], touchLocation)) {
        touchedKnob = soundFXVolumeKnob;
    } else {
        touchedKnob = nil;
        return;
    }
    
    if ([touchedKnob squaredDistanceToCenter:touchLocation] < kKnobMinimumDistanceSquared)
    {
        touchedKnob = nil;
		return;
    }
    
    [touchedKnob calculateAngleBetweenCenterAndPoint:touchLocation];
    
}



- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if([[event allTouches] count] > 1) { return; }
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
	UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];   
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = CGPointMake(touchLocation.x+winSize.width, touchLocation.y);
    
    if( CGRectContainsPoint( [musicVolumeKnob boundingBox], touchLocation)) {
        touchedKnob = musicVolumeKnob;
    } else if( CGRectContainsPoint( [soundFXVolumeKnob boundingBox], touchLocation)) {
        touchedKnob = soundFXVolumeKnob;
        [mainMenuSoundManager playTapLetterSound];
    } else {
        touchedKnob = nil;
        return;
    }
    
    if ([touchedKnob squaredDistanceToCenter:touchLocation] < kKnobMinimumDistanceSquared)
    {
        NSLog(@"too close to center");
        touchedKnob = nil;
		return;
    }
    
    [touchedKnob knobTouchMovedToPoint:touchLocation];
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
    touchedKnob = nil;
}


#pragma mark Leaderboards

-(void) loadLeaderboards
{    
    [[GameCenterManager getInstance] retrieveScoresForGameMode:currentLeaderboardGameMode scope:currentLeaderboardScope period:currentLeaderboardTimePeriod withCallback:self];
}

-(void) didFinishLoadingScores:(NSMutableArray*) leaderboardResults
{
    [leaderboardsLayer updateScoreLabelsWithScores:leaderboardResults];
}

-(void) errorLoadingScores:(NSError*) error
{
}

-(void) loadGlobalLeaderboards 
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsGlobalButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsFriendsButton opacity] > 0) { [leaderboardsFriendsButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardScope = kLeaderboardScopeGlobal;
    [self loadLeaderboards];
}

-(void) loadFriendsLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsFriendsButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsGlobalButton opacity] > 0) { [leaderboardsGlobalButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardScope = kLeaderboardScopeFriends;
    [self loadLeaderboards];
}


-(void) loadAllTimeLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsAllTimeButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsWeekButton opacity] > 0) { [leaderboardsWeekButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    if([leaderboardsTodayButton opacity] > 0) { [leaderboardsTodayButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardTimePeriod = kLeaderboardTimePeriodAllTime;
    [self loadLeaderboards];
}

-(void) loadWeekLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsWeekButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsAllTimeButton opacity] > 0) { [leaderboardsAllTimeButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    if([leaderboardsTodayButton opacity] > 0) { [leaderboardsTodayButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardTimePeriod = kLeaderboardTimePeriodWeek;
    [self loadLeaderboards];
}

-(void) loadTodayLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsTodayButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsAllTimeButton opacity] > 0) { [leaderboardsAllTimeButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    if([leaderboardsWeekButton opacity] > 0) { [leaderboardsWeekButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardTimePeriod = kLeaderboardTimePeriodToday;
    [self loadLeaderboards];
}

-(void) loadEasyLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsEasyButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsMediumButton opacity] > 0) { [leaderboardsMediumButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    if([leaderboardsHardButton opacity] > 0) { [leaderboardsHardButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    
    currentLeaderboardGameMode = kLeaderboardGameModeEasy;
    [self loadLeaderboards];
}

-(void) loadMediumLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsMediumButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsEasyButton opacity] > 0) { [leaderboardsEasyButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    if([leaderboardsHardButton opacity] > 0) { [leaderboardsHardButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardGameMode = kLeaderboardGameModeMedium;
    [self loadLeaderboards];
}

-(void) loadHardLeaderboards
{
    [mainMenuSoundManager playMainMenuClickSound];

    [leaderboardsHardButton runAction:[CCFadeIn actionWithDuration:0.3f]];
    if([leaderboardsEasyButton opacity] > 0) { [leaderboardsEasyButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }
    if([leaderboardsMediumButton opacity] > 0) { [leaderboardsMediumButton runAction:[CCFadeOut actionWithDuration:0.3f]]; }

    currentLeaderboardGameMode = kLeaderboardGameModeHard;
    [self loadLeaderboards];
}

-(void) showHideCredits
{
    [mainMenuSoundManager playMainMenuClickSound];

    if([creditsScreen numberOfRunningActions] > 0) { return; }
    
    
    CGPoint position = creditsScreen.position;
    if(position.y == 430)
    {
        [mainMenuSoundManager playNewGameConsoleOutSound];
        position.y = 430+683;
    } else 
    {
        [mainMenuSoundManager playNewGameConsoleInSound];
        position.y = 430;
    }
    
    id showCreditsScreen = [CCMoveTo actionWithDuration:1.5f position:position];
    [creditsScreen runAction:showCreditsScreen];
}

-(CGPoint) newAlienPosition
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];

    CGPoint alienPosition = [alienSprite.alienSprite position];
    
    
    float moveOnX = 70, moveOnY = 10;
    float minX = 50,    maxX = 170;
    float minY = 120,   maxY = 170;

    
    
    if(self.position.x == 0) //main menu screen
    {
        
    } else if(self.position.x >= screenSize.width) //leaderboards screen
    {
        minX -= screenSize.width;
        maxX -= screenSize.width;
        
    } else if(self.position.x<0) //settings screen
    {
        minX += (screenSize.width + kAlienOffsetPositionInSettingsScreen);
        maxX += (screenSize.width + kAlienOffsetPositionInSettingsScreen);
    }

    int xChance = arc4random() % 2;
    int yChance = arc4random() % 2;
    
    if(xChance==1) { moveOnX = moveOnX * -1; }
    if(yChance==1) { moveOnY = moveOnY * -1; }
    
    alienPosition.x = alienPosition.x + moveOnX;
    alienPosition.y = alienPosition.y + moveOnY;

    if( alienPosition.x>maxX) { alienPosition.x = minX; }
    if( alienPosition.x<minX) { alienPosition.x = maxX; }
    if( alienPosition.y>maxY) { alienPosition.y = minY; }
    if( alienPosition.y<minY) { alienPosition.y = maxY; }


    return alienPosition;
}


-(void) resetTutorial 
{
    NSLog(@"Resetting tutorials.");
    
    [mainMenuSoundManager playMainMenuClickSound];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
    [prefs setValue:[NSNumber numberWithBool:NO] forKey:kSkipTutorials];

    for(int tutorialNumber=1; tutorialNumber<=kNumberOfTutorials; tutorialNumber++) 
    {
        NSString *tutorialKey = [NSString stringWithFormat:kTutorialDefaultsString, tutorialNumber];
        [prefs setValue:[NSNumber numberWithBool:NO] forKey:tutorialKey];
    }

}

- (void) dealloc
{
    [AlienSprite cancelPreviousPerformRequestsWithTarget:alienSprite];
    [alienSprite release];    

    [musicVolumeKnob release];
    [soundFXVolumeKnob release];
    [mainMenuSoundManager release];

    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"mainMenuBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"mainMenuScreen.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Leaderboards.plist"];

    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    CCLOG(@"Dealloc MainMenuScene: %@", self);
    
	[super dealloc];
}

@end
