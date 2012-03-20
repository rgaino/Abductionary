//
//  FeathersSprite.h
//  Abductionary
//
//  Created by Rafael Gaino on 8/26/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"

@interface FeathersSprite : CCSprite
{

}

+(id) feathersSpriteForScene:(CCLayer*) scene;
-(void) runFeathersAnimation;


@end
