//
//  GameCenterManagerDelegate.h
//  Abductionary
//
//  Created by Rafael Gaino on 6/11/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameCenterManagerDelegate <NSObject>

-(void) didFinishLoadingScores:(NSMutableArray*) leaderboardResults;
-(void) errorLoadingScores:(NSError*) error;

@end
