//
//  LeaderboardsLayer.h
//  Abductionary
//
//  Created by Rafael Gaino on 6/7/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LeaderboardsLayer : CCLayerColor 
{    
    NSMutableArray *rankLabels;
    NSMutableArray *playerNameLabels;
    NSMutableArray *dateLabels;
    NSMutableArray *scoreLabels;
}

-(void) setupScoreLabels;
-(void) updateScoreLabelsWithScores:(NSMutableArray*) leaderboardResults;


@end
