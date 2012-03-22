//
//  SuperScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 7/22/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "SuperScene.h"
#import "NSString+NSString_Helper.h"

@implementation SuperScene

-(void) alienMovement:(ccTime)deltaTime
{
    
    if ( [alienSprite.alienSprite numberOfRunningActions] > 0 ) { return; }
    
    int chance;
    
    
    chance = arc4random() % 100;
    
    if(chance <= 50)
    {
        [alienSprite showRandomSpeechBubble];
        return;
    }
    
    
    chance = arc4random() % 100;
    
    if(chance <= 50) 
    {
//        NSLog(@"alien will blink");
        [alienSprite blinkAnimation];
    }
    else if(chance>50 && chance<70 && ![alienSprite isShowingStreakSpeechBubble])
    {
//        NSLog(@"alien will walk");
        [alienSprite startWalkAnimation];
        
        CGPoint alienPosition = [self newAlienPosition];
        id moveAlien = [CCMoveTo actionWithDuration:kGameSceneAlienWalkSpeed position:ccp(alienPosition.x, alienPosition.y)];
        id stopWalkAnimation = [CCCallFunc actionWithTarget:alienSprite selector:@selector(stopWalkAnimation)];
        [alienSprite.alienSprite runAction: [CCSequence actions:moveAlien, stopWalkAnimation, nil]];
    }
    
}

-(CGPoint) newAlienPosition
{
    //method must be overriden
    CGPoint alienPosition = [alienSprite.alienSprite position];
    return alienPosition;
}


-(void) showLoadingImageWithFade:(BOOL) fade
{
    NSLog(@"Moving to LoadingScene...");

    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];        
//    CGRect posxx = [self boundingBox];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *loadingImage = [CCSprite spriteWithFile:@"loadingImage.pvr.ccz"];
//    [loadingImage setAnchorPoint:ccp(0,0)];
//    [loadingImage setPosition: ccp(posxx.origin.x , posxx.origin.y-256)];
    [loadingImage setPosition: ccp(screenSize.width/2 , screenSize.height/2)];
    
    if(fade)
    {
        NSLog(@"...with fade");
        [loadingImage setOpacity:0];
        id fadeIn = [CCFadeIn actionWithDuration:0.5f];
        [loadingImage runAction:fadeIn];
    }
    
    [self addChild:loadingImage z:100];

}

@end
