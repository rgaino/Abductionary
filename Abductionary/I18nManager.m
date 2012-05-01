//
//  I18nManager.m
//  Abductionary
//
//  Created by Rafael Gaino on 4/8/12.
//  Copyright (c) 2012 DOJO. All rights reserved.
//

#import "I18nManager.h"
#import "Constants.h"

@implementation I18nManager



static I18nManager* _i18nManager = nil;


+(I18nManager *) getInstance
{
	@synchronized([I18nManager class])
	{
		if (!_i18nManager)
			[[self alloc] init];
        
		return _i18nManager;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([I18nManager class])
	{
		NSAssert(_i18nManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_i18nManager = [super alloc];
		return _i18nManager;
	}
    
	return nil;
}

-(id)init 
{
	self = [super init];
	if (self != nil) 
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        currentLanguage = [userDefaults stringForKey:kUserDefaultsLanguage];

        if(currentLanguage == nil) 
        {
            currentLanguage = @"en";
        }
        
        [self setLanguageTo:currentLanguage];
	}
    
	return self;
}

-(void) setLanguageTo:(NSString*) languageID;
{        
    currentLanguage = languageID;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:languageID forKey:kUserDefaultsLanguage];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:languageID ofType:@"plist" inDirectory:currentLanguage];
    
    if(languageDictionary != nil) 
    {
        [languageDictionary release];
        languageDictionary = nil;
    }
    
    languageDictionary = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
}

-(NSString*) currentLanguage
{
    return currentLanguage;
}

-(NSString *) getLocalizedStringFor:(NSString*) messageString
{
    NSString *localizedString = [languageDictionary objectForKey:messageString];
    
    if(localizedString == nil) {
        localizedString = @"<ERROR>";
    }
    
    return localizedString;
}


-(NSString*) getScrabbleAlphabet
{
    // from http://en.wikipedia.org/wiki/Scrabble_letter_distributions
    
    return [self getLocalizedStringFor:@"scrabble alphabet"];
}


-(void) dealloc
{
    [languageDictionary release];
    languageDictionary = nil;

    [super dealloc];
}

@end
