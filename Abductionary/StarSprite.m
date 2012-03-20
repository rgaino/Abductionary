//
//  StarSprite.m
//  Abductionary
//
//  Created by Rafael Gaino on 9/21/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "StarSprite.h"

@implementation StarSprite


+ (id) starSprite {
    
    StarSprite *starSprite = nil;
    
    NSString *starType = [self getRandomStar];
        
    if ((starSprite = [[super alloc] initWithSpriteFrameName:starType]))
    {
        [starSprite setupStar];
    }
                       
    return starSprite;
}

+(NSString*) getRandomStar
{    
    int chance = arc4random() % 100;    
    
    if(chance <= 20) { return @"starX.png"; }

    if(chance <= 40) { return @"starBluePlus.png"; }
    
    if(chance <= 60) { return @"starBluePlusSmall.png"; }
    
    if(chance <= 80) { return @"starSmall.png"; }
    
    if(chance <= 1000) { return @"starSmallGalaxy.png"; }
        
    return @"starX.png";
}

-(void) setupStar
{
    int randomY = arc4random() % 55;    
    [self setPosition:ccp(-10, randomY)];   

    int randomRotation = arc4random() % 359;    
    [self setRotation:randomRotation];
}


@end
