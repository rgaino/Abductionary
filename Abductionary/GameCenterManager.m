//
//  GameCenterManager.m
//  Abductionary
//
//  Created by Rafael Gaino on 6/6/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "GameCenterManager.h"
#import "I18nManager.h"

@implementation GameCenterManager

@synthesize isRetrievingScores;

static GameCenterManager *_gameCenterManagerInstance = nil;


+(GameCenterManager *) getInstance
{
	@synchronized([GameCenterManager class])
	{
		if (!_gameCenterManagerInstance)
			_gameCenterManagerInstance = [[GameCenterManager alloc] init];
        
		return _gameCenterManagerInstance;
	}
    
	return nil;
}


+(id)alloc
{
	@synchronized([GameCenterManager class])
	{
		NSAssert(_gameCenterManagerInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_gameCenterManagerInstance = [super alloc];
		return _gameCenterManagerInstance;
	}
    
	return nil;
}

-(id)init 
{
	self = [super init];
    
	if (self != nil) {
        if ([self isGameCenterAvailable]) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                       selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                       object:nil];
            
            isRetrievingScores = NO;
        }
	}

	return self;
}

- (BOOL)isGameCenterAvailable 
{
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void)authenticationChanged 
{    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;           
        [self retrySavedFailedScores];
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

- (void) authenticateLocalPlayer
{
    if (![self isGameCenterAvailable]) return;
    
    NSLog(@"Authenticating local user...");
    
    
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {     

        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (localPlayer.isAuthenticated)
            {
                [self retrySavedFailedScores];
            }
            else 
            {
                NSLog(@"Authentication failed with error [%@]", [error description]);
            }
        }];
        
        
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void) reportScore: (int64_t) score forCategory: (kGameMode) gameMode
{
    
    NSString *leaderboardCategory = [self getLeaderboardCategoryForGameMode:gameMode];    
    NSLog(@"Reporting scores for category %@", leaderboardCategory);
    
    
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:leaderboardCategory] autorelease];
    
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // handle the reporting error
            NSLog(@"Score not submitted. Error [%@]", [error localizedDescription]);
            [self saveScoreForLater:scoreReporter];
        } else
        {
            NSLog(@"Score of %lld for category %@ reported successfully", score, leaderboardCategory);
        }
    }];
}

- (void) retrieveScoresForGameMode:(kLeaderboardGameMode)leaderboardGameMode scope:(kLeaderboardScope)leaderboardScope period:(kLeaderboardTimePeriod)leaderboardTimePeriod withCallback:(id<GameCenterManagerDelegate>) callbackDelegate
{
    if(leaderboardResults != nil) { return; }

    isRetrievingScores = YES;
    
    leaderboardResults = [[NSMutableArray alloc] init];
    
    GKLeaderboardPlayerScope playerScope;
    GKLeaderboardTimeScope timeScope;
    NSString *leaderboardCategory = [self getLeaderboardCategoryForGameMode:leaderboardGameMode];    
    NSLog(@"Retrieving scores for category %@", leaderboardCategory);
    
    switch( leaderboardScope )
    {
        case kLeaderboardScopeGlobal:
            NSLog(@"Retrieving scores for scope Global");
            playerScope = GKLeaderboardPlayerScopeGlobal;
            break;
        case kLeaderboardScopeFriends:
            NSLog(@"Retrieving scores for scope Friends");
            playerScope = GKLeaderboardPlayerScopeFriendsOnly;
            break;
    }
    
    switch( leaderboardTimePeriod )
    {
        case kLeaderboardTimePeriodAllTime:
            NSLog(@"Retrieving scores for period All Time");
            timeScope = GKLeaderboardTimeScopeAllTime;
            break;
        case kLeaderboardTimePeriodWeek:
            NSLog(@"Retrieving scores for period Week");
            timeScope = GKLeaderboardTimeScopeWeek;
            break;
        case kLeaderboardTimePeriodToday:
            NSLog(@"Retrieving scores for period Today");
            timeScope = GKLeaderboardTimeScopeToday;
            break;
    }
    
    
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = playerScope;
        leaderboardRequest.category = leaderboardCategory;
        leaderboardRequest.timeScope = timeScope;
        leaderboardRequest.range = NSMakeRange(1,100);
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            
            if (error != nil)
            {
                NSLog(@"Failed to retrieve leaderboards with error [%@]", [error localizedDescription]);
                [leaderboardResults release];
                leaderboardResults = nil;
                [callbackDelegate errorLoadingScores:error];
                isRetrievingScores = NO;
                return;
            }

            if (scores != nil)
            {
                NSMutableArray *retrievePlayerIDs = [[[NSMutableArray alloc]init]autorelease];

                for(GKScore *playerScore in scores)
                {
                    GameCenterPlayerScore *gameCenterPlayerScore = [[GameCenterPlayerScore alloc] init];
                    [gameCenterPlayerScore setDate:playerScore.date];
                    [gameCenterPlayerScore setFormattedValue:playerScore.formattedValue];
                    [gameCenterPlayerScore setPlayerID:playerScore.playerID];
                    [gameCenterPlayerScore setRank:playerScore.rank];
                    [gameCenterPlayerScore setCategory:playerScore.category];
                    
                    [leaderboardResults addObject:gameCenterPlayerScore];
                    [retrievePlayerIDs addObject:playerScore.playerID];  
                    
                    [gameCenterPlayerScore release];

                }
                
                [GKPlayer loadPlayersForIdentifiers:retrievePlayerIDs withCompletionHandler:^(NSArray *playerArray, NSError *error)
                 {
                     if (error != nil)
                     {
                         NSLog(@"Failed to retrieve players with error [%@]", [error localizedDescription]);
                         [callbackDelegate errorLoadingScores:error];

                     } else {
                         for (GKPlayer* player in playerArray)
                         {
                             for(GameCenterPlayerScore *gcp in leaderboardResults)
                             {
                                if( [gcp.playerID compare:player.playerID] == NSOrderedSame ) 
                                {
                                    [gcp setAlias:player.alias];
                                }
                             }
                             
                         }
                         
                         NSLog(@"Leaderboards loaded successfully");
                         [callbackDelegate didFinishLoadingScores:leaderboardResults];
                         [leaderboardResults release];
                         leaderboardResults = nil;
                     }
                 }]; 
            } else 
            {
                NSLog(@"no scores reported, passing empty array");
                [callbackDelegate didFinishLoadingScores:leaderboardResults];
                [leaderboardResults release];
                leaderboardResults = nil;
            }
        }];
        
        [leaderboardRequest release];
    }

    isRetrievingScores = NO;
}


-(void) saveScoreForLater:(GKScore*) playerScore
{
    NSLog(@"Saving score of %lld for player %@", [playerScore value], [playerScore playerID]);
    
    NSMutableArray *savedFailedScores = [self getSavedFailedScores];
    
    [savedFailedScores addObject:playerScore];
    
    NSLog(@"All Failed Scores stored:");
    
    for(GKScore *failedPlayerScore in savedFailedScores)
    {
        NSLog(@"Failed saved score of %lld for player %@ on date %@", [failedPlayerScore value], [failedPlayerScore playerID], [failedPlayerScore date]);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:savedFailedScores] forKey:kUserDefaultsSavedFailedScores];

    [savedFailedScores release];
}

-(void) retrySavedFailedScores
{
    NSMutableArray *savedFailedScores = [self getSavedFailedScores];

    NSLog(@"Retrying %d failed saved scores...", [savedFailedScores count]);
    for(GKScore *failedPlayerScore in savedFailedScores)
    {
        [failedPlayerScore reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                NSLog(@"Retry score not submitted. Error [%@]", [error localizedDescription]);
            } else
            {
                NSLog(@"Score of %lld for category %@ reported successfully", failedPlayerScore.value, failedPlayerScore.category);
                [self removeScoreFromSavedFailedScores:failedPlayerScore];
            }
        }];

    }

    [savedFailedScores release];
}

-(void) removeScoreFromSavedFailedScores:(GKScore*) score
{

    NSMutableArray *savedFailedScores = [self getSavedFailedScores];
    
    for(int i=0; i<[savedFailedScores count]; i++)
    {
        GKScore *failedPlayerScore = [savedFailedScores objectAtIndex:i];

        if(failedPlayerScore.value == score.value && [failedPlayerScore.playerID compare:score.playerID] == NSOrderedSame)
        {
            NSLog(@"Removing score of %lld for player %@ category %@ from failed saved scores list.", failedPlayerScore.value, failedPlayerScore.playerID, failedPlayerScore.category);
            [savedFailedScores removeObjectAtIndex:i];
            break;
        }
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:savedFailedScores] forKey:kUserDefaultsSavedFailedScores];

    [savedFailedScores release];
}

-(NSMutableArray*) getSavedFailedScores
{
    NSMutableArray *savedFailedScores = [[NSMutableArray alloc] init];
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:kUserDefaultsSavedFailedScores];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
        {
            [savedFailedScores   release];
            savedFailedScores = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
    }
    
    NSLog(@"There are %d saved scores.", [savedFailedScores count]);
    return savedFailedScores;
}

-(NSString*) getLeaderboardCategoryForGameMode:(kLeaderboardGameMode)leaderboardGameMode
{
    NSString *leaderboardCategory;
    
    switch( leaderboardGameMode )
    {
        case kLeaderboardGameModeEasy:
            leaderboardCategory = kLeaderboardCategoryEasy;
            break;
        case kLeaderboardGameModeMedium:
            leaderboardCategory = kLeaderboardCategoryMedium;
            break;
        case kLeaderboardGameModeHard:
            leaderboardCategory = kLeaderboardCategoryHard;
            break;     
    }

    
    //append language suffix for localized leaderboards. English has no suffix to preserve old scores before i18n.
    
    if ( [[[I18nManager getInstance] currentLanguage] isEqualToString:@"en"] ) {
        return leaderboardCategory;
    }
    
    NSString *localizedLeaderboardCategory = [NSString stringWithFormat:@"%@_%@", leaderboardCategory, [[I18nManager getInstance] currentLanguage]];
    
    return localizedLeaderboardCategory;
}


-(void) dealloc
{
    [leaderboardResults release];
    leaderboardResults = nil;

    [super dealloc];
}

@end
