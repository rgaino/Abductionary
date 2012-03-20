//
//  LoadingScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 6/6/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "LoadingScene.h"
#import "Constants.h"
#import "GameScene.h"
#import "cocos2d.h"

@implementation LoadingScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	LoadingScene *layer = [LoadingScene node];
	[scene addChild:layer];	
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
    {
        [self showLoadingImageWithFade:NO];
        
        [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    }
    
    [self performSelector:@selector(startGame) withObject:nil afterDelay:1.0f];
    
	return self;
}

-(void) startGame
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:[GameScene scene]]];
}
         
- (void) dealloc
{
    CCLOG(@"Dealloc LoadingScene: %@", self);
    [super dealloc];
}

@end
