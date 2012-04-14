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
        NSString *currentLanguage = [userDefaults stringForKey:kUserDefaultsLanguage];

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:languageID forKey:kUserDefaultsLanguage];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:languageID ofType:@"plist"];
    
    if(languageDictionary != nil) 
    {
        [languageDictionary release];
        languageDictionary = nil;
    }
    
    languageDictionary = [[NSDictionary dictionaryWithContentsOfFile:plistPath] retain];
}

-(NSString *) getLocalizedStringFor:(NSString*) messageString
{
    NSString *localizedString = [languageDictionary objectForKey:messageString];
    
    if(localizedString == nil) {
        localizedString = @"<ERROR>";
    }
    
    return localizedString;
}






/*

//Localized string methods
-(NSString*) getLanguageMenuMessageString 
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"(you can change the language later\non the SETTINGS menu)";
            break;
            
        case kLanguageSpanish:
            return @"(puedes cambiar el idioma después\nen el menú CONFIGURACIÓN)";
            break;
            
        case kLanguagePortuguese:
            return @"(para mudar o idioma acesse\no menu de CONFIGURAÇÃO)";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}

-(NSString*) getMainMenuNewGameString
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"NEW GAME";
            break;
            
        case kLanguageSpanish:
            return @"NUEVO JUEGO";
            break;
            
        case kLanguagePortuguese:
            return @"NOVO JOGO";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}



-(NSString*) getMainMenuSettingsString 
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"SETTINGS";
            break;
            
        case kLanguageSpanish:
            return @"CONFIGURACIÓN";
            break;
            
        case kLanguagePortuguese:
            return @"CONFIGURAÇÃO";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}

-(NSString*) getMainMenuLeaderboardsString 
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"LEADERBOARDS";
            break;
            
        case kLanguageSpanish:
            return @"CLASIFICACIONES";
            break;
            
        case kLanguagePortuguese:
            return @"RANKING";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}

-(NSString*) getMainMenuEasyString 
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"EASY";
            break;
            
        case kLanguageSpanish:
            return @"FÁCIL";
            break;
            
        case kLanguagePortuguese:
            return @"FÁCIL";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}

-(NSString*) getMainMenuMediumString 
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"MEDIUM";
            break;
            
        case kLanguageSpanish:
            return @"MEDIO";
            break;
            
        case kLanguagePortuguese:
            return @"MÉDIO";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}


-(NSString*) getMainMenuHardString 
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"HARD";
            break;
            
        case kLanguageSpanish:
            return @"DIFÍCIL";
            break;
            
        case kLanguagePortuguese:
            return @"DIFÍCIL";
            break;
            
        default:
            break;
    }
    return @"<ERROR>";
}

-(NSString*) getMainMenuStartString
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"START";
            break;
            
        case kLanguageSpanish:
            return @"INICIO";
            break;
            
        case kLanguagePortuguese:
            return @"INICIAR";
            break;
            
        default:
            break;
    }
    return @"<ERROR>"; 
}

-(NSString*) getMainMenuChangeLanguages
{
    switch (currentLanguage) {
        case kLanguageEnglish:
            return @"CHANGE LANGUAGE";
            break;
            
        case kLanguageSpanish:
            return @"CAMBIAR EL IDIOMA";
            break;
            
        case kLanguagePortuguese:
            return @"MUDAR O IDIOMA";
            break;
            
        default:
            break;
    }
    return @"<ERROR>"; 
}
 */


-(NSString*) getScrabbleAlphabet
{
    // from http://en.wikipedia.org/wiki/Scrabble_letter_distributions
    
    return [self getLocalizedStringFor:@"scrabble alphabet"];
    
//    switch (currentLanguage) {
//        case kLanguageEnglish:
//            return [NSString stringWithUTF8String:"eeeeeeeeeeeeaaaaaaaaaiiiiiiiiioooooooonnnnnnrrrrrrttttttllllssssuuuuddddgggbbccmmppffhhvvwwyykjxqz"];
//            break;
//            
//        case kLanguageSpanish:
//            return [NSString stringWithUTF8String:"aaaaaaaaaaaaeeeeeeeeeeeeoooooooooiiiiiissssssnnnnnllllrrrrruuuuuttttdddddggccccbbmmpphhfvychqjllñrrxz"];
//            break;
//            
//        case kLanguagePortuguese:
//            return @"aaaaaaaaaaaaaaeeeeeeeeeeeiiiiiiiiiioooooooooossssssssuuuuuuummmmmmrrrrrrtttttdddddlllllccccppppnnnnbbbççffgghhvvjjqxz";            
//            break;
//            
//        default:
//            break;
//    }
//    return @"<ERROR>";    
}


-(void) dealloc
{
    [languageDictionary release];
    languageDictionary = nil;

    [super dealloc];
}

@end
