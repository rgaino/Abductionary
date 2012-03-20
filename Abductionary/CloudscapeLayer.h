//
//  CloudscapeLayer.h
//  Abductionary
//
//  Created by Rafael Gaino on 9/21/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "CCLayer.h"

@interface CloudscapeLayer : CCLayer
{
}

-(void) setupSprites;
-(void) addNewStarSprite;
-(void) removeStarSprite;
-(void) slowDownAndStop;

@end
