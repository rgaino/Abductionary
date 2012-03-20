//
//  PowerUpButton.h
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"
#import "cocos2d.h"

@interface PowerUpButton : CCMenuItemImage {
    
    int _powerUpLevel;
    
}

@property (nonatomic, retain) GameScene *gameScene;

-(PowerUpButton *) initWithPowerUpLevel:(int) powerUpLevel;
-(void) activatePowerUp;

@end
