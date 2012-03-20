//
//  TubeDoorSprite.h
//  Abductionary
//
//  Created by Rafael Gaino on 1/20/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSprite;
@class CCLayer;

@interface TubeDoorSprite : NSObject
{
    CCSprite *_tubeDoorSprite;
}

-(void) tubeDoorSpriteForScene:(CCLayer*) scene;
-(id) closeAction;
-(id) lightUpAction;
-(id) openAction;
-(void) runCloseAnimation;
-(void) runOpenAnimation;
-(void) runAnimation;
-(void) show;
-(void) hide;
-(void) cleanUp;

@end
