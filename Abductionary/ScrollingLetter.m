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
    
    
	if( (self=[super init])) 
    {
        [self setPosition:[self getRandomPosition]];
		[self setScrolling:YES];
	}
    
    _letterSprite = [CCSprite spriteWithSpriteFrameName:filename];
    [_letterSprite setPosition:ccp(0,0)];
    [self addChild:_letterSprite z:2];
    
    _dropShadowSprite = [CCSprite spriteWithSpriteFrameName:@"letterDropShadow.png"];
    float shadowPosOffsetX = 14;
    float shadowPosOffsetY = 10;
    CGPoint shadowPos = ccp(_letterSprite.position.x-shadowPosOffsetX, _letterSprite.position.y+shadowPosOffsetY);
    [_dropShadowSprite setPosition:shadowPos];
    [self addChild:_dropShadowSprite z:1];
    

    self.isTouchEnabled = NO;
    [self setContentSize:[_dropShadowSprite contentSize]];
        
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
    
    [self fadeInDropShadow];
}

-(BOOL) hasOverlappingFrame:(CGRect) frame inArray:(NSMutableArray *) scrollingLetters 
{
	
	for(ScrollingLetter *scrollingLetter in scrollingLetters) {
		if( scrollingLetter != self ) {

            CGRect scrollingLetterFrame = [scrollingLetter letterSpriteBoundingBox];
        
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


-(void) setOpacity: (GLubyte) o
{
    [_letterSprite setOpacity:o];
    [_dropShadowSprite setOpacity:o];
}

-(void) fadeInDropShadow
{
    id fadeIn = [CCFadeIn actionWithDuration:0.5f];
    [_dropShadowSprite runAction:fadeIn];
}

-(void) fadeOutDropShadow
{
    id fadeOut = [CCFadeOut actionWithDuration:0.5f];
    [_dropShadowSprite runAction:fadeOut];
}


-(CGRect) letterSpriteBoundingBox
{
    CGRect box = CGRectMake(self.position.x - (_letterSprite.contentSize.width/2), self.position. y- (_letterSprite.contentSize.height/2), _letterSprite.contentSize.width, _letterSprite.contentSize.height);
    return box;
}

- (void) dealloc
{
	[super dealloc];
}



@end
