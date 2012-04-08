//
//  I18nScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright 2012 DOJO. All rights reserved.
//

#import "I18nScene.h"
#import "cocos2d.h"

@implementation I18nScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	I18nScene *layer = [I18nScene node];
	[scene addChild:layer];	
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
    {
        [self setIsTouchEnabled:YES];
    }
    
	return self;
}




@end
