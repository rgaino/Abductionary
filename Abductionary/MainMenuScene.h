//
//  MainMenuScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/3/11.
//  Copyright 2011 DOJO. All rights reserved.
//


#import "SuperScene.h"
#import "GameCenterManagerDelegate.h"

@class CCSprite;
@class CCMenuItemLabel;
@class CCMenuItemImage;
@class VolumeKnob;
@class CCProgressTimer;
@class LeaderboardsLayer;
@class MainMenuSoundManager;

@interface MainMenuScene : SuperScene <GameCenterManagerDelegate>
{
    MainMenuSoundManager *mainMenuSoundManager;
    
    float fadeInButtonDelay;
    float dropLetterAnimatedDelay;
        
    CCSprite *vortexSprite;
    CCSprite *stars1Sprite;
    CCSprite *stars2Sprite;
    CCSprite *stars3Sprite;
    
    CCSprite *mainMenuLetter_01a;
    CCSprite *mainMenuLetter_02b;
    CCSprite *mainMenuLetter_03d;
    CCSprite *mainMenuLetter_04u;
    CCSprite *mainMenuLetter_05c;
    CCSprite *mainMenuLetter_06t;
    CCSprite *mainMenuLetter_07i;
    CCSprite *mainMenuLetter_08o;
    CCSprite *mainMenuLetter_09n;
    CCSprite *mainMenuLetter_10a;
    CCSprite *mainMenuLetter_11r;
    CCSprite *mainMenuLetter_12y;
    
    CCMenuItemLabel *newGameButton;
    CCMenuItemLabel *settingsButton;
    CCMenuItemLabel *leaderboardsButton;
    
    CCSprite *newGameConsole;
    CCSprite *newGameConsoleDoor;
    CCSprite *newGameConsoleBottom;
    CCMenuItemImage *startLabelButton;
    CCMenuItemImage *startButton;
    CCLabelTTF *gameModeLabel;
    CCMenuItemImage *gameModeSwitchEasy;
    CCMenuItemImage *gameModeSwitchMedium;
    CCMenuItemImage *gameModeSwitchHard;
    BOOL isNewGameConsoleUp;
    BOOL isStartingGame;
    
    VolumeKnob *musicVolumeKnob;
    VolumeKnob *soundFXVolumeKnob;
    VolumeKnob *touchedKnob;
    CCProgressTimer *musicVolumeKnobUpState;
    CCProgressTimer *soundFXVolumeKnobUpState;
    
    LeaderboardsLayer *leaderboardsLayer;
    
    CCMenuItemImage *leaderboardsEasyButton; 
    CCMenuItemImage *leaderboardsMediumButton; 
    CCMenuItemImage *leaderboardsHardButton; 
    
    CCMenuItemImage *leaderboardsAllTimeButton;
    CCMenuItemImage *leaderboardsWeekButton;
    CCMenuItemImage *leaderboardsTodayButton;

    CCMenuItemImage *leaderboardsGlobalButton;
    CCMenuItemImage *leaderboardsFriendsButton;

    kLeaderboardGameMode currentLeaderboardGameMode;
    kLeaderboardScope currentLeaderboardScope;
    kLeaderboardTimePeriod currentLeaderboardTimePeriod;
    
    CCSprite *creditsScreen;
}

+(CCScene *) scene;
-(void) startGameEasy;
-(void) startGameMedium;
-(void) startGameHard;
-(void) startGame;
-(void) switchGameModeEasy;
-(void) switchGameModeMedium;
-(void) switchGameModeHard;
-(void) moveToSettings;
-(void) moveToLeaderboards;
-(void) setupVariablesAndObjects;
-(void) setupSprites_RGBA4444;
-(void) setupLeaderboardsLayer;
-(void) setupMenu;
-(void) setupAnimations;
-(void) setupNewGameConsole;
-(void) animateNewGameConsoleUp;
-(void) animateNewGameConsoleDown;
-(void) goToGameScene;

-(void) dropLetterAnimated:(CCSprite*) letterSprite;
-(void) fadeInButton:(CCMenuItemLabel*) button;
-(void) moveToSettings;
-(void) doneSettings;
-(void) doneLeaderboards;
-(void) showHideCredits;
-(void) resetTutorial;

-(void) loadLeaderboards;
-(void) loadGlobalLeaderboards;
-(void) loadFriendsLeaderboards;
-(void) loadAllTimeLeaderboards;
-(void) loadWeekLeaderboards;
-(void) loadTodayLeaderboards;
-(void) loadEasyLeaderboards;
-(void) loadMediumLeaderboards;
-(void) loadHardLeaderboards;

-(void) showVolumeKnobsUpstate;
-(void) hideVolumeKnobsUpstate;


//GameCenterManagerDelegate methods
//-(void) didFinishLoadingScores:(NSMutableArray*) leaderboardResults;
//-(void) errorLoadingScores:(NSError*) error;

@end
