//
//  Constants.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/4/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kRandomLetters,
    kScrambledWordsAsLetters
} kDictionaryType;

typedef enum {
    kVolumeKnobTypeMusic,
    kVolumeKnobTypeSoundFX
} kVolumeKnobType;

typedef enum {
    kGameModeEasy,
    kGameModeMedium,
    kGameModeHard
} kGameMode;

typedef enum {
    kLeaderboardGameModeEasy,
    kLeaderboardGameModeMedium,
    kLeaderboardGameModeHard
} kLeaderboardGameMode;

typedef enum {
    kLeaderboardScopeGlobal,
    kLeaderboardScopeFriends
} kLeaderboardScope;

typedef enum {
    kLeaderboardTimePeriodAllTime,
    kLeaderboardTimePeriodWeek,
    kLeaderboardTimePeriodToday
} kLeaderboardTimePeriod;

extern float const kScrollingLettersInitialSpeedEasy;
extern float const kScrollingLettersInitialSpeedMedium;
extern float const kScrollingLettersInitialSpeedHard;
extern float const kScrollingLettersSpeedIncreaseTick;
extern float const kScrollingLettersSpeedIncreaseTime;
extern float const kLetterWidth;
extern float const kLetterHeight;
extern float const kFirstLetterSlotX;
extern float const kFirstLetterSlotY;
extern float const kLetterSlotXSpacing;
extern float const kScrollAreaWidth;
extern float const kMoveLetterToSlotAnimationSpeed;
extern float const kMaxLives;
extern float const kShiftPanelLettersDelay;
extern float const kPointsAwardedLabelFadeOutDuration;
extern int const kLetterChuteCount;
extern float const kLetterChuteXPositions[];
extern float const kLetterFailY;
extern float kLastLetterChuteX;
extern float  const kDefaultLevelTime;
extern float const kLevelTransitionDuration;
extern float const kTransitionSceneDuration;
extern float const kTemperatureGaugeAngleMax;
extern float const kTemperatureGaugeAnimationDuration;
extern float const kUpdateLevelTimeFrequency;
extern float const kUpdateScrollingLettersFrequency;
extern float const kTimeCircleAnimationDuration;
extern float const kHumanFlushSoundDelay;
extern float const kHumanLevelTransitionAnimationDuration;
extern float const kMoveCloudscapeImageSpeed;
extern float const kMoveTubeDoorSpeed;
extern NSString * const kCommonFontName;
extern NSString * const kGameOverScoreFontName;
extern float const kFlyAwayLetterSpeed;
extern float const kFlyAwayPositionY;
extern float const kKnobMinimumDistanceSquared;
extern float const kKnobMaxAngle;
extern float const kMainMenuPanSpeed;
extern float const kMainMenuAlienWalkSpeed;
extern float const kGameModeSwitchAnimationDuration;
extern float const kAlienMovementFrequency;
extern float const kGameSceneAlienWalkSpeed;
extern float const kHumanKeepAliveFrequency;
extern float const kTruckAnimationMoveSpeed;
extern float const kAlienOffsetPositionInSettingsScreen;
extern float const kCreateNewStarSpriteFrequency;
extern float const kMoveStarSpriteFrequency;
extern float const kScorePointsAnimationDuration;
extern float const kSpeechBubbleDuration;
extern int const kHumanScorePerLevel;
extern float const kScorePointsLabelAnimationOffset;
extern int const kTemperatureGaugeBeginOverheat;


//Power Ups
extern int const kScrambledWordLength;
extern float const kScrollingLettersSpeedModifierPowerUp;
extern float const kScrollingLettersSpeedModifierPowerUpDuration;
extern float const kStreakPowerUpDuration;
extern float const kPowerUpButtonsX;
extern float const kPowerUpButtonsFirstY;
extern float const kPowerUpButtonsYSpacing;
extern float const kPowerUpsCount;
extern float const kPowerUpBarAnimationDuration;


//Game Over
extern float const kPanGameOverAnimationDuration;
extern float const kDropHumanGameOverAnimationDuration;
extern float const kStopCloudscapeSpeed;


//Sounds
extern NSString * const kSoundTapLetter;
extern NSString * const kSoundLetterFail;
extern NSString * const kSoundGameLoop;
extern NSString * const kSoundNewGameConsoleIn;
extern NSString * const kSoundNewGameConsoleOut;
extern NSString * const kSoundMainMenuClick;
extern NSString * const kSoundMainMenuBackgroundMusic;
extern NSString * const kSoundHumanFlush;
extern NSString * const kSoundPowerUpBarFill;
extern NSString * const kSoundPowerUpActivated;
extern NSString * const kSoundPowerUpFreeze;
extern NSString * const kSoundPowerUpUnfreeze;
extern NSString * const kSoundStreakMusic;
extern NSString * const kSoundStreakEndBuzzer;
extern NSString * const kSoundScore;
extern NSString * const kSoundAlienVoice;
extern NSString * const kSoundReturnLetters;
extern int const kNumberOfAlienVoices;
extern NSString * const kUserDefaultsBackgroundMusicGain;
extern NSString * const kUserDefaultsSFXGain;
extern NSString * const kSoundNewHumanScore;
extern NSString * const kSoundTractorBeam;
extern NSString * const kSoundFeathers;
extern NSString * const kSoundTrapDoor;
extern NSString * const kSoundShutDown;
extern NSString * const kSoundTruck;
extern NSString * const kHumanFallingSound;
extern NSString * const kTemperatureOverheat;
extern NSString * const kFallingSound;


//Dictionary
extern int const kMinimumWordLength;
extern int const kMaximumWordLength;
extern NSString * const kAlphabet;
extern NSString * const kAlphabetScored;
extern NSString * const kScrabbleAlphabet;
extern int const kDontRepeatThisManyLastLetters;
extern NSString * const kOnePointLetters;
extern NSString * const kTwoPointLetters;
extern NSString * const kThreePointLetters;
extern NSString * const kFourPointLetters;
extern NSString * const kFivePointLetters;
extern NSString * const kEightPointLetters;
extern NSString * const kTenPointLetters;
extern NSString * const kWildcardString;
int const kCheckForRepeteadLettersCount;
int const kCheckForRepeteadLettersOccurencesAllowed;
extern NSString * const kUserDefaultsLanguage;


//Game Center
extern NSString * const kLeaderboardCategoryEasy;
extern NSString * const kLeaderboardCategoryMedium;
extern NSString * const kLeaderboardCategoryHard;
extern NSString * const kUserDefaultsSavedFailedScores;


//Leaderboards
extern float const kLeaderboardFontSize;


//Tutorials
extern int const kNumberOfTutorials;
extern NSString * const kTutorialDefaultsString;
extern NSString * const kSkipTutorials;


@interface Constants : NSObject {
    
}

@end
