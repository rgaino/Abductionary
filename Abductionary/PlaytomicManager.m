//
//  PlaytomicManager.m
//  Abductionary
//
//  Created by Rafael Gaino on 1/12/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "PlaytomicManager.h"
#import "AppDelegate.h"

@implementation PlaytomicManager

static PlaytomicManager* _playtomicManager = nil;


+(PlaytomicManager *) getInstance
{
	@synchronized([PlaytomicManager class])
	{
		if (!_playtomicManager)
			[[self alloc] init];
        
		return _playtomicManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([PlaytomicManager class])
	{
		NSAssert(_playtomicManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_playtomicManager = [super alloc];
		return _playtomicManager;
	}
    
	return nil;
}

-(id)init 
{
	self = [super init];
	if (self != nil) {
        [[Playtomic alloc] initWithGameId:5938 andGUID:@"f4afe3cb95944711" andAPIKey:@"f5f3f87425e34805ba08f94d83f385"];
	}
    
	return self;
}

-(void) logView
{
    NSLog(@"PLAYTOMIC: logging view");
    [[Playtomic Log] view];
}

-(void) logPlay
{
    NSLog(@"PLAYTOMIC: logging play");
    [[Playtomic Log] play];
    
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    
    switch ([appDelegate currentGameMode]  ) {
        case kGameModeEasy:
            NSLog(@"PLAYTOMIC: logging playEasy");
            [[Playtomic Log] customMetricName:@"PlayEasy" andGroup:nil andUnique:NO];
            break;
        case kGameModeMedium:
            NSLog(@"PLAYTOMIC: logging playMedium");
            [[Playtomic Log] customMetricName:@"PlayMedium" andGroup:nil andUnique:NO];
            break;
        case kGameModeHard:
            NSLog(@"PLAYTOMIC: logging playHard");
            [[Playtomic Log] customMetricName:@"PlayHard" andGroup:nil andUnique:NO];
            break;
        default:
            break;
    }
}

-(void) logLevel:(int)level
{    
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    NSString *gameModeString = @"";
   
    switch ([appDelegate currentGameMode]  ) {
        case kGameModeEasy:
            gameModeString = @"Easy";
            break;
        case kGameModeMedium:
            gameModeString = @"Medium";
            break;
        case kGameModeHard:
            gameModeString = @"Hard";
            break;
        default:
            break;
    }

    NSString *levelLogString = [NSString stringWithFormat:@"level_%d_mode_%@", level, gameModeString];
    NSLog(@"PLAYTOMIC: logging %@", levelLogString);
    
    [[Playtomic Log] customMetricName:levelLogString andGroup:nil andUnique:NO];
    
    NSLog(@"PLAYTOMIC: logging BEGAN Level %d", level);
    [[Playtomic Log] levelCounterMetricName:@"Began" andLevelNumber:level andUnique:NO];

    if(level>1) {
        NSLog(@"PLAYTOMIC: logging ENDED Level %d", (level-1));
        [[Playtomic Log] levelCounterMetricName:@"Ended" andLevelNumber:(level-1) andUnique:NO];
    }
}

-(void) logGameOverWithScore:(int64_t) score forLevel:(int) level
{
    NSLog(@"PLAYTOMIC: logging gameOver");
    AppController *appDelegate = (AppController*)[[UIApplication sharedApplication] delegate];
    
    NSString *gameModeString = @"";
    
    switch ([appDelegate currentGameMode]  ) {
        case kGameModeEasy:
            NSLog(@"PLAYTOMIC: logging gameOverEasy");
            gameModeString = @"Easy";
            [[Playtomic Log] customMetricName:@"GameOverEasy" andGroup:nil andUnique:NO];
            break;
        case kGameModeMedium:
            NSLog(@"PLAYTOMIC: logging gameOverMedium");
            gameModeString = @"Medium";
            [[Playtomic Log] customMetricName:@"GameOverMedium" andGroup:nil andUnique:NO];
            break;
        case kGameModeHard:
            NSLog(@"PLAYTOMIC: logging gameOverHard");
            gameModeString = @"Hard";
            [[Playtomic Log] customMetricName:@"GameOverHard" andGroup:nil andUnique:NO];
            break;
        default:
            break;
    }
    
    NSString *levelLogString = [NSString stringWithFormat:@"level_%d_mode_%@", level, gameModeString];

    NSLog(@"PLAYTOMIC: logging score of %lld for level %d", score, level);
    [[Playtomic Log] levelAverageMetricName:@"Score" andLevel:levelLogString andValue:score andUnique:NO];

    NSLog(@"PLAYTOMIC: logging score of %lld for game mode", score, level);
    [[Playtomic Log] levelAverageMetricName:@"Score" andLevel:gameModeString andValue:score andUnique:NO];
}


-(void) freeze
{
    NSLog(@"PLAYTOMIC: freezing");
    [[Playtomic Log] freeze];
}

-(void) unfreeze
{
    NSLog(@"PLAYTOMIC: unfreezing");
    [[Playtomic Log] unfreeze];
}


@end
