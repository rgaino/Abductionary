//
//  GameSoundManager.h
//  Abductionary
//
//  Created by Rafael Gaino on 4/17/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDSoundEngine;
@class CDSoundSource;


@interface GameSoundManager : NSObject {
    CDSoundEngine *soundEngine;
    CDSoundSource *backgroundMusicSoundSource;
    unsigned int streakMusicID;
    unsigned int temperatureOverheadSoundID;
    
    float soundFXGain;
}

-(void) startGameLoopSound;
-(void) playLetterFailSound;
-(void) playTapLetterSound;
-(void) slowDownBackgroundMusic;
-(void) restoreBackgroundMusic;
-(void) adjustBackgroundMusicPitchForFailCounter:(float) failCounter;
-(void) playGameLoopMusic;
-(void) stopGameLoopMusic;
-(void) pauseGameLoopMusic;
-(void) resumeGameLoopMusic;
-(void) playHumanFlushSound;
-(void) playPowerUpActivatedSound;
-(void) playPowerUpBarFillSound;
-(void) playPowerUpFreezeSound;
-(void) playPowerUpUnfreezeSound;
-(void) playStreakMusic;
-(void) stopStreakMusic;
-(void) playStreakEndBuzzer;
-(void) playScoreSoundForLetterNumber:(id)sender data:(NSNumber*)letterNumber;
-(void) playNewHumanScoreSound;
-(void) playClickSound;
-(void) playReturnLettersSound;
-(void) playTractorBeamSound;
-(void) playFeathersSound;
-(void) playTrapDoorSound;
-(void) playShutDownSound;
-(void) playTruckSound;
- (void) playHumanSoundWithId:(id)sender data:(NSNumber*)letterNumber;
-(void) startTemperatureOverheatSound;
-(void) stopTemperatureOverheatSound;

@end
