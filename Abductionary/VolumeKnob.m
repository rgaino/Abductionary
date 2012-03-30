//
//  VolumeKnob.m
//  Abductionary
//
//  Created by Rafael Gaino on 5/30/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "VolumeKnob.h"

@implementation VolumeKnob

@synthesize mainMenuSoundManager = _mainMenuSoundManager;

-(VolumeKnob *) initWithType:(kVolumeKnobType)type volumeKnobUpState:(CCProgressTimer*) volumeKnobUpState andGain:(float) gain
{
    _volumePercentage = 100;
    _type = type;
    _volumeKnobUpState = volumeKnobUpState;
    self = [super initWithSpriteFrameName:@"volumeKnob.png"];
    
//    if(_type==kVolumeKnobTypeMusic) 
//    { 
        [_volumeKnobUpState setPercentage:gain*100];
        [self setRotation:gain*360];
//    }
    
//    if(_type==kVolumeKnobTypeSoundFX) 
//    { 
//        [_volumeKnobUpState setPercentage:[[GameSoundManager getInstance] soundFXGain]*100];
//        [self setRotation:[[GameSoundManager getInstance] soundFXGain]*360];
//    }
//    
	return self;
}

- (float) squaredDistanceToCenter:(CGPoint)point
{
	CGPoint center = self.position;
    
	float dx = point.x - center.x;
	float dy = point.y - center.y;
    
	return dx*dx + dy*dy;
}

- (void) calculateAngleBetweenCenterAndPoint:(CGPoint)point
{
	CGPoint center = self.position;
    
	_knobTouchAngle = atan2(point.x - center.x, center.y - point.y) * 180.0f/M_PI;
    
	if (_knobTouchAngle < -kKnobMaxAngle) 
    {
		_knobTouchAngle = -kKnobMaxAngle;
    }
	else if (_knobTouchAngle > kKnobMaxAngle)
    {
		_knobTouchAngle = kKnobMaxAngle;
    }
    
}

-(void) knobTouchMovedToPoint:(CGPoint)point 
{
    float oldAngle = _knobTouchAngle;
    
    [self calculateAngleBetweenCenterAndPoint:point];
    
	float delta = _knobTouchAngle - oldAngle;
    
	if (fabsf(delta) > 10.0f)
    {
		return;
    }
    
    float rotation=self.rotation-delta;
    if(rotation>360) { rotation=rotation-360; }
    if(rotation<0) { rotation=rotation+360; }
    
    float gain=(self.rotation/360);
    
    [self setRotation:rotation];
    
    float progressPercentage=0;

    if(_type==kVolumeKnobTypeMusic) 
    { 
        [self.mainMenuSoundManager setBackgroundMusicGain:gain]; 
        progressPercentage = [self.mainMenuSoundManager backgroundMusicGain]*100;
    }
    
    if(_type==kVolumeKnobTypeSoundFX) 
    { 
        [self.mainMenuSoundManager setSoundFXGain:gain]; 
        progressPercentage = [self.mainMenuSoundManager soundFXGain]*100;
    }
    
    //rounding percentage so it's always increments of 4 degrees
    NSLog(@"was %.2f", progressPercentage);
    progressPercentage = roundf(progressPercentage/4)*4;
    NSLog(@"is %.2f", progressPercentage);
    
    [_volumeKnobUpState setPercentage:progressPercentage];
}

-(void) dealloc
{
    
    [_mainMenuSoundManager release];
    
    [super dealloc];
}

@end
