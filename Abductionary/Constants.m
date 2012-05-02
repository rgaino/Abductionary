//
//  Constants.m
//  Abductionary
//
//  Created by Rafael Gaino on 3/4/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "Constants.h"

@implementation Constants

float const kScrollingLettersInitialSpeedEasy = 30;
float const kScrollingLettersInitialSpeedMedium = 40;
float const kScrollingLettersInitialSpeedHard = 60;

float const kScrollingLettersSpeedIncreaseTick = 0.5f;      //increase letter speed this much every kScrollingLettersSpeedIncreaseTime seconds
float const kScrollingLettersSpeedIncreaseTime = 5.0f;      //frequency with which speed increases in each level

float const kLetterWidth = 55;								//width of the letter image
float const kLetterHeight = 55;								//height of the letter image
float const kFirstLetterSlotX = 66;						// x position of the first letter slot
float const kFirstLetterSlotY = 700;						// y position of the first letter slot
float const kLetterSlotXSpacing = 6;                        // X space between slot letters
float const kScrollAreaWidth = 500;
float const kMoveLetterToSlotAnimationSpeed = 0.2;			//speed that the letters are animated to the slot
float const kMaxLives = 31;									//max letters you can fail
float const kShiftPanelLettersDelay = .01;                  // delay to shift letters to left or right after dragging one letter in the word panel and hovering another letter
float const kPointsAwardedLabelFadeOutDuration = 3.0f;         // fade out duration of the points awarded label
int const kLetterChuteCount = 8;
float const kLetterChuteXPositions[8]={566, 621, 676, 731, 786, 841, 896, 951};
float const kLetterFailY = 50;                              // the Y position where the letter is considered a loss
float kLastLetterChuteX = -1;                               // last letter chute used so it doesn't repeat twice in a row
float const kDefaultLevelTime = 2*60;                       //default amount of seconds that a level lasts
float const kLevelTransitionDuration = 1.0f;                //the duration of the fade effect between levels
float const kTransitionSceneDuration = 3.0f;                //how many seconds the transition between levels stays on
float const kTemperatureGaugeAngleMax = 130.0f;              //maximum degrees the temperature gauge arrow rotates to the right (negative value of this property is the left inclination)
float const kTemperatureGaugeAnimationDuration = 0.2f;      //duration of the arrow animation on the temperature gauge every time the temperature changes
float const kUpdateLevelTimeFrequency = 1.0f;
float const kUpdateScrollingLettersFrequency = 0.01f;
float const kTimeCircleAnimationDuration = 0.2f;
float const kHumanFlushSoundDelay = 2.0f;
float const kHumanLevelTransitionAnimationDuration = 3.0f;
float const kMoveCloudscapeImageSpeed = 0.01f;
float const kMoveTubeDoorSpeed = 0.5f;
NSString * const kCommonFontName = @"Geogrotesque";
NSString * const kGameOverScoreFontName = @"Interstate";
float const kFlyAwayLetterSpeed = 0.3f;
float const kFlyAwayPositionY = 40.0f;
float const kKnobMinimumDistanceSquared = 16.0f;
float const kKnobMaxAngle = 135.0f;
float const kMainMenuPanSpeed = 2.5f;
float const kMainMenuAlienWalkSpeed = 5.0f;
float const kGameModeSwitchAnimationDuration = 0.3f;
float const kAlienMovementFrequency = 2.0f;
float const kGameSceneAlienWalkSpeed = 2.0f;
float const kHumanKeepAliveFrequency = 2.5f;
float const kTruckAnimationMoveSpeed = 15.0f;
float const kAlienOffsetPositionInSettingsScreen = 50;
float const kCreateNewStarSpriteFrequency = 1.0f;
float const kMoveStarSpriteFrequency = 0.4f;
float const kScorePointsAnimationDuration = 2.0f;
float const kSpeechBubbleDuration = 3.0f;
int const kHumanScorePerLevel = 25;
float const kScorePointsLabelAnimationOffset = 40;


//Power Ups
int const kScrambledWordLength = 5;
float const kScrollingLettersSpeedModifierPowerUp = 0.4f;
float const kScrollingLettersSpeedModifierPowerUpDuration = 10.0f;
float const kStreakPowerUpDuration = 15.0f;
float const kPowerUpButtonsX = 104;
float const kPowerUpButtonsFirstY = 313;
float const kPowerUpButtonsYSpacing = 52;
float const kPowerUpsCount = 5;                               //how many power ups we have
float const kPowerUpBarAnimationDuration = 0.2f;
int const kTemperatureGaugeBeginOverheat = 25;


//Game Over
float const kPanGameOverAnimationDuration = 5.0f;
float const kDropHumanGameOverAnimationDuration = 6.0f;
float const kStopCloudscapeSpeed = 0.1f;                      //speed with which cloudscape speed is decreased to a stop


//Sounds
NSString * const kSoundTapLetter = @"tapLetter.mp3";
NSString * const kSoundLetterFail = @"swoosh.mp3";
NSString * const kSoundGameLoop = @"gameLoop1.mp3";
NSString * const kSoundNewGameConsoleIn = @"newGameConsoleIn.mp3";
NSString * const kSoundNewGameConsoleOut = @"newGameConsoleOut.mp3";
NSString * const kSoundMainMenuClick = @"mainMenuClick.mp3";
NSString * const kSoundMainMenuBackgroundMusic = @"mainMenuBackgroundMusic.mp3";
NSString * const kSoundHumanFlush = @"flushHuman.mp3";
NSString * const kSoundPowerUpBarFill = @"powerUpBarFill.mp3";
NSString * const kSoundPowerUpActivated = @"powerUpActivated.mp3";
NSString * const kSoundPowerUpFreeze = @"freeze.mp3";
NSString * const kSoundPowerUpUnfreeze = @"unfreeze.mp3";
NSString * const kSoundStreakMusic = @"streakMusic.mp3";
NSString * const kSoundStreakEndBuzzer = @"streakEndBuzzer.mp3";
NSString * const kSoundScore = @"score%d.mp3";
NSString * const kSoundAlienVoice = @"alienVoice%d.mp3";
NSString * const kSoundNewHumanScore = @"newHumanScore.mp3";
NSString * const kSoundReturnLetters = @"returnLetters.mp3";
NSString * const kSoundTractorBeam = @"tractorBeam.mp3";
int const kNumberOfAlienVoices = 9;
NSString * const kUserDefaultsBackgroundMusicGain = @"kUserDefaultsBackgroundMusicGain";
NSString * const kUserDefaultsSFXGain = @"kUserDefaultsBackgroundSFXGain";
NSString * const kSoundFeathers = @"feathers.mp3";
NSString * const kSoundTrapDoor = @"trapdoor.mp3";
NSString * const kSoundShutDown = @"shutdown.mp3";
NSString * const kSoundTruck = @"truck.mp3";
NSString * const kHumanFallingSound = @"humanFall%d.mp3";
NSString * const kTemperatureOverheat = @"temperatureOverheat.mp3";
NSString * const kFallingSound = @"fallingSound.mp3";


//Dictionary
int const kMinimumWordLength = 3;							//min letters allowed in the word spelled
int const kMaximumWordLength = 7;                         //max letters allowed in the word spelled
NSString * const kAlphabet = @"abcdefghijklmnopqrstuvwxyz";
NSString * const kAlphabetScored = @"qzjxkfhvwybcmpdgeaionrtlsu"; //the alphabet from higher points to lower points
int const kDontRepeatThisManyLastLetters = 1;               //at least this many letters without duplicates
NSString * const kWildcardString = @"*";
int const kCheckForRepeteadLettersCount = 10;
int const kCheckForRepeteadLettersOccurencesAllowed = 3;
NSString * const kUserDefaultsLanguage = @"kUserDefaultsLanguage";


//Game Center
NSString * const kLeaderboardCategoryEasy = @"Abductionary_Easy";
NSString * const kLeaderboardCategoryMedium = @"Abductionary_Medium";
NSString * const kLeaderboardCategoryHard = @"Abductionary_Hard";
NSString * const kUserDefaultsSavedFailedScores = @"savedFailedScores";


//Leaderboards
float const kLeaderboardFontSize = 20;


//Tutorials
int const kNumberOfTutorials = 7;
NSString * const kTutorialDefaultsString = @"completedTutorial_%d";
NSString * const kSkipTutorials = @"skipTutorials";

@end
