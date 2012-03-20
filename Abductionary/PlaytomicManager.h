//
//  PlaytomicManager.h
//  Abductionary
//
//  Created by Rafael Gaino on 1/12/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playtomic.h"

@interface PlaytomicManager : NSObject

+(PlaytomicManager*) getInstance;

-(void) logView;
-(void) logPlay;
-(void) logLevel:(int)level;
-(void) logGameOverWithScore:(int64_t) score forLevel:(int) level;

-(void) freeze;
-(void) unfreeze;


@end
