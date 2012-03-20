//
//  HumanSpriteRandomizer.h
//  Abductionary
//
//  Created by Rafael Gaino on 10/31/11.
//  Copyright (c) 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HumanSpriteRandomizer : NSObject
{
    NSMutableArray *humans;
}

+(HumanSpriteRandomizer*) getInstance;

-(int) getNextHumanId;

@end
