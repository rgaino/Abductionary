//
//  TruckSprite.h
//  Abductionary
//
//  Created by Rafael Gaino on 8/4/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"

@interface TruckSprite : CCSprite
{
    
}

+(id) truckSpriteForScene:(CCLayer*) scene;
-(void) runTruckAnimation;

@end
