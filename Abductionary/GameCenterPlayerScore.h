//
//  GameCenterPlayerScore.h
//  Abductionary
//
//  Created by Rafael Gaino on 6/7/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameCenterPlayerScore : NSObject {
    
}

@property(nonatomic, retain) NSString *category;
@property(nonatomic, retain) NSString *playerID;
@property(nonatomic, retain) NSString *alias;
@property(nonatomic, retain) NSString *formattedValue;
@property(nonatomic, retain) NSDate   *date;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, assign) kGameMode gameMode;

@end
