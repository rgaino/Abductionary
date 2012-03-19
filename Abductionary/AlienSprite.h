//
//  AlienSprite.h
//  Abductionary
//
//  Created by Rafael Gaino on 5/31/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSprite;
@class CCLayer;
@class CCLabelTTF;
@class CCLayer;

typedef enum
{
    alienWalkAnimationTag
} alienSpriteAnimationTags;


@interface AlienSprite : NSObject 
{
    CCSprite *_alienSprite;
    BOOL hasSpeechBubble;
    BOOL isShowingStreakSpeechBubble;
    CCSprite *speechBubbleSprite;
    CCLayer *_scene;
    CCLabelTTF *humanWordLabel; 
}

-(void) alienSpriteForScene:(CCLayer*) scene;
-(CCSprite*) alienSprite;
-(void) startWalkAnimation;
-(void) stopWalkAnimation;
-(id) walkAction;
-(void) blinkAnimation;
-(void) stanceAnimation;
-(void) showSpeechBubble:(NSString*) speechBubbleSpriteFrameName withText:(NSString*) text;
-(void) showRandomSpeechBubble;
-(void) showHappySpeechBubble;
-(void) showAngrySpeechBubble;
-(void) removeSpeechBubble;
-(void) playAlienVoiceSoundNumber:(int) voiceNumber;
-(void) playRandomAlienVoiceSound;
-(void) showStreakSpeechBubble;
-(void) hideStreakSpeechBubble;
-(BOOL) isShowingStreakSpeechBubble;
-(void) showSpelledWordSpeechBubble;

@end
