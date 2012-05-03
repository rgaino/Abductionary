//
//  GameScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 3/3/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "GameScene.h"
#import "ScrollingLetter.h"
#import "PowerUpButton.h"
#import "Constants.h"
#import "Dictionary.h"
#import "LetterSlot.h"
#import "AppDelegate.h"
#import "GameCenterManager.h"
#import "LoadingScene.h"
#import "TruckSprite.h"
#import "FeathersSprite.h"
#import "CloudscapeLayer.h"
#import "CCSprite+extension.h"
#import "PlaytomicManager.h"
#import "GameSoundManager.h"
#import "HumanSprite.h"
#import "TubeDoorSprite.h"
#import "TutorialLayer.h"
#import "I18nManager.h"

@implementation GameScene

@synthesize lastTimeTouchMoved = _lastTimeTouchMoved;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}


-(id) init
{
    NSLog(@"Init of class %@", NSStringFromClass([self class]));
    
	if( (self=[super init])) {
		
        [[PlaytomicManager getInstance] logPlay];
        gameSoundManager = [[GameSoundManager alloc] init];

		[self setIsTouchEnabled:YES];
		[self setupVariablesAndObjects];
		[self setupSprites_RGBA4444];
        [self setupLayers];
		[self setupButtons];
        [self beamUpNewHuman];

		[self scheduleUpdate];
        [self schedule:@selector(updateLevelTime:) interval:kUpdateLevelTimeFrequency];
        [self schedule:@selector(updateScrollingLetters:) interval:kUpdateScrollingLettersFrequency];
        [self schedule:@selector(alienMovement:) interval:kAlienMovementFrequency];
        [self schedule:@selector(humanKeepAlive:) interval:kHumanKeepAliveFrequency];
        
        [gameSoundManager restoreBackgroundMusic];
        [gameSoundManager startGameLoopSound];
        
        [self updatePowerUpMeter];
        [self updateTemperatureGauge];
        
        [self performSelector:@selector(showTutorialNumber:) withObject:[NSNumber numberWithInt:1] afterDelay:2.5f];
    }
	return self;
}


-(void) setupVariablesAndObjects 
{
    
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setPlayerScore:0];
    [appDelegate setFailCounterValue:0];
    [appDelegate setPowerUpValue:0];

    switch( [appDelegate currentGameMode] )
    {
        case kGameModeEasy:
            NSLog(@"Starting game on easy mode");
            scrollingLettersSpeed = kScrollingLettersInitialSpeedEasy;
            break;
        case kGameModeMedium:
            NSLog(@"Starting game on medium mode");
            scrollingLettersSpeed = kScrollingLettersInitialSpeedMedium;
            break;
        default:
            NSLog(@"Starting game on hard mode");
            scrollingLettersSpeed = kScrollingLettersInitialSpeedHard;
            break;     
    }
    
    
    NSLog(@"Initial speed is %.2f", scrollingLettersSpeed);
    
    failCounter = floor(kMaxLives/3);
    scrollingLettersSpeedModifier = 1.0f;
	score = 0;
    powerUpMeterValue = 0;
    currentPowerUpFilling = 1;
	createLetterCounter = 0;
    level = 1;
    [[PlaytomicManager getInstance] logLevel:level];
    temperatureArrowAngleTick = ( (kTemperatureGaugeAngleMax*2) / kMaxLives);
	scrollingLetters = [[NSMutableArray alloc] init];
    powerUpButtons = [[NSMutableArray alloc] init];
    dictionary = [Dictionary getInstance];
    [dictionary resetSpelledWords];
	screenSize = [[CCDirector sharedDirector] winSize];
    totalLevelTime = kDefaultLevelTime;
    throwScrambledWord = NO;
    throwWildcard = NO;
    isStreaking = NO;
    isTransitioningLevels = NO;
    isSlowDownPowerUpActive = NO;
    
	UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cleanWordPanel)];
	//[gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp)];
	[gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
	[gestureRecognizer setNumberOfTouchesRequired:2];
	[[[CCDirector sharedDirector] view] addGestureRecognizer:gestureRecognizer];
	[gestureRecognizer release];
}

-(void) setupSprites_RGBA4444
{
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"alphabet.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameScreen.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverBackground_01.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverBackground_02.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverBackground_03.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverBackground_04.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverBackground_05.plist"];


    CCSprite *backgroundImage = [CCSprite spriteWithSpriteFrameName:@"gameBackground.png"];
    [backgroundImage setPosition:ccp(0, 57)];
    [backgroundImage setAnchorPoint:ccp(0,0)];
    [self addChild: backgroundImage z:0];
    
    CCSprite *trapDoorPassThroughImage = [CCSprite spriteWithSpriteFrameName:@"trapDoorPassThrough.png"];
    [trapDoorPassThroughImage setPosition:ccp(300, 57)];
    [trapDoorPassThroughImage setAnchorPoint:ccp(0,0)];
    [self addChild: trapDoorPassThroughImage z:11];
    
    trapDoorImage = [CCSprite spriteWithSpriteFrameName:@"trapDoor.png"];
    [trapDoorImage setPosition:ccp(300, 123)];
    [trapDoorImage setAnchorPoint:ccp(0,0)];
    [self addChild: trapDoorImage z:-1];
    
    CCSprite *trapDoorHoleImage = [CCSprite spriteWithSpriteFrameName:@"trapDoorHole.png"];
    [trapDoorHoleImage setPosition:ccp(300, 125)];
    [trapDoorHoleImage setAnchorPoint:ccp(0,0)];
    [self addChild: trapDoorHoleImage z:1];
    
    
    CCSprite *gameOverBackgroundImage_01 = [CCSprite spriteWithSpriteFrameName:@"gameOverBackground_01.png"];
    [gameOverBackgroundImage_01 setPosition:ccp(0, 768*-1)];
    [gameOverBackgroundImage_01 setAnchorPoint:ccp(0,0)];
    [self addChild: gameOverBackgroundImage_01 z:0];
    
    CCSprite *gameOverBackgroundImage_02 = [CCSprite spriteWithSpriteFrameName:@"gameOverBackground_02.png"];
    [gameOverBackgroundImage_02 setPosition:ccp(0, (768)*-2)];
    [gameOverBackgroundImage_02 setAnchorPoint:ccp(0,0)];
    [self addChild: gameOverBackgroundImage_02 z:0];
    
    CCSprite *gameOverBackgroundImage_03 = [CCSprite spriteWithSpriteFrameName:@"gameOverBackground_03.png"];
    [gameOverBackgroundImage_03 setPosition:ccp(0, (768)*-3)];
    [gameOverBackgroundImage_03 setAnchorPoint:ccp(0,0)];
    [self addChild: gameOverBackgroundImage_03 z:0];
    
    CCSprite *gameOverBackgroundImage_04 = [CCSprite spriteWithSpriteFrameName:@"gameOverBackground_04.png"];
    [gameOverBackgroundImage_04 setPosition:ccp(0, (768)*-4)];
    [gameOverBackgroundImage_04 setAnchorPoint:ccp(0,0)];
    [self addChild: gameOverBackgroundImage_04 z:0];
    
    CCSprite *gameOverBackgroundImage_05 = [CCSprite spriteWithSpriteFrameName:@"gameOverBackground_05.png"];
    [gameOverBackgroundImage_05 setPosition:ccp(0, (768)*-5)];
    [gameOverBackgroundImage_05 setAnchorPoint:ccp(0,0)];
    [self addChild: gameOverBackgroundImage_05 z:0];
    
    alienSprite = [[AlienSprite alloc] init];
    [alienSprite alienSpriteForScene:self];
    [alienSprite.alienSprite setPosition:ccp(200,180)];
    
    humanSprite = [[HumanSprite alloc] init];
    [humanSprite humanSpriteForScene:self];

    CCSprite *floorLineImage = [CCSprite spriteWithSpriteFrameName:@"floorLine.png"];
    [floorLineImage setPosition:ccp(0, 52)];
    [floorLineImage setAnchorPoint:ccp(0,0)];
    [self addChild: floorLineImage z:12];

    CCSprite *letterfallOverlayImage = [CCSprite spriteWithSpriteFrameName:@"letterfallOverlay.png"];
    [letterfallOverlayImage setPosition:ccp(512, 62)];
    [letterfallOverlayImage setAnchorPoint:ccp(0,0)];
    [self addChild: letterfallOverlayImage z:5];

    temperatureGaugeArrowImage = [CCSprite spriteWithSpriteFrameName:@"temperatureGaugeArrow.png"];
    [temperatureGaugeArrowImage setPosition:ccp(213, 468)];
    [temperatureGaugeArrowImage setAnchorPoint:ccp(0.5, 0.2)];
    [temperatureGaugeArrowImage setRotation: (kTemperatureGaugeAngleMax*-1)];
    [self addChild: temperatureGaugeArrowImage z:2];
    [self updateTemperatureGauge];
    
    scoreUpImage = [CCSprite spriteWithSpriteFrameName:@"scoreUp.png"];
    [scoreUpImage setVisible:NO];
    [scoreUpImage setPosition:ccp(130, 574)];
    [scoreUpImage setAnchorPoint:ccp(0,0)];
    [self addChild: scoreUpImage z:5];

    tubeDoorImage = [CCSprite spriteWithSpriteFrameName:@"tubeDoor.png"];
    [tubeDoorImage setPosition:ccp(479, 92+768)];
    [tubeDoorImage setAnchorPoint:ccp(0,0)];
    [self addChild: tubeDoorImage z:15];
    
    letterSlots = [[NSMutableArray alloc] init];	
	float firstLetterSlotX = kFirstLetterSlotX;
	for(int i=0; i<kMaximumWordLength; i++) {
		
		LetterSlot *squareSlot = [LetterSlot spriteWithSpriteFrameName:@"squareSlot.png"];
		[squareSlot setPosition:ccp(firstLetterSlotX, kFirstLetterSlotY)];
		[self addChild:squareSlot z:1];
		[letterSlots addObject:squareSlot];
		[squareSlot release];
		
		firstLetterSlotX += kLetterWidth + kLetterSlotXSpacing;
	}
    
    
    CCSprite *humanTubeOverlayImage = [CCSprite spriteWithSpriteFrameName:@"humanTubeOverlay.png"];
    [humanTubeOverlayImage setPosition:ccp(380, 380)];
    [self addChild: humanTubeOverlayImage z:11];

    humanTubeFrozen = [CCSprite spriteWithSpriteFrameName:@"humanTubeFrozen.png"];
    [humanTubeFrozen setPosition:ccp(390, 380)];
    [humanTubeFrozen setOpacity:0.0f];
    [self addChild: humanTubeFrozen z:11];

    letterTubeFrozen = [CCSprite spriteWithSpriteFrameName:@"letterTubeFrozen.png"];
    [letterTubeFrozen setAnchorPoint:ccp(0, 0)];
    [letterTubeFrozen setPosition:ccp(493, 77)];
    [letterTubeFrozen setOpacity:0.0f];
    [self addChild: letterTubeFrozen z:1];


    
    smokeEmitterTemperatureGauge = [CCParticleSystemQuad particleWithFile:@"smokeParticles.plist"];        
    [smokeEmitterTemperatureGauge setPosition:ccp(213, 468)];
    [smokeEmitterTemperatureGauge stopSystem];
    [self addChild:smokeEmitterTemperatureGauge z:20];
    
    
    temperatureMeterGlow = [CCSprite spriteWithSpriteFrameName:@"temperatureMeterGlow.png"];
    [temperatureMeterGlow setPosition:ccp(211, 471)];
    [temperatureMeterGlow setOpacity:0];
    [self addChild:temperatureMeterGlow z:1];

    powerUpBarProgressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"powerUpBar.png"]]; 
    [powerUpBarProgressTimer setType:kCCProgressTimerTypeBar];
    [powerUpBarProgressTimer setMidpoint:ccp(0.5, 0)];
    [powerUpBarProgressTimer setPosition:ccp(30, 272)];
    [powerUpBarProgressTimer setAnchorPoint:ccp(0, 0)];
    [powerUpBarProgressTimer setPercentage:0.0f];
    [self addChild: powerUpBarProgressTimer z:1]; 
    
    
    timeMeterProgressTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"timeMeter.png"]]; 
    [timeMeterProgressTimer setType:kCCProgressTimerTypeBar];
    [timeMeterProgressTimer setMidpoint:ccp(1, 0.5)];
    [timeMeterProgressTimer setPosition:ccp(143, 349)];
    [timeMeterProgressTimer setAnchorPoint:ccp(0, 0)];
    [timeMeterProgressTimer setPercentage:100.0f];
    [self addChild: timeMeterProgressTimer z:1]; 
    

	scoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(105.0f, 35.0f) alignment:CCTextAlignmentRight fontName:kCommonFontName fontSize:30];
	[scoreLabel setPosition:ccp(200, 600)];
    [scoreLabel setColor:ccc3(232, 98, 51)];
	[self addChild:scoreLabel z:1];
    [scoreLabel setString:[NSString stringWithFormat:@"%lld", score]];
    
    
	pointsAwardedLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(105.0f, 35.0f) alignment:CCTextAlignmentRight fontName:kCommonFontName fontSize:30];
	[pointsAwardedLabel setPosition:ccp(70, 600)];
    [pointsAwardedLabel setColor:ccc3(252, 208, 44)];
	[self addChild:pointsAwardedLabel z:1];
    
    
    letterDoorTopImage = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"letterDoorTop.png"]]; 
    [letterDoorTopImage setPosition:ccp(35, 662)];
    [letterDoorTopImage setAnchorPoint:ccp(0,0)];
    [letterDoorTopImage setType:kCCProgressTimerTypeBar];
    [letterDoorTopImage setMidpoint:ccp(0.5, 1)];
    [letterDoorTopImage setPercentage:0.0f];
    [self addChild: letterDoorTopImage z:15];
    
    letterDoorBottomImage = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"letterDoorBottom.png"]]; 
    [letterDoorBottomImage setPosition:[letterDoorTopImage position]];
    [letterDoorBottomImage setAnchorPoint:ccp(0,0)];
    [letterDoorBottomImage setType:kCCProgressTimerTypeBar];
    [letterDoorBottomImage setMidpoint:ccp(0.5, 0)];
    [letterDoorBottomImage setPercentage:0.0f];
    [self addChild: letterDoorBottomImage z:15];
    
}

-(void) setupLayers
{
    cloudscapeLayer = [CloudscapeLayer node];
	[self addChild:cloudscapeLayer z:-3];
}

-(void) setupGameOverSprites
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];        
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverElements.plist"];
    
	CCMenu * gameOverMenu = [CCMenu menuWithItems:nil];
    [gameOverMenu setPosition:ccp(0, 0)];
    
    CCMenuItemImage *gameOverMainMenuButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameOverMainMenuButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameOverMainMenuButton.png"] target:self selector:@selector(mainMenuButtonPressed)];
    [gameOverMainMenuButton setAnchorPoint:ccp(0, 0)];
    [gameOverMainMenuButton setPosition:ccp(306, -3415)];
    [gameOverMenu addChild:gameOverMainMenuButton];

    
    CCLabelTTF *gameOverMainMenuLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Main Menu Line 1"] dimensions:CGSizeMake(190, 38) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:35];
    CCMenuItemLabel *gameOverMainMenuItemLabel = [CCMenuItemLabel itemWithLabel:gameOverMainMenuLabel target:self selector:@selector(mainMenuButtonPressed)];
    [gameOverMainMenuItemLabel setAnchorPoint:ccp(0, 0)];
	[gameOverMainMenuItemLabel setPosition:ccp(302, -3345)];
    [gameOverMainMenuItemLabel setRotation:-2.0f];
    [gameOverMainMenuItemLabel setColor:ccc3(0, 0, 0)];
	[gameOverMenu addChild:gameOverMainMenuItemLabel];

    CCLabelTTF *gameOverMainMenuLabel2 = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Main Menu Line 2"] dimensions:CGSizeMake(190, 38) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:35];
    CCMenuItemLabel *gameOverMainMenuItemLabel2 = [CCMenuItemLabel itemWithLabel:gameOverMainMenuLabel2 target:self selector:@selector(mainMenuButtonPressed)];
    [gameOverMainMenuItemLabel2 setAnchorPoint:ccp(0, 0)];
	[gameOverMainMenuItemLabel2 setPosition:ccp(302, -3390)];
    [gameOverMainMenuItemLabel2 setRotation:-2.0f];
    [gameOverMainMenuItemLabel2 setColor:ccc3(0, 0, 0)];
	[gameOverMenu addChild:gameOverMainMenuItemLabel2];

    
    
    CCMenuItemImage *gameOverReplayButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"gameOverReplayButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"gameOverReplayButton.png"] target:self selector:@selector(replayGame)];	
    [gameOverReplayButton setAnchorPoint:ccp(0, 0)];
    [gameOverReplayButton setPosition:ccp(150, -3185)];
    [gameOverMenu addChild:gameOverReplayButton];
    
    CCLabelTTF *gameOverReplayLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Replay?"] dimensions:CGSizeMake(190, 38) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:35];
    CCMenuItemLabel *gameOverReplayItemLabel = [CCMenuItemLabel itemWithLabel:gameOverReplayLabel target:self selector:@selector(replayGame)];
    [gameOverReplayItemLabel setAnchorPoint:ccp(0, 0)];
	[gameOverReplayItemLabel setPosition:ccp(212, -3179)];
    [gameOverReplayItemLabel setRotation:-2.5f];
    [gameOverReplayItemLabel setColor:ccc3(255, 250, 174)];
	[gameOverMenu addChild:gameOverReplayItemLabel];

    
    
    [self addChild:gameOverMenu z:1];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];        
    
    gameOverScoreLabel = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(105.0f, 35.0f) alignment:CCTextAlignmentRight fontName:kCommonFontName fontSize:30];
	[gameOverScoreLabel setPosition:ccp(120, -3375)];
    [gameOverScoreLabel setColor:ccc3(39, 20, 10)];
    [gameOverScoreLabel setRotation:-2.0f];
	[self addChild:gameOverScoreLabel z:2];
    [gameOverScoreLabel setString:[NSString stringWithFormat:@"%lld", score]];
    
    CCLabelTTF *gameOverScoreTitleLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Score"] dimensions:CGSizeMake(190, 38) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:35];
    [gameOverScoreTitleLabel setAnchorPoint:ccp(0, 0)];
	[gameOverScoreTitleLabel setPosition:ccp(60, -3345)];
    [gameOverScoreTitleLabel setRotation:-2.0f];
    [gameOverScoreTitleLabel setColor:ccc3(0, 0, 0)];
	[self addChild:gameOverScoreTitleLabel];


    CCLabelTTF *gameOverPanelLabel_1 = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Game Over 1"] dimensions:CGSizeMake(300, 250) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:110];
    [gameOverPanelLabel_1 setAnchorPoint:ccp(0, 0)];
	[gameOverPanelLabel_1 setPosition:ccp(160, -3000)];
    [gameOverPanelLabel_1 setRotation:-3.0f];
    [gameOverPanelLabel_1 setColor:ccc3(0, 0, 0)];
	[self addChild:gameOverPanelLabel_1];

    CCLabelTTF *gameOverPanelLabel_2 = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Game Over 2"] dimensions:CGSizeMake(300, 250) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:110];
    [gameOverPanelLabel_2 setAnchorPoint:ccp(0, 0)];
	[gameOverPanelLabel_2 setPosition:ccp(160, -3095)];
    [gameOverPanelLabel_2 setRotation:-3.0f];
    [gameOverPanelLabel_2 setColor:ccc3(0, 0, 0)];
	[self addChild:gameOverPanelLabel_2];
}

-(void) setupButtons 
{
	CCMenu * mainMenu = [CCMenu menuWithItems:nil];
    mainMenu.position = CGPointZero;
	
    wordEraseButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"wordEraseButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"wordEraseButton.png"] target:self selector:@selector(cleanWordPanel)];    
	[wordEraseButton setPosition:ccp(283, 568)];
	[wordEraseButton setAnchorPoint:ccp(0, 0)];
	[wordEraseButton setVisible:NO];
	[mainMenu addChild:wordEraseButton];
    
	wordCompletedButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"wordCompleteButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"wordCompleteButton.png"] target:self selector:@selector(wordComplete)];
	[wordCompletedButton setPosition:ccp(385, 568)];
	[wordCompletedButton setAnchorPoint:ccp(0, 0)];
	[wordCompletedButton setVisible:NO];
	[mainMenu addChild:wordCompletedButton];
    
    
	pauseButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pauseButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pauseButton.png"] target:self selector:@selector(pauseGame)];
    [pauseButton setPosition:ccp(15, 185)];
    [pauseButton setAnchorPoint:ccp(0,0)];
	[mainMenu addChild:pauseButton];
    
    resumeButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"resumeButton.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"resumeButton.png"] target:self selector:@selector(resumeGame)];
    [resumeButton setPosition:[pauseButton position] ];
    [resumeButton setAnchorPoint:ccp(0,0)];
    [resumeButton setVisible:NO];
    [mainMenu addChild:resumeButton];
    
    
    
    for(int i=0; i<kPowerUpsCount; i++) {
        PowerUpButton *powerUpButton = [[PowerUpButton alloc] initWithPowerUpLevel:i];
        [powerUpButton setGameScene:self];
        [powerUpButtons addObject:powerUpButton];
        
        [mainMenu addChild:powerUpButton];
        [powerUpButton release];
    }
	
	[self addChild:mainMenu z:17];  
    
    
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:nil];
    pauseMenu.position = ccp(0,0);
    
    tubeDoorButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"tubeDoorButtonNormal.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"tubeDoorButtonUp.png"] target:self selector:@selector(mainMenuButtonPressed)];
    [tubeDoorButton setPosition:ccp(614, 1125)];
    [tubeDoorButton setAnchorPoint:ccp(0,0)];
    [pauseMenu addChild:tubeDoorButton z:17];
    
	[self addChild:pauseMenu z:17];  
    
    tubeDoorMainMenu =[CCSprite spriteWithSpriteFrameName:@"tubeDoorMainMenu.png"];
    [tubeDoorMainMenu setPosition:ccp(618, 1131)];
    [tubeDoorMainMenu setAnchorPoint:ccp(0,0)];
    [self addChild: tubeDoorMainMenu z:16];
    
    CCLabelTTF *mainMenuLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Main Menu"] dimensions:CGSizeMake(147, 50) alignment:CCTextAlignmentCenter fontName:kCommonFontName fontSize:20];
    [mainMenuLabel setColor:ccc3(162, 209, 73)];
    mainMenuButton = [CCMenuItemLabel itemWithLabel:mainMenuLabel target:self selector:@selector(mainMenuButtonPressed)];
    [mainMenuButton setPosition: ccp(707, 377)];
	[mainMenuButton setOpacity:0];
	[mainMenuButton setVisible:NO];
    [mainMenuButton setAnchorPoint:ccp(0,0)];
    
    [pauseMenu addChild:mainMenuButton z:17];
}



#pragma mark Game Loop and Updates

-(void) update:(ccTime)deltaTime
{
    if( self.lastTimeTouchMoved !=nil) {
        NSTimeInterval timeSince = [[NSDate date] timeIntervalSinceDate:self.lastTimeTouchMoved];
        if(timeSince >= kShiftPanelLettersDelay) {
            [self shiftLetters];
        }
    }
}

-(void) updateLevelTime:(ccTime)deltaTime 
{
    
    elapsedLevelTime+=deltaTime;
    
    float timerPercentage = 100- ((elapsedLevelTime / totalLevelTime) *100);
    if(timerPercentage>0) {
        [timeMeterProgressTimer setPercentage:timerPercentage];
    }
    
	if( elapsedLevelTime >= totalLevelTime && !isTransitioningLevels ) 
    {
        isTransitioningLevels = YES;
//        [self performSelector:@selector(completeLevel) withObject:nil afterDelay:5.0f];
        [self completeLevel];
    }
    
}

-(void) increaseLevelSpeed
{
    scrollingLettersSpeed += kScrollingLettersSpeedIncreaseTick;
    NSLog(@"Speed increased to %.1f", scrollingLettersSpeed);
}

-(void) updateScrollingLetters:(ccTime)deltaTime 
{
	
	NSMutableArray *lettersToBeDiscarded = [[NSMutableArray alloc] init];
	
	float letterScrollOffsetY = (deltaTime * scrollingLettersSpeed * scrollingLettersSpeedModifier);
	createLetterCounter += letterScrollOffsetY;
	
	for(ScrollingLetter *scrollingLetter in scrollingLetters) {
		if( draggingScrollingLetter != scrollingLetter ) { 
			CGPoint position = [scrollingLetter position];
            CGSize size = [[CCDirector sharedDirector] winSize];
			if(position.x > size.width) {
				[lettersToBeDiscarded addObject:scrollingLetter];
            }else if((position.y <= kFlyAwayPositionY) && ([scrollingLetter numberOfRunningActions] == 0)) {
                id flyAwayAction = [CCMoveTo actionWithDuration:kFlyAwayLetterSpeed position:ccp(size.width+kLetterWidth, kFlyAwayPositionY)];
                [scrollingLetter runAction:flyAwayAction];
			} else {
                [scrollingLetter scrollBy:letterScrollOffsetY];
			}
		}
	}
	
	if([lettersToBeDiscarded count] > 0) {
		[self increaseFailCounter:[lettersToBeDiscarded count]];
	}
	
	[scrollingLetters removeObjectsInArray:lettersToBeDiscarded];
	for(ScrollingLetter *letter in lettersToBeDiscarded) 
    {
		[letter removeFromParentAndCleanup:YES];
	}
	
	[lettersToBeDiscarded release];
	
    
	if( (elapsedLevelTime < totalLevelTime) && (createLetterCounter>= kLetterHeight) && !isTransitioningLevels) 
    {
		[self createNewLetter];
    }
    
}

-(void) humanKeepAlive:(ccTime)deltaTime
{
    if ( [[humanSprite humanSprite] numberOfRunningActions] > 0 ) { return; }
    
    int chance = arc4random() % 100;
    
    if(chance <= 40) 
    {
        [humanSprite blinkAnimation];
    }
}



-(void) increaseFailCounter:(float) val 
{
	failCounter+=val;
    [gameSoundManager playLetterFailSound];
    
	if( failCounter > kMaxLives )  
    {
        [self gameOver];
    }
    

    
    [self updateTemperatureGauge];
    
    if( !isSlowDownPowerUpActive ) 
    {
        [gameSoundManager adjustBackgroundMusicPitchForFailCounter:failCounter];
    }
    
    [alienSprite showAngrySpeechBubble];

}

-(void) decreaseFailCounter:(float) val 
{
	failCounter-=val;
    
	if(failCounter<0) {
        
        int powerUpIncrease = fabs(failCounter);
        [self increasePowerUpMeter:powerUpIncrease];
        
        failCounter=0;
        [self resetTemperatureGauge];
    } else {
        [self updateTemperatureGauge];
    }
    
    if( !isSlowDownPowerUpActive ) 
    {
        [gameSoundManager adjustBackgroundMusicPitchForFailCounter:failCounter];
    }
    
//    if( failCounter < 5 && failCounter>0)  
//    {
        [alienSprite showHappySpeechBubble];
//    }

}

-(void) resetTemperatureGauge
{
    id rotateAction = [CCRotateTo actionWithDuration:kTemperatureGaugeAnimationDuration angle:(kTemperatureGaugeAngleMax*-1)];
    [temperatureGaugeArrowImage runAction:rotateAction];
}

-(void) updateTemperatureGauge
{
    
    float lives = kMaxLives - failCounter;
    float angle = (kTemperatureGaugeAngleMax) - (temperatureArrowAngleTick*lives);
    
    id rotateAction = [CCRotateTo actionWithDuration:kTemperatureGaugeAnimationDuration angle:angle];
    [temperatureGaugeArrowImage runAction:rotateAction];
    
    if( failCounter > kTemperatureGaugeBeginOverheat ) 
    {
        if( ![smokeEmitterTemperatureGauge active] )
        {
            [smokeEmitterTemperatureGauge resetSystem];
            
            id temperatureMeterFadeIn = [CCFadeIn actionWithDuration:1.0f];
            id temperatureMeterFadeOut = [CCFadeOut actionWithDuration:1.0f];
            id temperatureMeterPulsate = [CCSequence actionOne:temperatureMeterFadeIn two:temperatureMeterFadeOut];
            id repeatAnimation = [CCRepeatForever actionWithAction:temperatureMeterPulsate];
            [temperatureMeterGlow runAction:repeatAnimation];
            
            [gameSoundManager startTemperatureOverheatSound];
        }
    } else 
    {
        if( [smokeEmitterTemperatureGauge active] )
        {
            [smokeEmitterTemperatureGauge stopSystem];
            [temperatureMeterGlow stopAllActions];
            [temperatureMeterGlow setOpacity:0];
            
            [gameSoundManager stopTemperatureOverheatSound];
        }
        
    }

}

-(void) createNewLetter {
    
    createLetterCounter = 0;
    
	if(throwScrambledWord) 
    {
        throwScrambledWord=NO;
        
        NSString *randomWord = [dictionary getRandomWordWithLenght:kScrambledWordLength];
        NSString *scrambledRandomWord = [dictionary scrambleWord:randomWord];
        
        for(int i=0; i<[scrambledRandomWord length]; i++) 
        {
            ScrollingLetter *newLetter = [[ScrollingLetter alloc] initWithLetter:[scrambledRandomWord characterAtIndex:i] isScrambledWord:YES indexInWord:i];
            [scrollingLetters addObject:newLetter];
            [self addChild:newLetter z:2];
            [newLetter release];	
        }
        
    } else if(throwWildcard) 
    {
        throwWildcard = NO;
        
        ScrollingLetter *newLetter = [[ScrollingLetter alloc] initWithWildcard];
        [self addChild:newLetter z:2];
        [scrollingLetters addObject:newLetter];
        [newLetter release];	
        
    } else 
    {
        ScrollingLetter *newLetter = [[ScrollingLetter alloc] initWithLetter:[dictionary getNewLetter]];
        [self addChild:newLetter z:2];
        [scrollingLetters addObject:newLetter];
        [newLetter release];	
    }    
}

-(void) increaseScore:(int64_t) val 
{
	score += val;
	[scoreLabel setString:[NSString stringWithFormat:@"%lld", score]];
    
    [pointsAwardedLabel setString:[NSString stringWithFormat:@"+%lld", val]];
    id showAction = [CCShow action];
    id fadeOutAction = [CCFadeOut actionWithDuration:kPointsAwardedLabelFadeOutDuration];
    
    [pointsAwardedLabel runAction:showAction];
    [pointsAwardedLabel runAction:fadeOutAction];
}

-(void) completeLevel 
{
    isTransitioningLevels = YES;
    [self discardHuman];
}

-(void) discardHuman
{
    if(isGameOver) { return; }
    
    tubeDoorSprite = [[TubeDoorSprite alloc] init];
    [tubeDoorSprite tubeDoorSpriteForScene:self];

    [tubeDoorSprite runCloseAnimation];
    
    [gameSoundManager performSelector:@selector(playHumanFlushSound) withObject:nil afterDelay:kHumanFlushSoundDelay];
    [self performSelector:@selector(discardLetters) withObject:nil afterDelay:kHumanFlushSoundDelay];
    [self performSelector:@selector(bringNewHuman) withObject:nil afterDelay:kHumanLevelTransitionAnimationDuration];
}

-(void) discardLetters
{
    [self cleanWordPanel];
    [self removeAllScrollingLetters];
    
}

-(void) removeAllScrollingLetters
{
    for(ScrollingLetter *scrollingLetter in scrollingLetters)
    {
        id fadeOutLetter = [CCFadeOut actionWithDuration:1.5f];
        [scrollingLetter runAction:fadeOutLetter];
    }
    
    [scrollingLetters removeAllObjects];
}

-(void) beamUpNewHuman
{
    id playOpenTrapDoorSound = [CCCallFunc actionWithTarget:gameSoundManager selector:@selector(playTrapDoorSound)];
    id openTrapDoor = [CCMoveBy actionWithDuration:0.5f position:ccp(170,0)];
    id delayTrapDoor = [CCDelayTime actionWithDuration:2.0f];
    id playCloseTrapDoorSound = [CCCallFunc actionWithTarget:gameSoundManager selector:@selector(playTrapDoorSound)];
    id closeTrapDoor = [CCMoveBy actionWithDuration:0.5f position:ccp(-170,0)];
    [trapDoorImage runAction:[CCSequence actions:playOpenTrapDoorSound, openTrapDoor, delayTrapDoor, playCloseTrapDoorSound, closeTrapDoor, nil]];
    
    tractorBeam = [CCSprite spriteWithSpriteFrameName:@"tractorBeam.png"];
    [tractorBeam setPosition:ccp(382,50)];
    [tractorBeam setOpacity:0];
    [self addChild:tractorBeam z:-2];
    id fadeInTractorBeam = [CCFadeIn actionWithDuration:0.5f];
    [tractorBeam runAction:fadeInTractorBeam];
    [gameSoundManager playTractorBeamSound];
    
    id delayTractorBeamRemoval = [CCDelayTime actionWithDuration:3.0f];
    id fadeOutTractorBeam = [CCFadeOut actionWithDuration:0.5f];
    id removeTractorBeam = [CCCallFunc actionWithTarget:tractorBeam selector:@selector(removeFromParentAndCleanupYES)];
    
    [tractorBeam runAction:[CCSequence actions:delayTractorBeamRemoval, fadeOutTractorBeam, removeTractorBeam, nil]];

}

-(void) bringNewHuman
{
    int64_t scoreIncrease = kHumanScorePerLevel*level;
    score += scoreIncrease;
	[scoreLabel setString:[NSString stringWithFormat:@"%lld", score]];
    
    CGPoint position = ccp(390, 450);
    CCLabelTTF *humanScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%lld", scoreIncrease] fontName:kCommonFontName fontSize:40];
    [humanScoreLabel setColor:ccc3(0, 210, 156)];
    [humanScoreLabel setPosition:position];
    [humanScoreLabel setOpacity:0];

    [self addChild:humanScoreLabel z:12];
    
    [self beamUpNewHuman];
    
    id fadeOut = [CCFadeOut actionWithDuration:kScorePointsAnimationDuration];
    id moveAway = [CCMoveTo actionWithDuration:kScorePointsAnimationDuration position:ccp(position.x, position.y+kScorePointsLabelAnimationOffset)];
    id playScoreSound = [CCCallFunc actionWithTarget:gameSoundManager selector:@selector(playNewHumanScoreSound)];
    id spawn = [CCSpawn actionOne:fadeOut two:moveAway];
    id cleanUp = [CCCallFunc actionWithTarget:humanScoreLabel selector:@selector(removeFromParentAndCleanupYES)];

    [humanScoreLabel runAction:[CCSequence actions:playScoreSound, spawn, cleanUp, nil]];

    [tubeDoorSprite runOpenAnimation];
    [tubeDoorSprite performSelector:@selector(release) withObject:nil afterDelay:3.0f];
   
    [humanSprite cleanUp];
    [humanSprite release];

    humanSprite = [[HumanSprite alloc] init];
    [humanSprite humanSpriteForScene:self];
    
    [self performSelector:@selector(startNextLevel) withObject:nil afterDelay:kHumanLevelTransitionAnimationDuration];
}



-(void) startNextLevel
{
    level++;
    [self increaseLevelSpeed];
    NSLog(@"Starting level %d with speed %f", level, scrollingLettersSpeed);
    isTransitioningLevels = NO;
    elapsedLevelTime = 0;
    [[PlaytomicManager getInstance] logLevel:level];
}

-(void) pauseGame 
{    
    [gameSoundManager pauseGameLoopMusic];
    [gameSoundManager playClickSound];
    
    [resumeButton setVisible:YES];
    [pauseButton setVisible:NO];
    
    [self unscheduleUpdate];
    [self unschedule:@selector(increaseLevelSpeed:)];
    [self unschedule:@selector(updateLevelTime:)];
    [self unschedule:@selector(updateScrollingLetters:)];
    
    id moveDownTubeDoor = [CCMoveTo actionWithDuration:kMoveTubeDoorSpeed position:ccp(479, 61)];
    [tubeDoorImage runAction:moveDownTubeDoor];
    
    id moveDownPauseMenuButton = [CCMoveTo actionWithDuration:kMoveTubeDoorSpeed position:ccp(614, 380)];
    [tubeDoorButton runAction:moveDownPauseMenuButton];
    
    id moveDownTubeDoorMainMenu = [CCMoveTo actionWithDuration:kMoveTubeDoorSpeed position:ccp(605, 363)];
    [tubeDoorMainMenu runAction:moveDownTubeDoorMainMenu];
    
    [mainMenuButton setVisible:YES];
    id delay = [CCDelayTime actionWithDuration:kMoveTubeDoorSpeed];
    id fadeInMainMenuButton = [CCFadeIn actionWithDuration:kMoveTubeDoorSpeed];
    [mainMenuButton runAction:[CCSequence actions:delay, fadeInMainMenuButton, nil]];
    
    id moveDownLetterDoors = [CCProgressFromTo actionWithDuration:kMoveTubeDoorSpeed from:0 to:100];
    [letterDoorTopImage runAction:moveDownLetterDoors];
    id moveDownLetterDoors1 = [CCProgressFromTo actionWithDuration:kMoveTubeDoorSpeed from:0 to:100];
    [letterDoorBottomImage runAction:moveDownLetterDoors1];
    
    [smokeEmitterTemperatureGauge stopSystem];
    [temperatureMeterGlow stopAllActions];
    [temperatureMeterGlow setOpacity:0];
    [gameSoundManager stopTemperatureOverheatSound];
}

-(void) resumeGame 
{
    [gameSoundManager playClickSound];
    [gameSoundManager resumeGameLoopMusic];
    
    [resumeButton setVisible:NO];
    [pauseButton setVisible:YES];
    
    [self scheduleUpdate];
    [self schedule:@selector(updateLevelTime:) interval:kUpdateLevelTimeFrequency];
    [self schedule:@selector(updateScrollingLetters:) interval:kUpdateScrollingLettersFrequency];
    
    id fadeOutMainMenuButton = [CCFadeOut actionWithDuration:kMoveTubeDoorSpeed];
    id hideMainMenuButton = [CCCallBlock actionWithBlock:^{ [mainMenuButton setVisible:NO]; }];
    id hideMainMenuButtonSequence =[CCSequence actions:fadeOutMainMenuButton, hideMainMenuButton, nil];
    [mainMenuButton runAction:hideMainMenuButtonSequence];
    
    id delay = [CCDelayTime actionWithDuration:kMoveTubeDoorSpeed];
    
    id moveUpTubeDoor=  [CCMoveTo actionWithDuration:kMoveTubeDoorSpeed position:ccp(479, 92+768)];
    [tubeDoorImage runAction:[CCSequence actions:delay, moveUpTubeDoor, nil]];
    
    id moveUpPauseMenuButton = [CCMoveTo actionWithDuration:kMoveTubeDoorSpeed position:ccp(614, 1125)];
    [tubeDoorButton runAction:[CCSequence actions:delay, moveUpPauseMenuButton, nil]];
    
    id moveUpTubeDoorMainMenu = [CCMoveTo actionWithDuration:kMoveTubeDoorSpeed position:ccp(605, 363+768)];
    [tubeDoorMainMenu runAction:[CCSequence actions:delay, moveUpTubeDoorMainMenu, nil]];
    
    id moveUpLetterDoors = [CCProgressFromTo actionWithDuration:kMoveTubeDoorSpeed from:100 to:0];
    [letterDoorTopImage runAction:moveUpLetterDoors];
    id moveUpLetterDoors1 = [CCProgressFromTo actionWithDuration:kMoveTubeDoorSpeed from:100 to:0];
    [letterDoorBottomImage runAction:moveUpLetterDoors1];
    
    if( failCounter > kTemperatureGaugeBeginOverheat ) 
    {
        [smokeEmitterTemperatureGauge resetSystem];
        
        id temperatureMeterFadeIn = [CCFadeIn actionWithDuration:1.0f];
        id temperatureMeterFadeOut = [CCFadeOut actionWithDuration:1.0f];
        id temperatureMeterPulsate = [CCSequence actionOne:temperatureMeterFadeIn two:temperatureMeterFadeOut];
        id repeatAnimation = [CCRepeatForever actionWithAction:temperatureMeterPulsate];
        [temperatureMeterGlow runAction:repeatAnimation];
        
        [gameSoundManager startTemperatureOverheatSound];
    }
}

-(BOOL) isPaused 
{
    return [resumeButton visible];
}


-(void) replayGame
{
    [gameSoundManager playClickSound];
    [self setPosition:ccp(0,0)];
    [self showLoadingImageWithFade:NO];

    [self performSelector:@selector(restartScene) withObject:nil afterDelay:0.5f];
}

-(void) restartScene
{
    [self unloadAll];
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]]; 
}

-(void) mainMenuButtonPressed
{
    [gameSoundManager playClickSound];
    [self setPosition:ccp(0,0)];
    [self showLoadingImageWithFade:NO];
    [self performSelector:@selector(goToMainMenu) withObject:nil afterDelay:0.5f];

}

-(void) goToMainMenu
{
    [self unloadAll];    
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]]; 
}




-(void) gameOver 
{
    if(isTransitioningLevels) 
    {
        NSLog(@"GameOver activated but waiting on level transition to finish...");
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:0.5f];
        return;
    }
        
    isGameOver = YES;
    
    [gameSoundManager stopGameLoopMusic];
    [gameSoundManager stopTemperatureOverheatSound];
    [gameSoundManager playShutDownSound];
    [self unschedule:@selector(updateScrollingLetters:)];
    [self unschedule:@selector(increaseLevelSpeed:)];
    [self unschedule:@selector(updateLevelTime:)];
    [self unschedule:@selector(alienMovement:)];
    [self unschedule:@selector(humanKeepAlive:)];
    [self setupGameOverSprites];

    
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    [appDelegate setPlayerScore:score];
    [appDelegate setPowerUpValue:powerUpMeterValue];
    [appDelegate setFailCounterValue:failCounter];
    [[GameCenterManager getInstance] reportScore:score forCategory:[appDelegate currentGameMode]];
    [gameOverScoreLabel setString:[NSString stringWithFormat:@"%lld", score]];
    
    
    [cloudscapeLayer slowDownAndStop];
    [self gameOverAnimation];
    
    [[PlaytomicManager getInstance] logGameOverWithScore:score forLevel:level];
}

-(void) gameOverAnimation
{    
    id moveTrapDoorImage = [CCMoveBy actionWithDuration:0.5f position:ccp(170,0)];
    [trapDoorImage runAction:moveTrapDoorImage];
    [gameSoundManager playTrapDoorSound];
    
    id delayAlienWalkAway = [CCDelayTime actionWithDuration:0.2f];
    id startWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(startWalkAnimation)];
    id alienWalkAway = [CCMoveBy actionWithDuration:2.0f position:ccp(-500, 0)];
    id stopWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(stopWalkAnimation)];
    [alienSprite.alienSprite runAction:[CCSequence actions:delayAlienWalkAway, startWalkAnimation, alienWalkAway, stopWalkAnimation, nil]];
    
    
    FeathersSprite *feathersSprite = [FeathersSprite feathersSpriteForScene:self];
    
    id delayDropHumanGameOver = [CCDelayTime actionWithDuration:1.0f];
    id playHumanFallingSound = [CCCallFuncND actionWithTarget:gameSoundManager selector:@selector(playHumanSoundWithId:data:) data:[NSNumber numberWithInt:[humanSprite getHumanId]]];
    id dropHumanGameOver = [CCMoveBy actionWithDuration:kDropHumanGameOverAnimationDuration position:ccp(0, -3950)];
    id playFeatherSound = [CCCallFunc actionWithTarget:gameSoundManager selector:@selector(playFeathersSound)];
    id humanSequence =[CCSequence actions:delayDropHumanGameOver, playHumanFallingSound, dropHumanGameOver, playFeatherSound, [CCCallFuncN actionWithTarget:feathersSprite selector:@selector(runFeathersAnimation)],[CCCallFuncN actionWithTarget:humanSprite selector:@selector(hide)],nil];
    [[humanSprite humanSprite] runAction:humanSequence];
    
    
    [humanSprite runDropAndFallAnimation];
    
    id delayPan = [CCDelayTime actionWithDuration:1.5f];
    id panGameOver = [CCMoveTo actionWithDuration:kPanGameOverAnimationDuration position:ccp(0, (screenSize.height*5))];
    
    [self runAction:[CCSequence actions:delayPan, panGameOver, nil]];   
    
    
    TruckSprite *truckSprite = [TruckSprite truckSpriteForScene:self];
    [truckSprite runTruckAnimation];
    [gameSoundManager performSelector:@selector(playTruckSound) withObject:nil afterDelay:4.0f];

    [self removeAllScrollingLetters];
}




-(CGPoint) newAlienPosition
{
    CGPoint alienPosition = [alienSprite.alienSprite position];
    
    float moveOnX = 70, moveOnY = 10;
    float minX = 160,    maxX = 290;
    float minY = 180,   maxY = 200;

    
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

#pragma mark Touch Events

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if([[event allTouches] count] > 1) { return; }
    
    if( [self isPaused] ) {return;}
    
	UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	gestureStartPoint = touchLocation;
    
    if(touchLocation.x >= kScrollAreaWidth) {
        [self scrollingLetterTapped];
    }
}



- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if( [self isPaused] ) {return;}
    
	UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    
    if(touchLocation.x < kScrollAreaWidth && draggingScrollingLetter == nil) {
        [self dragLetterInSlot:touch];
    }
    
    
	[draggingScrollingLetter setPosition:touchLocation];	
    
    if(draggingScrollingLetter != nil) {
        
        if( [self isHoveringPannelLetter] ) {
            self.lastTimeTouchMoved = [NSDate date];
        } else {
            self.lastTimeTouchMoved = nil;
        }
        
    } else {
        self.lastTimeTouchMoved = nil;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
    if( [self isPaused] ) {return;}
    
    self.lastTimeTouchMoved = nil;
    
	UITouch *touch = [[[event allTouches] allObjects] objectAtIndex:0];
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    NSUInteger tapCount = [touch tapCount];
    
    switch (tapCount) {
        case 0:
        case 1:
            [self tapToReturnLetter:[NSValue valueWithCGPoint:touchLocation]];
            [self placeDraggingScrollingLetterInSlot];
            break;
        default:
            break;
    }
    
    //[self performSelectorInBackground:@selector(evaluateWord) withObject:nil];
    [self evaluateWord];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event { 
    [self ccTouchesEnded:touches withEvent:event];
}

-(void) dragLetterInSlot:(UITouch*) touch
{
	CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    for(LetterSlot *letterSlot in letterSlots) {
        if(CGRectContainsPoint([letterSlot boundingBox], touchLocation)) {
            
            draggingScrollingLetter = [letterSlot scrollingLetterInSlot];
            [letterSlot setScrollingLetterInSlot:nil];
            
            break;
        }
    }   
}

-(void) placeDraggingScrollingLetterInSlot
{
    BOOL shouldReturnLetterToOriginalPlace = YES;
    
    for(LetterSlot *letterSlot in letterSlots) 
    {
        if( CGRectIntersectsRect([letterSlot boundingBox], [draggingScrollingLetter boundingBox])) 
        {
            if( [letterSlot scrollingLetterInSlot] == nil ) 
            {
                shouldReturnLetterToOriginalPlace = NO;
                [draggingScrollingLetter setScrolling:NO];
                id moveToAction = [CCMoveTo actionWithDuration:kMoveLetterToSlotAnimationSpeed position:[letterSlot position]];
                [draggingScrollingLetter runAction:moveToAction];
                [letterSlot setScrollingLetterInSlot:draggingScrollingLetter];
                break;
            }
        }
    }
    
    if(shouldReturnLetterToOriginalPlace) 
    {
        [draggingScrollingLetter returnToOriginalPositionOnScrollingArea:scrollingLetters];
    } else 
    {
    }
    
    
	draggingScrollingLetter = nil; 
}



-(void) tapToReturnLetter:(NSValue*) touchPoint
{
    if( draggingScrollingLetter != nil ) { return; }
    
    CGPoint point = [touchPoint CGPointValue];	
    
    if(point.x>=kScrollAreaWidth)
    {
        return;
    }
    
    for(LetterSlot *letterSlot in letterSlots) 
    {
        if( CGRectContainsPoint([letterSlot boundingBox], point)) 
        {
            [letterSlot.scrollingLetterInSlot returnToOriginalPositionOnScrollingArea:scrollingLetters];
            [letterSlot setScrollingLetterInSlot:nil];                
            break;
        }
    }
    
}


-(BOOL) isHoveringPannelLetter {
    
    CGPoint position = draggingScrollingLetter.position; 
    
    if(     position.x < (kFirstLetterSlotX-(kLetterWidth/2))  ||
       position.y < (kFirstLetterSlotY-(kLetterHeight/2)) ||
       position.y > (kFirstLetterSlotY+(kLetterHeight/2)) ) 
    {
        return NO;
    }
    
    for(int i=0; i<[letterSlots count]; i++) {
        LetterSlot *letterSlot = [letterSlots objectAtIndex:i];
        if(letterSlot.scrollingLetterInSlot != nil) {
            if( CGRectContainsPoint([letterSlot boundingBox], position) ) {
                letterToBeShifted = i;
                return YES;
            }
        }
    }
    
    return NO;
    
}

-(void) shiftLetters {
    
    self.lastTimeTouchMoved = [NSDate date];
    int shiftToSlot;
    int shiftFromSlot = letterToBeShifted;
    BOOL shiftToLeft = NO;
    BOOL shiftToRight = NO;
    
    for(int i=letterToBeShifted; i>=0; i--) {
        LetterSlot *letterSlot = [letterSlots objectAtIndex:i];
        if( letterSlot.scrollingLetterInSlot == nil  ) {
            shiftToLeft = YES;
            shiftToSlot = i;
            break;
        }
    }
    if(!shiftToLeft) {
        for(int i=letterToBeShifted; i<[letterSlots count]; i++) {
            LetterSlot *letterSlot = [letterSlots objectAtIndex:i];
            if( letterSlot.scrollingLetterInSlot == nil  ) {
                shiftToRight = YES;
                shiftToSlot = i;
                break;
            }
        }
        
    }
    
    
    if(!shiftToLeft && ! shiftToRight) {
        return;
    }
    
    
    int increment=-1;
    if(shiftToLeft) { increment=1; }
    
    while( shiftFromSlot != shiftToSlot ) {
        
        LetterSlot *fromLetterSlot = [letterSlots objectAtIndex:shiftToSlot+increment];
        LetterSlot *toLetterSlot = [letterSlots objectAtIndex:shiftToSlot];
        
        id moveToAction = [CCMoveTo actionWithDuration:kMoveLetterToSlotAnimationSpeed position:[toLetterSlot position]];
        [fromLetterSlot.scrollingLetterInSlot runAction:moveToAction];
        
        [toLetterSlot setScrollingLetterInSlot:[fromLetterSlot scrollingLetterInSlot]];
        [fromLetterSlot setScrollingLetterInSlot:nil];
        
        
        shiftToSlot = shiftToSlot + increment;
    }
}



-(void) scrollingLetterTapped {
    
    for(ScrollingLetter *scrollingLetter in scrollingLetters) {
        
        if( CGRectContainsPoint([scrollingLetter boundingBox], gestureStartPoint) ) {
            
            if( [scrollingLetter scrolling] ) {
				[scrollingLetter rememberOriginalPositionOnScrollingArea];
			}
            
            for(LetterSlot *letterSlot in letterSlots) {
                if( [letterSlot scrollingLetterInSlot] == nil ) {
                    [scrollingLetter setScrolling:NO];
                    [letterSlot setScrollingLetterInSlot:scrollingLetter];
                    
                    [gameSoundManager playTapLetterSound];
                    
                    id moveToAction = [CCMoveTo actionWithDuration:kMoveLetterToSlotAnimationSpeed position:[letterSlot position]];
                    //id easeOut = [CCEaseOut actionWithAction:moveToAction rate:20];
                    [scrollingLetter runAction:moveToAction];
                    [self performSelectorInBackground:@selector(evaluateWord) withObject:nil];
                    
                    return;				
                }
            }
        }
    }
    
}

#pragma mark Dictionary methods

-(void) evaluateWord 
{    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    BOOL showWordCompletedButton = NO;
    
	NSString *currentWordInPanel = [[NSString alloc] initWithString:[self currentWordInPanel]];
    
    if( [currentWordInPanel length]>=kMinimumWordLength ) {
        if([dictionary isOnDictionary:currentWordInPanel] ) {	
            showWordCompletedButton = YES;
            NSLog(@"Word is valid");
            [self performSelector:@selector(showTutorialNumber:) withObject:[NSNumber numberWithInt:2] afterDelay:0.5f];
        }
    }
    
    [wordEraseButton setVisible:(currentWordInPanel.length > 0) ];
    
    [wordCompletedButton setVisible:showWordCompletedButton];
    [currentWordInPanel release];
//    [pool release];
}

-(NSString *) currentWordInPanel 
{
	NSString *currentWordInPanel = [NSString stringWithString:@""];
	
	for(LetterSlot *letterSlot in letterSlots) 
    {
		if( [letterSlot scrollingLetterInSlot] == nil ) 
        {
			currentWordInPanel = [currentWordInPanel stringByAppendingString:@" "];
		} else 
        {
			currentWordInPanel = [currentWordInPanel stringByAppendingFormat:@"%@", [[letterSlot scrollingLetterInSlot] getLetter]];
		}
	}
	
	currentWordInPanel = [currentWordInPanel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return currentWordInPanel;
}

-(void) cleanWordPanel 
{
    if( [self isPaused] ) {return;}
    
    [gameSoundManager playReturnLettersSound];
    
    [wordEraseButton setVisible:NO];
    [wordCompletedButton setVisible:NO];
    
	for(LetterSlot *letterSlot in letterSlots) 
    {
		if( [letterSlot scrollingLetterInSlot] != nil ) 
        {
			[[letterSlot scrollingLetterInSlot] returnToOriginalPositionOnScrollingArea:scrollingLetters];
			[letterSlot setScrollingLetterInSlot:nil];
		}
	}
}

-(void) wordComplete 
{    
    if( [self isPaused] ) {return;}
    
	
	NSString *word = [self currentWordInPanel];
	
    if( ![dictionary wasWordAlreadySpelled:word] ) 
    {
        [self decreaseFailCounter:[word length]];
    }
    
    int64_t scoreIncrease = [dictionary wordScore:word];
    
    [self animateWordScore];
    
    BOOL wasScrambledWord = YES;
	for(LetterSlot *letterSlot in letterSlots) {
        if( [word length] != kScrambledWordLength || (letterSlot.scrollingLetterInSlot != nil &&  ![letterSlot.scrollingLetterInSlot isScrambledWord])) 
        {
            wasScrambledWord = NO;
        }
        
		[scrollingLetters removeObject:[letterSlot scrollingLetterInSlot]];
		[[letterSlot scrollingLetterInSlot] removeFromParentAndCleanup:YES];
		[letterSlot setScrollingLetterInSlot:nil];
	}
    
    if(wasScrambledWord) {
        scoreIncrease = scoreIncrease*2;
        //TODO: show animation for wordScramble bonus
    }
    
    [self increaseScore:scoreIncrease];
    
	[wordCompletedButton setVisible:NO];
    [wordEraseButton setVisible:NO];
    
    [scoreUpImage setVisible:YES];    
    [scoreUpImage performSelector:@selector(setVisible:) withObject:NO afterDelay:kScorePointsAnimationDuration];
}

-(void) animateWordScore
{
    float x = kFirstLetterSlotX;
    int red = 246, green = 146, blue = 30;
    float animationDelay = 0.0f;
    float offset = kScorePointsLabelAnimationOffset;
    float delay = 0.1f;
    
    for(int i=0; i<[dictionary.letterScoreValues count]; i++)
    {

        NSNumber *letterScoreValue = [dictionary.letterScoreValues objectAtIndex:i];
        NSString *valueString = [NSString stringWithFormat:@"+%d", [letterScoreValue intValue]];

        CGPoint position = ccp(x, kFirstLetterSlotY+(kLetterHeight/2));

        CCLabelTTF *letterScoreLabel = [CCLabelTTF labelWithString:valueString fontName:kCommonFontName fontSize:30];
        [letterScoreLabel setColor:ccc3(red, green, blue)];
        [letterScoreLabel setPosition:position];
        [letterScoreLabel setOpacity:0];
        
        [self addChild:letterScoreLabel];
        
        id delayAction = [CCDelayTime actionWithDuration:animationDelay];
        id fadeOut = [CCFadeOut actionWithDuration:kScorePointsAnimationDuration];
        id moveAway = [CCMoveTo actionWithDuration:kScorePointsAnimationDuration position:ccp(position.x, position.y+offset)];
        id playScoreSound = [CCCallFuncND actionWithTarget:gameSoundManager selector:@selector(playScoreSoundForLetterNumber:data:) data:[NSNumber numberWithInt:(i+1)]];
        id spawn = [CCSpawn actionOne:fadeOut two:moveAway];
        id cleanUp = [CCCallFunc actionWithTarget:letterScoreLabel selector:@selector(removeFromParentAndCleanupYES)];
        
        [letterScoreLabel runAction:[CCSequence actions:delayAction, playScoreSound, spawn, cleanUp, nil]];
        
        x+= kLetterWidth + kLetterSlotXSpacing;
        green+=10;
        animationDelay+=delay;
    }

    
    
    x = kFirstLetterSlotX;
    red = 0, green = 168, blue = 156;
    offset = offset*-1;
    animationDelay = 0.0f;

    for(int i=0; i<[dictionary.streakScoreValues count]; i++)
    {
        NSNumber *streakScoreValue = [dictionary.streakScoreValues objectAtIndex:i];
        NSString *valueString = [NSString stringWithFormat:@"+%d", [streakScoreValue intValue]];
        
        CGPoint position = ccp(x, kFirstLetterSlotY-(kLetterHeight/2));
        
        CCLabelTTF *letterScoreLabel = [CCLabelTTF labelWithString:valueString fontName:kCommonFontName fontSize:30];
        [letterScoreLabel setColor:ccc3(red, green, blue)];
        [letterScoreLabel setPosition:position];
        [letterScoreLabel setOpacity:0];
        [self addChild:letterScoreLabel];
        
        id delayAction = [CCDelayTime actionWithDuration:animationDelay];
        id fadeOut = [CCFadeOut actionWithDuration:kScorePointsAnimationDuration];
        id moveAway = [CCMoveTo actionWithDuration:kScorePointsAnimationDuration position:ccp(position.x, position.y+offset)];
        id spawn = [CCSpawn actionOne:fadeOut two:moveAway];
        id cleanUp = [CCCallFunc actionWithTarget:letterScoreLabel selector:@selector(removeFromParentAndCleanupYES)];
        
        [letterScoreLabel runAction:[CCSequence actions:delayAction, spawn, cleanUp, nil]];
        
        x+= kLetterWidth + kLetterSlotXSpacing;
        green+=10;
        animationDelay+=delay;
    }

}

#pragma mark Power Ups

-(void) increasePowerUpMeter:(int) powerUpIncrease 
{
    [self performSelector:@selector(showTutorialNumber:) withObject:[NSNumber numberWithInt:3] afterDelay:0.5f];

    powerUpMeterValue += powerUpIncrease;
    [self updatePowerUpMeter];
}

-(void) resetPowerUpMeterToLevel:(int) powerUpLevelReset
{
    PowerUpButton *powerUpButton = [powerUpButtons objectAtIndex:powerUpLevelReset];
    [powerUpButton setVisible:NO];
    
    currentPowerUpFilling = 1;
    powerUpMeterValue = 0;
    
    for(PowerUpButton *powerUpButton in powerUpButtons)
    {
        if( ![powerUpButton visible] )
        {
            break;
        }
        currentPowerUpFilling++;
    }
    
    [self updatePowerUpMeter];
}

-(void) updatePowerUpMeter
{
    float powerUpLevelTotal[5]= {10,10,20,20,30};    
    float powerUpTotalBar = powerUpLevelTotal[currentPowerUpFilling-1];
    
    NSLog(@"PowerUp total bar is %.1f", powerUpTotalBar);
    
    if(powerUpMeterValue >= powerUpTotalBar)
    {
        
        NSLog(@"Power up %d filled", currentPowerUpFilling);
        [gameSoundManager playPowerUpBarFillSound];
        
        PowerUpButton *powerUpButton = [powerUpButtons objectAtIndex:currentPowerUpFilling-1];
        [powerUpButton setVisible:YES];
        
        currentPowerUpFilling++;
        
        if( currentPowerUpFilling > kPowerUpsCount) 
        {
            currentPowerUpFilling = kPowerUpsCount;
        } else 
        {
            
            while(currentPowerUpFilling<kPowerUpsCount)
            {
                powerUpButton = [powerUpButtons objectAtIndex:currentPowerUpFilling-1];
                if( [powerUpButton visible] ) 
                {
                    currentPowerUpFilling++;
                } else {
                    break;
                }
            }
            powerUpMeterValue=0;          
        }
        
        [self performSelector:@selector(showTutorialNumber:) withObject:[NSNumber numberWithInt:4] afterDelay:0.5f];
    }
    
    float powerUpPercentage = (powerUpMeterValue/powerUpTotalBar) * 100;  
    
    if(powerUpPercentage>100) { powerUpPercentage=100; }
    
    id progressToAction = [CCProgressTo actionWithDuration:kPowerUpBarAnimationDuration percent:powerUpPercentage];
    [powerUpBarProgressTimer runAction:progressToAction];
}

-(void) activateSlowDownPowerUp
{    
    [humanSprite.humanSprite pauseSchedulerAndActions];
    
    id showHumanTubeFrozen = [CCFadeIn actionWithDuration:1.0f];
    id showLetterTubeFrozen = [CCFadeIn actionWithDuration:1.0f];
    [humanTubeFrozen runAction:showHumanTubeFrozen];
    [letterTubeFrozen runAction:showLetterTubeFrozen];
    
    [gameSoundManager playPowerUpFreezeSound];
    isSlowDownPowerUpActive = YES;
    scrollingLettersSpeedModifier = kScrollingLettersSpeedModifierPowerUp;
    [gameSoundManager slowDownBackgroundMusic];
    [self performSelector:@selector(deactivateSlowDownPowerUp) withObject:self afterDelay:kScrollingLettersSpeedModifierPowerUpDuration];
}

-(void) deactivateSlowDownPowerUp
{
    id hideHumanTubeFrozen = [CCFadeOut actionWithDuration:1.0f];
    id hideLetterTubeFrozen = [CCFadeOut actionWithDuration:1.0f];
    [humanTubeFrozen runAction:hideHumanTubeFrozen];
    [letterTubeFrozen runAction:hideLetterTubeFrozen];
    
    [gameSoundManager playPowerUpUnfreezeSound];
    isSlowDownPowerUpActive = NO;
    [gameSoundManager restoreBackgroundMusic];
    scrollingLettersSpeedModifier = 1.0f;
    
    [humanSprite.humanSprite resumeSchedulerAndActions];

}


-(void) activateScrambledWordPowerUp 
{
    throwScrambledWord = YES;
    [gameSoundManager playPowerUpActivatedSound];
}

-(void) activateThrowWildcardPowerUp
{
    [gameSoundManager playPowerUpActivatedSound];
    throwWildcard = YES;
}

-(void) activateStreakPowerUp 
{
    isStreaking = YES;
    [dictionary setIsStreaking:YES];
    [gameSoundManager playPowerUpActivatedSound];
    [alienSprite showStreakSpeechBubble];
    
    [gameSoundManager pauseGameLoopMusic];
    [gameSoundManager playStreakMusic];

    [self performSelector:@selector(deactivateStreakPowerUp) withObject:self afterDelay:kStreakPowerUpDuration];
}

-(void) deactivateStreakPowerUp
{
    isStreaking = NO;
    [dictionary setIsStreaking:NO];
    [gameSoundManager stopStreakMusic];
    [gameSoundManager playStreakEndBuzzer];
    [gameSoundManager resumeGameLoopMusic];
}

-(void) activateCoolDownPowerUp
{
    [gameSoundManager playPowerUpActivatedSound];
    failCounter=0;
}

#pragma mark Tutorial

-(void) showTutorialNumber:(NSNumber*) tutorialNumber;
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *tutorialKey = [NSString stringWithFormat:kTutorialDefaultsString, [tutorialNumber intValue]];
    
    bool completedTutorial = [[prefs objectForKey:tutorialKey] boolValue];
    bool skipTutorial = [[prefs objectForKey:kSkipTutorials] boolValue];
    
    NSLog(@"Completed tutorial %d: %@", [tutorialNumber intValue], completedTutorial?@"YES":@"NO");
    NSLog(@"Skip tutorial: %@", skipTutorial?@"YES":@"NO");
    
    if(completedTutorial || skipTutorial)
    {
        return;
    }
    
    [[CCDirector sharedDirector] pause];
    TutorialLayer *tutorialLayer = [[[TutorialLayer alloc] initWithTutorialNumber:[tutorialNumber intValue]] autorelease];
    [self addChild:tutorialLayer z:200];
}

#pragma mark Cleaning shit up

-(void) unloadAll
{
    NSLog(@"at GameScene.unloadAll");
    [_lastTimeTouchMoved release];
    
    for(PowerUpButton *powerUpButton in powerUpButtons) 
    {
        [[powerUpButton gameScene] release];
        [powerUpButton removeFromParentAndCleanup:YES];
    }
    [powerUpButtons release];
	
	for(ScrollingLetter *scrollingLetter in scrollingLetters) 
    {
		[scrollingLetter removeFromParentAndCleanup:YES];
	}
	[scrollingLetters release];
    
	for(LetterSlot *letterSlot in letterSlots) {
		[letterSlot removeFromParentAndCleanup:YES];
	}
    
    
    [humanSprite cleanUp];
    [humanSprite release];

    [AlienSprite cancelPreviousPerformRequestsWithTarget:alienSprite];
    [alienSprite release];
    
    [gameSoundManager stopGameLoopMusic];
    [gameSoundManager release];
        
    [self unschedule:@selector(updateScrollingLetters:)];
    [self unschedule:@selector(increaseLevelSpeed:)];
    [self unschedule:@selector(updateLevelTime:)];
    [self unschedule:@selector(alienMovement:)];
    [self unschedule:@selector(humanKeepAlive:)];

    [self removeAllChildrenWithCleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void) dealloc
{
    CCLOG(@"Dealloc GameScene: %@", self); 
    [super dealloc];
}

@end
