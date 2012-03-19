//
//  CCSprite+extension.m
//  Abductionary
//
//  Created by Rafael Gaino on 1/12/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "CCSprite+extension.h"

@implementation CCSprite (extension)

-(void) removeFromParentAndCleanupYES
{
    [self removeFromParentAndCleanup:YES];
}

@end
