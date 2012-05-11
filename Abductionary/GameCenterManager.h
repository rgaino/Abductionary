//
//  GameCenterManager.h
//  Abductionary
//
//  Created by Rafael Gaino on 6/6/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainMenuScene.h"
#import "GameCenterManagerDelegate.h"
#import <GameKit/GameKit.h>
#import "GameCenterPlayerScore.h"
#import "Constants.h"

@interface GameCenterManager : NSObject 
{
    BOOL userAuthenticated;
    NSMutableArray *leaderboardResults;
    BOOL isRetrievingScores;
}

@property (nonatomic, readonly) BOOL isRetrievingScores;

+(GameCenterManager*) getInstance;

-(BOOL) isGameCenterAvailable;
-(void) authenticationChanged;
-(void) authenticateLocalPlayer;
-(void) reportScore: (int64_t) score forCategory: (kGameMode) gameMode;
-(void) retrieveScoresForGameMode:(kLeaderboardGameMode)leaderboardGameMode scope:(kLeaderboardScope)leaderboardScope period:(kLeaderboardTimePeriod)leaderboardTimePeriod withCallback:(id<GameCenterManagerDelegate>) callbackDelegate;
-(void) saveScoreForLater:(GKScore*) playerScore;
-(NSMutableArray*) getSavedFailedScores;
-(void) retrySavedFailedScores;
-(void) removeScoreFromSavedFailedScores:(GKScore*) score;
-(NSString*) getLeaderboardCategoryForGameMode:(kLeaderboardGameMode)leaderboardGameMode;

@end
