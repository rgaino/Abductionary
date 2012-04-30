//
//  ScrollingLetter.m
//  Abductionary
//
//  Created by Rafael Gaino on 3/3/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "ScrollingLetter.h"
#import "Constants.h"

@implementation ScrollingLetter

@synthesize scrolling = _scrolling;


-(ScrollingLetter *) initWithLetter:(unichar) letter {

    return [self initWithLetter:letter isScrambledWord:NO indexInWord:-1];
}

-(ScrollingLetter *) initWithWildcard {
    return [self initWithLetter:[kWildcardString characterAtIndex:0] isScrambledWord:NO indexInWord:-1];
}


-(ScrollingLetter *) initWithLetter:(unichar) letter isScrambledWord:(BOOL) scrambledWordFlag indexInWord:(int) indexInWord 
{	
	_letter = letter;
    _indexInWord = indexInWord;
    _isScrambledWord = scrambledWordFlag;
    
	NSString *filename; 
    
    if(_isScrambledWord) {
        filename = [NSString stringWithFormat:@"%C_special.png", letter];
    } else if(letter == [kWildcardString characterAtIndex:0]) {
        filename = @"wildcard.png";
    } else {
        filename = [NSString stringWithFormat:@"%C.png", letter];
    }
    
    
	if( (self=[super initWithSpriteFrameName:filename])) {

		[self setPosition: [self getRandomPosition] ];
		[self setScrolling:YES];
	}
        
	return self;
}

-(void) scrollBy:(float) letterScrollOffsetY 
{
    if([self scrolling]) 
    {
        [self setPosition:ccp(self.position.x, self.position.y - letterScrollOffsetY)];
    } else {
        _originalPositionOnScrollingArea = ccp(_originalPositionOnScrollingArea.x, _originalPositionOnScrollingArea.y - letterScrollOffsetY);
    }
}

-(CGPoint) getRandomPosition 
{
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float y = screenSize.height + (kLetterHeight/2);
    
    float x = [self getRandomChuteXPosition];

    if(!_isScrambledWord)
    {
        while(x == kLastLetterChuteX) 
        {
            x = [self getRandomChuteXPosition];
        }
    } else 
    {
        x = [self getChuteXPositionForIndexInWord];
    }
    
    kLastLetterChuteX = x;
    return CGPointMake(x,y);
}


-(float) getChuteXPositionForIndexInWord 
{
    return kLetterChuteXPositions[_indexInWord+1];
}


-(NSString *) getLetter 
{
	return [NSString stringWithFormat:@"%C", _letter];	
}

-(float) getRandomChuteXPosition 
{
    int randomIndex = arc4random() % kLetterChuteCount;
    return kLetterChuteXPositions[ randomIndex ];

}

-(void) rememberOriginalPositionOnScrollingArea 
{
	_originalPositionOnScrollingArea = [self position];
}

-(void) returnToOriginalPositionOnScrollingArea:(NSMutableArray *) scrollingLetters 
{

	id moveToAction = [CCMoveTo actionWithDuration:kMoveLetterToSlotAnimationSpeed position:_originalPositionOnScrollingArea];
	[self runAction:moveToAction];
	[self setScrolling:YES];
}

-(BOOL) hasOverlappingFrame:(CGRect) frame inArray:(NSMutableArray *) scrollingLetters 
{
	
	for(ScrollingLetter *scrollingLetter in scrollingLetters) {
		if( scrollingLetter != self ) {

            CGRect scrollingLetterFrame = [scrollingLetter boundingBox];
        
            if(	CGRectIntersectsRect(frame, scrollingLetterFrame) ) {
                return YES;
            }
        }
	}
	return NO;
}


-(BOOL) isScrambledWord 
{
    return _isScrambledWord;
}


- (void) dealloc
{
	[super dealloc];
}


/*
-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	if( (self=[super initWithTexture:texture rect:rect]))
	{
//        ivar1 = xxx;
//        ivar2 = yyy;
//        ivar3 = zzz;
	}
	return self;
}
*/

@end
