//
//  LetterSlot.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/5/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingLetter.h"

@interface LetterSlot : CCSprite {

}

@property (nonatomic, retain) ScrollingLetter *scrollingLetterInSlot;


@end
