//
//  VolumeKnob.h
//  Abductionary
//
//  Created by Rafael Gaino on 5/30/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "MainMenuSoundManager.h"

@interface VolumeKnob : CCSprite {
    
    kVolumeKnobType _type;
    CCProgressTimer *_volumeKnobUpState;
    float _volumePercentage;
    float _knobTouchAngle;
    MainMenuSoundManager *_mainMenuSoundManager;
}

@property (nonatomic, retain) MainMenuSoundManager *mainMenuSoundManager;

-(VolumeKnob *) initWithType:(kVolumeKnobType)type volumeKnobUpState:(CCProgressTimer*) volumeKnobUpState andGain:(float) gain;
-(float) squaredDistanceToCenter:(CGPoint)point;
-(void) calculateAngleBetweenCenterAndPoint:(CGPoint)point;
-(void) knobTouchMovedToPoint:(CGPoint)point;

@end
