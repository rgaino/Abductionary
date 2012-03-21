//
//  PowerUpButton.m
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "PowerUpButton.h"
#import "Constants.h"
#import "GameSoundManager.h"

@implementation PowerUpButton

@synthesize gameScene;

-(PowerUpButton *) initWithPowerUpLevel:(int) powerUpLevel 
{
	
	_powerUpLevel = powerUpLevel;
    
	NSString *filename = [NSString stringWithFormat:@"powerUp_0%d.png", _powerUpLevel+1];
	
    if( (self=[super initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:filename] selectedSprite:[CCSprite spriteWithSpriteFrameName:filename] disabledSprite:[CCSprite spriteWithSpriteFrameName:filename] target:self selector:@selector(activatePowerUp)])) {

        float y = kPowerUpButtonsFirstY + (kPowerUpButtonsYSpacing * (_powerUpLevel));
        
        CGPoint position = ccp(kPowerUpButtonsX,  y);
		[self setPosition: position];
        [self setVisible:NO];
	}
	return self;
}

-(void) activatePowerUp 
{
    if( [gameScene isPaused] ) {return;}

    NSLog(@"Power up level %d activated", _powerUpLevel);
    
    [self.gameScene resetPowerUpMeterToLevel:_powerUpLevel];
    
    switch (_powerUpLevel) {
        case 0:
            [gameScene activateThrowWildcardPowerUp];
            break;

        case 1:
            [gameScene activateSlowDownPowerUp];
            break;

        case 2:
            [gameScene activateScrambledWordPowerUp];
            break;

        case 3:
            [gameScene activateStreakPowerUp];
            break;

        case 4:
            [gameScene activateCoolDownPowerUp];
            break;

        default:
            break;
    }
    
}

@end
