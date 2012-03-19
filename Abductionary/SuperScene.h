//
//  SuperScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 7/22/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "cocos2d.h"
#import "AlienSprite.h"
#import "Constants.h"

@interface SuperScene : CCLayer 
{
    AlienSprite *alienSprite;
}

-(void) alienMovement:(ccTime)deltaTime;
-(CGPoint) newAlienPosition;
-(void) showLoadingImageWithFade:(BOOL) fade;

@end
