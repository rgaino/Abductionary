//
//  AppDelegate.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/19/12.
//  Copyright DOJO 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Constants.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@property (nonatomic, assign) int64_t playerScore;
@property (nonatomic, assign) float failCounterValue;
@property (nonatomic, assign) int powerUpValue;
@property (nonatomic, assign) kGameMode currentGameMode;


@end
