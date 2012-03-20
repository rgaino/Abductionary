//
//  MainMenuSoundManager.m
//  Abductionary
//
//  Created by Rafael Gaino on 1/18/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "MainMenuSoundManager.h"

@implementation MainMenuSoundManager

- (id) init
{
    self = [super init];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundTapLetter];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundNewGameConsoleIn];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundNewGameConsoleOut];
    [[SimpleAudioEngine sharedEngine] preloadEffect:kSoundMainMenuClick];    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:kSoundMainMenuBackgroundMusic];

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    float backgroundMusicGain = [prefs floatForKey:kUserDefaultsBackgroundMusicGain];
    soundFXGain = [prefs floatForKey:kUserDefaultsSFXGain];
    
    NSLog(@"backgroundMusicGain is %.2f and soundFXGain is %.2f", backgroundMusicGain, soundFXGain);
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:backgroundMusicGain];

    return self;
}


-(void) playTapLetterSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundTapLetter pitch:1.0f pan:0.0f gain:soundFXGain];
}


-(void) playNewGameConsoleInSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundNewGameConsoleIn pitch:1.0f pan:0.0f gain:soundFXGain];
}


-(void) playNewGameConsoleOutSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundNewGameConsoleOut pitch:1.0f pan:0.0f gain:soundFXGain];
}


-(void) playMainMenuClickSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:kSoundMainMenuClick pitch:1.0f pan:0.0f gain:soundFXGain];
}


-(void) playBackgroundMusic
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:kSoundMainMenuBackgroundMusic loop:YES];
    
}


-(void) stopBackgroundMusic
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}


-(void) pauseBackgroundMusic
{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}


-(void) resumeBackgroundMusic 
{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}



-(void) setBackgroundMusicGain:(float) gain
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:gain forKey:kUserDefaultsBackgroundMusicGain];
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:gain];
}


-(float) backgroundMusicGain
{
    return [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
}


-(void) setSoundFXGain:(float) gain
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:gain forKey:kUserDefaultsSFXGain];

    soundFXGain = gain;
}


-(float) soundFXGain
{
    return soundFXGain;
}


-(void) dealloc
{
    NSLog(@"on MainMenuSoundManager.dealloc");
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundTapLetter];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundNewGameConsoleIn];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundNewGameConsoleOut];
    [[SimpleAudioEngine sharedEngine] unloadEffect:kSoundMainMenuClick];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    [super dealloc];
}

@end
