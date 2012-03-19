//
//  Dictionary.h
//  Letterfall
//
//  Created by Rafael Gaino on 2/18/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Dictionary : NSObject {
	
    NSMutableArray *dictionaries;
	NSString *scrabbleAlphabet;
	NSMutableArray *chosenLetters;
    NSMutableArray *spelledWords;
    unichar lastWildcardCharMatch;
    NSString *lastWordMatch;
    NSMutableString *currentScrambledWord;
    int streakScore;
    
    NSMutableArray *_letterScoreValues;
    NSMutableArray *_streakScoreValues;
    NSArray *profanityList;
}

@property (nonatomic, retain) NSMutableArray *letterScoreValues;
@property (nonatomic, retain) NSMutableArray *streakScoreValues;
@property (nonatomic, assign) kDictionaryType dictionaryType;
@property (nonatomic, readwrite) BOOL isStreaking;

+(Dictionary *) getInstance;

-(void) loadDictionaries;
-(void) loadAlphabet;
-(BOOL) isOnDictionary:(NSString *)word;
-(BOOL) searchWordInDictionary:(NSString *)word;
-(int64_t) wordScore:(NSString *)word;
-(char) getNewLetter;
-(char) getRandomLetter;
-(int) scrabbleValueForLetter:(unichar) letter;
-(BOOL) wasWordAlreadySpelled:(NSString *) word;
-(NSString *) getRandomWordWithLenght:(int) lenght ;
-(NSString *) scrambleWord:(NSString *)word;
-(BOOL) searchWildcardInDictionary:(NSString *) word;
-(unichar) getLastWildcardCharMatch;
-(NSString *) getLastWordMatch;
-(BOOL) letterWasRecentlyPicked:(char) newLetter;
-(BOOL) letterRepeatedTooMuch:(char) newLetter;
-(char) getNextLetterOfCurrentScrambledWord;
-(NSMutableArray *) spelledWords;
-(void) resetSpelledWords;
-(BOOL) isProfanity:(NSString*) word;

@end
