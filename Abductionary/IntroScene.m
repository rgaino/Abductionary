//
//  IntroScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 2/2/12.
//  Copyright 2012 DOJO. All rights reserved.
//

#import "IntroScene.h"
#import "LoadingScene.h"
#import "MainMenuScene.h"

@implementation IntroScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroScene *layer = [IntroScene node];
	[scene addChild:layer];	
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
    {
        [CCVideoPlayer setDelegate: self]; 
        [CCVideoPlayer playMovieWithFile: @"abd_intro.mov"];
    }
        
	return self;
}

- (void) moviePlaybackFinished
{
//    [[CCDirector sharedDirector] startAnimation];
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
//    [[CCDirector sharedDirector] replaceScene:[LoadingScene scene]];
}

- (void) movieStartsPlaying
{
//    [[CCDirector sharedDirector] stopAnimation];
}

-(void) dealloc
{
    [CCVideoPlayer setDelegate:nil];
    [super dealloc];
}


@end
