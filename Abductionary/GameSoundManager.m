//
//  GameSoundManager.m
//  Abductionary
//
//  Created by Rafael Gaino on 4/17/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "GameSoundManager.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"
#import "CDXPropertyModifierAction.h"

@implementation GameSoundManager


- (id) init
{
    self = [super init];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundTapLetter];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundLetterFail];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundGameLoop];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundHumanFlush];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundPowerUpActivated];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundPowerUpBarFill];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundPowerUpFreeze];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundPowerUpUnfreeze];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundStreakMusic];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundStreakEndBuzzer];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundNewHumanScore];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundMainMenuClick];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundReturnLetters];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundTractorBeam];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundFeathers];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundTrapDoor];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundShutDown];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundTruck];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kTemperatureOverheat];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kFallingSound];

    for(int i=1; i<=kMaximumWordLength; i++)
    {
        NSString *soundFileName = [NSString stringWithFormat:kSoundScore, i];
        [[SimpleAudioEngine sharedEngine] preloadEffect:soundFileName];
    }


    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    float backgroundMusicGain = [prefs floatForKey:kUserDefaultsBackgroundMusicGain];
    soundFXGain = [prefs floatForKey:kUserDefaultsSFXGain];
    
    NSLog(@"backgroundMusicGain is %.2f and soundFXGain is %.2f", backgroundMusicGain, soundFXGain);
    

    backgroundMusicSoundSource = [[SimpleAudioEngine sharedEngine] soundSourceForFile:kSoundGameLoop];
    [backgroundMusicSoundSource retain];
    [backgroundMusicSoundSource setLooping:YES];
    [backgroundMusicSoundSource setGain:backgroundMusicGain]; 

    return self;
}



-(void) startGameLoopSound 
{
    [self playGameLoopMusic];
}

-(void) slowDownBackgroundMusic
{
    [backgroundMusicSoundSource setPitch:0.7f];
}

-(void) restoreBackgroundMusic
{
    [backgroundMusicSoundSource setPitch:1.0f];
}

-(void) adjustBackgroundMusicPitchForFailCounter:(float) failCounter
{
    return;
    
//    
//    float pitch=1.0f;
//    float threshold = 10;
//    
//    if(failCounter >= threshold )
//    {
//        pitch+= ((failCounter-threshold)/30);
//    }
//
//    [backgroundMusicSoundSource setPitch:pitch];
}

-(void) playGameLoopMusic
{
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:kSoundGameLoop];
    [backgroundMusicSoundSource play];
}

-(void) stopGameLoopMusic
{
    [self restoreBackgroundMusic];
    [backgroundMusicSoundSource stop];
}

-(void) pauseGameLoopMusic
{
    [backgroundMusicSoundSource pause];
}

-(void) resumeGameLoopMusic 
{
    [backgroundMusicSoundSource play];
}


-(void) playLetterFailSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundLetterFail pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playTapLetterSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundTapLetter pitch:1.0f pan:0.0f gain:soundFXGain];
}



-(void) playHumanFlushSound 
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundHumanFlush pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playPowerUpActivatedSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPowerUpActivated pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playPowerUpBarFillSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPowerUpBarFill pitch:1.0f pan:0.0f gain:soundFXGain];
}



-(void) playPowerUpFreezeSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPowerUpFreeze pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playPowerUpUnfreezeSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundPowerUpUnfreeze pitch:1.0f pan:0.0f gain:soundFXGain];
}

- (void) playScoreSoundForLetterNumber:(id)sender data:(NSNumber*)letterNumber
{
    NSString *soundFileName = [NSString stringWithFormat:kSoundScore, [letterNumber intValue]];
    [[SimpleAudioEngine sharedEngine] playEffect:soundFileName pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playStreakMusic
{
    streakMusicID = [[SimpleAudioEngine sharedEngine] playEffect:kSoundStreakMusic pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) stopStreakMusic
{
    [[SimpleAudioEngine sharedEngine] stopEffect:streakMusicID];
}

-(void) playStreakEndBuzzer
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundStreakEndBuzzer pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playNewHumanScoreSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundNewHumanScore pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playClickSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playReturnLettersSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundReturnLetters pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playTractorBeamSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundTractorBeam pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playFeathersSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundFeathers pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playTrapDoorSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundTrapDoor pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playShutDownSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundShutDown pitch:1.0f pan:0.0f gain:soundFXGain];
}

-(void) playTruckSound 
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundTruck pitch:1.0f pan:0.0f gain:soundFXGain];
}

- (void) playHumanSoundWithId:(id)sender data:(NSNumber*)humanId
{
    NSString *humanFallingSound = [NSString stringWithFormat:kHumanFallingSound, [humanId intValue]];
    [[SimpleAudioEngine sharedEngine] playEffect:humanFallingSound pitch:1.0f pan:0.0f gain:soundFXGain*0.65];
    [[SimpleAudioEngine sharedEngine] playEffect:kFallingSound pitch:1.0f pan:0.0f gain:soundFXGain*0.7];
}

-(void) startTemperatureOverheatSound
{
    temperatureOverheadSoundID = [[SimpleAudioEngine sharedEngine] playEffect:kTemperatureOverheat pitch:1.0f pan:0.0f gain:soundFXGain];
    alSourcei(temperatureOverheadSoundID, AL_LOOPING, 1);
}

-(void) stopTemperatureOverheatSound
{
    [[SimpleAudioEngine sharedEngine] stopEffect:temperatureOverheadSoundID];
}

-(void) dealloc
{
    NSLog(@"on GameSoundManager.dealloc");
    
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundTapLetter];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundLetterFail];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundGameLoop];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundHumanFlush];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundPowerUpActivated];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundPowerUpBarFill];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundPowerUpFreeze];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundPowerUpUnfreeze];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundStreakMusic];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundStreakEndBuzzer];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundNewHumanScore];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundMainMenuClick];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundReturnLetters];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundTractorBeam];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundFeathers];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundTrapDoor];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundShutDown];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundTruck];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kTemperatureOverheat];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kFallingSound];

    [backgroundMusicSoundSource release];

    [super dealloc];
}




@end
