//
//  LeaderboardsLayer.m
//  Abductionary
//
//  Created by Rafael Gaino on 6/7/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "LeaderboardsLayer.h"
#import "Constants.h"
#import "GameCenterPlayerScore.h"
#import "NSDate+Helper.h"
#import "NSString+NSString_Helper.h"
#import "I18nManager.h"
#import "CCLabelTTF+extension.h"

@implementation LeaderboardsLayer

-(id) init
{
    if( (self=[super initWithColor:ccc4(255,100,100,0) width:550 height:290 ] )) 
    {
        [self setupTableTitles];
        [self setupScoreLabels];
    }
    return self;
}

-(void) setupTableTitles
{
    float y = 295;
    float fontSize = 23;
 
    CCLabelTTF *rankingLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Rank"] dimensions:CGSizeMake(30, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:fontSize];
    [rankingLabel setPosition:ccp(55, y)];
    [rankingLabel setColor:ccc3(25, 153, 173)];
    [self addChild:rankingLabel];

    CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Name"] dimensions:CGSizeMake(150, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:fontSize];
    [nameLabel setPosition:ccp(205, y)];
    [nameLabel setColor:ccc3(25, 153, 173)];
    [self addChild:nameLabel];

    CCLabelTTF *dateLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Date"] dimensions:CGSizeMake(120, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:fontSize];
    [dateLabel setPosition:ccp(350, y)];
    [dateLabel setColor:ccc3(25, 153, 173)];
    [self addChild:dateLabel];

    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[[I18nManager getInstance] getLocalizedStringFor:@"Score"] dimensions:CGSizeMake(120, 50) hAlignment:kCCTextAlignmentRight fontName:kCommonFontName fontSize:fontSize];
    [scoreLabel setPosition:ccp(470, y)];
    [scoreLabel setColor:ccc3(25, 153, 173)];
    [self addChild:scoreLabel];
}

-(void) setupScoreLabels
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

    rankLabels = [[NSMutableArray alloc] init];
    playerNameLabels = [[NSMutableArray alloc] init];
    dateLabels = [[NSMutableArray alloc] init];
    scoreLabels = [[NSMutableArray alloc] init];

    float y=260;
    
    for(int i=0;i<10;i++)
    {
        CCLabelTTF *rankLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(30, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:kLeaderboardFontSize];
		rankLabel.position =  ccp(55, y);
        rankLabel.color = ccc3(0, 167, 255);
        [rankLabels addObject:rankLabel];
        [self addChild:rankLabel];

//        CCLabelTTF *playerNameLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(150, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:kLeaderboardFontSize];
        CCLabelTTF *playerNameLabel = [CCLabelTTF labelWithString:@"" fontName:kCommonFontName fontSize:kLeaderboardFontSize];
		playerNameLabel.position =  ccp(205, y+13);
        playerNameLabel.color = ccc3(0, 167, 255);
        [playerNameLabels addObject:playerNameLabel];
        [self addChild:playerNameLabel];

        CCLabelTTF *dateLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(120, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:kLeaderboardFontSize];
		dateLabel.position =  ccp(350, y);
        dateLabel.color = ccc3(0, 167, 255);
        [dateLabels addObject:dateLabel];
        [self addChild:dateLabel];

        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(120, 50) hAlignment:kCCTextAlignmentRight fontName:kCommonFontName fontSize:kLeaderboardFontSize];
		scoreLabel.position =  ccp(470, y);
        scoreLabel.color = ccc3(0, 167, 255);
        [scoreLabels addObject:scoreLabel];
        [self addChild:scoreLabel];

        
        y-=28;
    }
}

-(void) updateScoreLabelsWithScores:(NSMutableArray*) leaderboardResults
{

    NSLog(@"leaderboards count is %d", [leaderboardResults count]);
    
    for(int i=0;i<10;i++)
    {
        CCLabelTTF *rankLabel = [rankLabels objectAtIndex:i];
        CCLabelTTF *playerNameLabel = [playerNameLabels objectAtIndex:i];
        CCLabelTTF *dateLabel = [dateLabels objectAtIndex:i];
        CCLabelTTF *scoreLabel = [scoreLabels objectAtIndex:i];

        if( i < [leaderboardResults count] )
        {
            GameCenterPlayerScore *gameCenterPlayerScore = [leaderboardResults objectAtIndex:i];
            
            NSLog(@"%d %@ %@ %@",gameCenterPlayerScore.rank, gameCenterPlayerScore.alias, gameCenterPlayerScore.formattedValue, [gameCenterPlayerScore.date stringDaysAgo]);
            [rankLabel setString:[NSString stringWithFormat:@"%d", gameCenterPlayerScore.rank]];
            [playerNameLabel setString:gameCenterPlayerScore.alias];
            [playerNameLabel shrinkFontSizeToFitWidth:150];
            [dateLabel setString:[gameCenterPlayerScore.date stringDaysAgo]];
            [scoreLabel setString:gameCenterPlayerScore.formattedValue];
        } else
        {
            NSLog(@"Rank %d non-existent", i);
            [rankLabel setString:@""];
            [playerNameLabel setString:@""];
            [dateLabel setString:@""];
            [scoreLabel setString:@""];
        }
    }
}
     
     
-(void) dealloc
{
    [rankLabels release];
    [playerNameLabels release];
    [dateLabels release];
    [scoreLabels release];
    [super dealloc];
}

@end
