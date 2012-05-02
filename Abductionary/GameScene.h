//
//  GameScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/3/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "SuperScene.h"

@class Dictionary;
@class ScrollingLetter;
@class Constants;
@class GameSoundManager;
@class TubeDoorSprite;
@class HumanSprite;
@class CloudscapeLayer;
@class CCParticleSystemQuad;

@interface GameScene : SuperScene 
{
    
	float scrollingLettersSpeed;
    float scrollingLettersSpeedModifier;
    float totalLevelTime;
    float elapsedLevelTime;
	float createLetterCounter;
	int64_t score;
	float failCounter;
    float temperatureArrowAngleTick;
    int powerUpMeterValue;
    int currentPowerUpFilling;
	CGPoint gestureStartPoint;
    BOOL throwScrambledWord;
    BOOL throwWildcard;
    BOOL isStreaking;
    BOOL isTransitioningLevels;
    int level;
    BOOL isSlowDownPowerUpActive;
    BOOL isGameOver;
    
    NSDate *_lastTimeTouchMoved;
    int letterToBeShifted;
	
    GameSoundManager *gameSoundManager;
	NSMutableArray *scrollingLetters;
	NSMutableArray *letterSlots;
    NSMutableArray *powerUpButtons;
	ScrollingLetter *draggingScrollingLetter;
	Dictionary *dictionary;
	CGSize screenSize;
	CCMenuItemImage *wordCompletedButton;
    CCMenuItemImage *wordEraseButton;
	CCLabelTTF *scoreLabel;
	CCLabelTTF *pointsAwardedLabel;
    CCSprite *scoreUpImage;
    CCSprite *temperatureGaugeArrowImage;
    CCProgressTimer *powerUpBarProgressTimer;
    CCProgressTimer *timeMeterProgressTimer;
    HumanSprite *humanSprite;
    CCMenuItemImage *pauseButton;
    CCMenuItemImage *resumeButton;
    CCSprite *tubeDoorImage;
    CCSprite *tubeDoorMainMenu;
    CCMenuItemImage *tubeDoorButton;
    CCMenuItemLabel *mainMenuButton;
    CCProgressTimer *letterDoorTopImage;
    CCProgressTimer *letterDoorBottomImage;
    CCLabelTTF *gameOverScoreLabel;
    CCSprite *trapDoorImage;
    TubeDoorSprite *tubeDoorSprite;
    CCSprite *humanTubeFrozen;
    CCSprite *letterTubeFrozen;
    CloudscapeLayer *cloudscapeLayer;
    CCSprite *tractorBeam;
    CCSprite *temperatureMeterGlow;
    
    CCParticleSystemQuad *smokeEmitterTemperatureGauge;
}

+(CCScene *) scene;

-(void) updateScrollingLetters:(ccTime)deltaTime;
-(void) updateLevelTime:(ccTime)deltaTime;
-(void) increaseLevelSpeed;
-(void) setupSprites_RGBA4444;
-(void) setupLayers;
-(void) setupButtons;
-(void) setupVariablesAndObjects;
-(void) createNewLetter;
-(void) evaluateWord;
-(void) cleanWordPanel;
-(void) wordComplete;
-(NSString *) currentWordInPanel;
-(void) wordComplete;
-(void) animateWordScore;
-(void) increaseFailCounter:(float) val;
-(void) decreaseFailCounter:(float) val;
-(void) increaseScore:(int64_t) val;
-(void) pauseGame;
-(void) resumeGame;
-(void) goToMainMenu;
-(void) scrollingLetterTapped;
-(void) increasePowerUpMeter:(int) powerUpIncrease;
-(void) resetPowerUpMeterToLevel:(int) powerUpLevelReset;
-(void) updatePowerUpMeter;
-(void) updateTemperatureGauge;
-(void) resetTemperatureGauge;
-(BOOL) isHoveringPannelLetter;
-(void) shiftLetters;
-(void) completeLevel;
-(void) gameOver;
-(void) activateScrambledWordPowerUp;
-(void) activateSlowDownPowerUp;
-(void) deactivateSlowDownPowerUp;
-(void) activateThrowWildcardPowerUp;
-(void) activateStreakPowerUp;
-(void) deactivateStreakPowerUp;
-(void) activateCoolDownPowerUp;
-(void) discardHuman;
-(void) bringNewHuman;
-(void) startNextLevel;
-(void) tapToReturnLetter:(NSValue*) touchPoint;
-(void) placeDraggingScrollingLetterInSlot;
-(void) dragLetterInSlot:(UITouch*) touch;
-(BOOL) isPaused;
-(void) gameOverAnimation;
-(void) setupGameOverSprites;
-(void) replayGame;
-(void) humanKeepAlive:(ccTime)deltaTime;
-(void) unloadAll;
-(void) mainMenuButtonPressed;
-(void) restartScene;
-(void) showTutorialNumber:(NSNumber*) tutorialNumber;
-(void) beamUpNewHuman;
-(void) discardLetters;
-(void) removeAllScrollingLetters;

@property (nonatomic, retain) NSDate *lastTimeTouchMoved;

@end
