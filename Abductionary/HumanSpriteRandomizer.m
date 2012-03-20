//
//  HumanSpriteRandomizer.m
//  Abductionary
//
//  Created by Rafael Gaino on 10/31/11.
//  Copyright (c) 2011 DOJO. All rights reserved.
//

#import "HumanSpriteRandomizer.h"

@implementation HumanSpriteRandomizer

static HumanSpriteRandomizer *_humanSpriteRandomizer = nil;

+(HumanSpriteRandomizer*) getInstance
{
	@synchronized([HumanSpriteRandomizer class])
	{
		if (!_humanSpriteRandomizer)
			[[self alloc] init];
        
		return _humanSpriteRandomizer;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([HumanSpriteRandomizer class])
	{
		NSAssert(_humanSpriteRandomizer == nil, @"Attempted to allocate a second instance of a singleton.");
		_humanSpriteRandomizer = [super alloc];
		return _humanSpriteRandomizer;
	}
    
	return nil;
}


-(id) init {
    self = [super init];
	
    if ( self ) {
    }
	
    return self;
}


-(int) getNextHumanId 
{
    
    if(humans == nil) 
    {
        humans = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInt:1],
                                                          [NSNumber numberWithInt:2],
                                                          [NSNumber numberWithInt:3],
                                                          [NSNumber numberWithInt:4],
                                                          [NSNumber numberWithInt:5],
                                                          [NSNumber numberWithInt:6],
                                                          [NSNumber numberWithInt:7],
                                                          [NSNumber numberWithInt:8],
                                                           nil];
    }
    
    int chance = arc4random() % [humans count];
    
    NSNumber *humanId = [humans objectAtIndex:chance];
    NSLog(@"Randomly selected human index is %03d out of %d", [humanId integerValue], [humans count]);
    
    [humans removeObjectAtIndex:chance];
    if( [humans count] == 0 )
    {
        [humans release];
        humans = nil;
    }
    
    return [humanId integerValue];
}

@end
