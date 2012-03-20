//
//  ScrollingLetter.h
//  Abductionary
//
//  Created by Rafael Gaino on 3/3/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScrollingLetter : CCSprite {

	BOOL _scrolling;
    BOOL _isScrambledWord;
	char _letter;
    int _indexInWord;
	CGPoint _originalPositionOnScrollingArea;
}

@property (nonatomic, readwrite) BOOL scrolling;

-(ScrollingLetter *) initWithLetter:(char) letter;
-(ScrollingLetter *) initWithWildcard;
-(ScrollingLetter *) initWithLetter:(char) letter isScrambledWord:(BOOL) scrambledWordFlag indexInWord:(int) indexInWord;
-(NSString *) getLetter;
-(void) rememberOriginalPositionOnScrollingArea;
-(void) returnToOriginalPositionOnScrollingArea:(NSMutableArray *) scrollingLetters;
-(BOOL) hasOverlappingFrame:(CGRect) frame inArray:(NSMutableArray *) scrollingLetters;
-(CGPoint) getRandomPosition;
-(float) getRandomChuteXPosition;
-(float) getChuteXPositionForIndexInWord;
-(BOOL) isScrambledWord;
-(void) scrollBy:(float) letterScrollOffsetY;

@end
