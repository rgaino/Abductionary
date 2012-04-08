//
//  Dictionary.m
//  Letterfall
//
//  Created by Rafael Gaino on 2/18/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "Dictionary.h"
#import "Constants.h"
#import "I18nManager.h"

@implementation Dictionary

@synthesize dictionaryType = _dictionaryType;
@synthesize isStreaking = _isStreaking;
@synthesize letterScoreValues = _letterScoreValues;
@synthesize streakScoreValues = _streakScoreValues;

static Dictionary *_dictionary = nil;

+(Dictionary*) getInstance
{
	@synchronized([Dictionary class])
	{
		if (!_dictionary)
			[[self alloc] init];
        
		return _dictionary;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([Dictionary class])
	{
		NSAssert(_dictionary == nil, @"Attempted to allocate a second instance of a singleton.");
		_dictionary = [super alloc];
		return _dictionary;
	}
    
	return nil;
}


-(id) init {
    self = [super init];
	
    if ( self ) 
    {
        chosenLetters = [[NSMutableArray alloc] init];
        [self setup];
    }
    return self;
}

-(void) setup
{
    [self loadDictionaries];
    [self loadAlphabet];
	[chosenLetters release];
    chosenLetters = [[NSMutableArray alloc] init];
    [self resetSpelledWords];
    currentScrambledWord = nil;
    streakScore = 1;
    _isStreaking = NO;
    [self setDictionaryType:kRandomLetters];
}

-(void) resetSpelledWords
{
    if(spelledWords != nil)
    {
        [spelledWords release];
        spelledWords = nil;
    }
    spelledWords = [[NSMutableArray alloc] init];
}

-(void) loadAlphabet {	
    scrabbleAlphabet = [[I18nManager getInstance] getScrabbleAlphabet];
    NSLog(@"Loaded alphabet is '%@'", scrabbleAlphabet);
}

-(void) loadDictionaries {
    
    profanityList = [[NSArray alloc] initWithArray:
                      [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profanity_list" ofType:@"txt"]
                                                 encoding:NSMacOSRomanStringEncoding 
                                                    error:NULL] 
                       componentsSeparatedByString:@","]];

    NSLog(@"Loaded %d words into profanity list.", [profanityList count]);
    
    dictionaries = [[NSMutableArray alloc] initWithCapacity:kMaximumWordLength];
    
    for(int i=0; i<kMinimumWordLength; i++) 
    {
        [dictionaries addObject:@"foo"]; //indexes lower than kMinimumWordLenght are "foo" to save memory. There's no need to allocate the dictionary for words that won't be used.
    }
    
    for(int i=kMinimumWordLength; i<=kMaximumWordLength; i++) 
    {
        NSString *fileName = [NSString stringWithFormat:@"words_En_%02d", i];
        
        NSArray *words = [[NSArray alloc] initWithArray:
                            [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]
                                                 encoding:NSMacOSRomanStringEncoding 
                                                    error:NULL] 
                       componentsSeparatedByString:@"\n"]];
        
        [dictionaries addObject:words];
        [words release];
    }
    
}



-(BOOL) isOnDictionary:(NSString *)word 
{	
    if([word rangeOfString:kWildcardString].location == NSNotFound)
    {
        return [self searchWordInDictionary:word];
    } else {
        return [self searchWildcardInDictionary:word];
    }
    
    return NO;
}

-(BOOL) isProfanity:(NSString*) word
{
	if( [profanityList indexOfObject:word] == NSNotFound ) 
    {
        return NO;
    } 	 	
    
    NSLog(@"Word %@ is profanity", word);
	return YES;
}

-(BOOL) searchWordInDictionary:(NSString *)word; 
{
    NSArray *words = [dictionaries objectAtIndex:[word length]];
    
	if( [words indexOfObject:word] != NSNotFound ) 
    {
        lastWordMatch = word;
        return YES;
	 } 	 	
	return NO;
}

-(BOOL) searchWildcardInDictionary:(NSString *) word
{
    
    NSMutableString *searchString = [NSMutableString stringWithString:word];
    
    [searchString replaceOccurrencesOfString:@"*" withString:@"%c" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [word length]) ];
    
    for(int i=0; i<[kAlphabetScored length]; i++)
    {
        unichar character=[kAlphabetScored characterAtIndex:i];
        NSString *searchWord = [NSString stringWithFormat:searchString, character];
        if( [self searchWordInDictionary:searchWord] ) {
            lastWildcardCharMatch = character;
            NSLog(@"Wildcard match: %@ as %@", word, lastWordMatch);
            return YES;
        }
    }
    return NO;
}

-(unichar) getLastWildcardCharMatch 
{
    return lastWildcardCharMatch;
}

-(NSString *) getLastWordMatch
{
    return lastWordMatch;
}


-(BOOL) wasWordAlreadySpelled:(NSString *) word 
{    
    
    if( [spelledWords indexOfObject:word] == NSNotFound ) 
    {
		return NO;
    } 
	return YES;
}

-(char) getRandomLetter {
	int randomLetterIndex = arc4random() % [scrabbleAlphabet length];
	char randomChar = [scrabbleAlphabet characterAtIndex:randomLetterIndex];
	return randomChar;	
}


-(char) getNewLetter {

	char newLetter;
	
    if( [self dictionaryType] == kRandomLetters )
    {
        newLetter = [self getRandomLetter];
        
        while( [self letterWasRecentlyPicked:newLetter] || [self letterRepeatedTooMuch:newLetter] ) 
        {
            newLetter = [self getRandomLetter];
        }
        
    }
    else if( [self dictionaryType] == kScrambledWordsAsLetters)
    {
        newLetter = [self getNextLetterOfCurrentScrambledWord];
    }
    else {
        newLetter = 'x';
    }
    
    [chosenLetters addObject:[NSString stringWithFormat:@"%c", newLetter]];
    return newLetter;
}

-(BOOL) letterRepeatedTooMuch:(char) newLetter
{
    
    int letterOccurrences = 0;
    
    for(int i=0; i<[chosenLetters count]; i++) {

        if( i>=kCheckForRepeteadLettersCount) {
            break;
        }
        
        int index = [chosenLetters count] - 1 - i;
        
        NSString *newLetterString = [NSString stringWithFormat:@"%c", newLetter];
        NSString *pastLetter = [chosenLetters objectAtIndex:index];
        
        if( [newLetterString isEqualToString:pastLetter ] ) {
            letterOccurrences++;
        }
    }    
    
    if( letterOccurrences>kCheckForRepeteadLettersOccurencesAllowed) {
        return YES;
    }
      
    return NO;
}

-(BOOL) letterWasRecentlyPicked:(char) newLetter
{
    if( [chosenLetters count]<=kDontRepeatThisManyLastLetters ) {
        return NO;
    }
    
    for(int i=1; i<=kDontRepeatThisManyLastLetters; i++) {
        
        int index = [chosenLetters count] - i;
        
        NSString *newLetterString = [NSString stringWithFormat:@"%c", newLetter];
        NSString *pastLetter = [chosenLetters objectAtIndex:index];
        
        if( [newLetterString isEqualToString:pastLetter ] ) {
            return YES;
        }
    }

    return NO;
}


-(int64_t) wordScore:(NSString *)word 
{
    int score = 0;
		
    if( ![self wasWordAlreadySpelled:word] ) 
    {
        [spelledWords addObject:word];
        NSLog(@"Total of %d words spelled in this game.", [spelledWords count]);
    }
    

    
    NSMutableArray *streakArray = [[NSMutableArray alloc] init];
    NSMutableArray *letterValuesArray = [[NSMutableArray alloc] init];
    
    for(int i=1; i<=[word length]; i++) 
    {
        [streakArray addObject:[NSNumber numberWithInt:streakScore]];
        
		score+=streakScore;
        streakScore++;
        
        unichar letter = [word characterAtIndex:i-1];
        int scrabbleValue = [self scrabbleValueForLetter:letter];
        [letterValuesArray addObject:[NSNumber numberWithInt:scrabbleValue]];

        score+=scrabbleValue;
	}
    
    [self setStreakScoreValues:streakArray];
    [self setLetterScoreValues:letterValuesArray];
    
    [streakArray release];
    [letterValuesArray release];

    if(!_isStreaking)
    {
        streakScore = 1;
    }
    
	return score;
}


-(int) scrabbleValueForLetter:(unichar) charLetter
{
    NSString *letter = [NSString stringWithFormat:@"%c", charLetter];
    int value=0;
    
    if ([kOnePointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 1;
    } else if ([kTwoPointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 2;
    } else if ([kThreePointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 3;
    } else if ([kFourPointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 4;
    } else if ([kFivePointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 5;
    } else if ([kEightPointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 8;
    } else if ([kTenPointLetters rangeOfString:letter].location != NSNotFound)
    {
        value = 10;
    }
    
    return value;
}

-(NSString *) getRandomWordWithLenght:(int) length 
{
    NSArray *words = [dictionaries objectAtIndex:length];
    
    int randomIndex = arc4random() % [words count];
    NSString *word = [words objectAtIndex:randomIndex];
    
    return word;
}

-(NSString *) scrambleWord:(NSString *)word
{
    NSMutableString *inString = [NSMutableString stringWithString:word];
    NSMutableString *scrambledString = [NSMutableString string];
    int currentLength;
    NSRange oneCharRange;

    currentLength = [inString length];
    while(currentLength)
    {
        oneCharRange = NSMakeRange(arc4random() % currentLength,1);
        
        [scrambledString appendString:[inString substringWithRange:oneCharRange]];
        [inString deleteCharactersInRange:oneCharRange];
        
        currentLength--;
    }
    
    NSLog(@"Random word is '%@', scrambled to '%@'", word, scrambledString);

    return scrambledString;
}

-(char) getNextLetterOfCurrentScrambledWord
{
    char nextLetter;
    
    if( currentScrambledWord == nil )
    {
        int wordLenght = (arc4random() % kMaximumWordLength) + kMinimumWordLength;
        NSString *nextWord = [self getRandomWordWithLenght:wordLenght];
        currentScrambledWord = [[NSMutableString stringWithString:[self scrambleWord:nextWord]] retain];
//        NSLog(@"word is %@ scrambled to %@", nextWord, currentScrambledWord);
    }
    
    int letterIndex = [currentScrambledWord length]-1;
      
    nextLetter = [currentScrambledWord characterAtIndex:letterIndex];
    [currentScrambledWord deleteCharactersInRange:NSMakeRange(letterIndex, 1)];
    
    if([currentScrambledWord length] == 0)
    {
        [currentScrambledWord release];
        currentScrambledWord = nil;
    }
    return nextLetter;
}

-(NSMutableArray *) spelledWords
{
    return spelledWords;
}

- (void)dealloc 
{	
    [profanityList release];
	[dictionaries release];
	[scrabbleAlphabet release];
	[chosenLetters release];
    [spelledWords release];

    [_streakScoreValues release];
    _streakScoreValues = nil;
    
    [_letterScoreValues release];
    _letterScoreValues = nil;
    
    [super dealloc];
}


@end
