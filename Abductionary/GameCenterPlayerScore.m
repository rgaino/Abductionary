//
//  GameCenterPlayerScore.m
//  Abductionary
//
//  Created by Rafael Gaino on 6/7/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "GameCenterPlayerScore.h"


@implementation GameCenterPlayerScore

@synthesize category;
@synthesize playerID;
@synthesize alias;
@synthesize formattedValue;
@synthesize date;
@synthesize rank;
@synthesize gameMode;

-(void) dealloc
{
    [category release];
    [playerID release];
    [alias release];
    [formattedValue release];
    [date release];

    [super dealloc];
}
@end
