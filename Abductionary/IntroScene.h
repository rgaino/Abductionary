//
//  IntroScene.h
//  Abductionary
//
//  Created by Rafael Gaino on 2/2/12.
//  Copyright 2012 DOJO. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "CCVideoPlayer.h"

@class MPMoviePlayerController;

@interface IntroScene : CCLayer //<CCVideoPlayerDelegate> 
{
//    CCLabelTTF *subtitleLabel;
    UILabel *subtitleLabel;
    MPMoviePlayerController *moviePlayer;
}

+(CCScene *) scene;
-(void) scheduleAllSubtitles;

@end
