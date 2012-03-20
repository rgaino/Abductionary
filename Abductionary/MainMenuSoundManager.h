//
//  MainMenuSoundManager.h
//  Abductionary
//
//  Created by Rafael Gaino on 1/18/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"

@interface MainMenuSoundManager : NSObject
{
    float soundFXGain;
}


-(void) playTapLetterSound;
-(void) playNewGameConsoleInSound;
-(void) playNewGameConsoleOutSound;
-(void) playMainMenuClickSound;
-(void) playBackgroundMusic;
-(void) stopBackgroundMusic;
-(void) pauseBackgroundMusic;
-(void) resumeBackgroundMusic; 
-(void) setBackgroundMusicGain:(float) gain;
-(void) setSoundFXGain:(float) gain;
-(float) backgroundMusicGain;
-(float) soundFXGain;

@end
