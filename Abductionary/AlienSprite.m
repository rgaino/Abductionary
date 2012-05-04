//
//  Alien.m
//  Abductionary
//
//  Created by Rafael Gaino on 5/31/11.
//  Copyright 2011 DOJO. All rights reserved.
//

#import "AlienSprite.h"
#import "cocos2d.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "Dictionary.h"

@implementation AlienSprite

-(void) alienSpriteForScene:(CCLayer*) scene
{
    _scene = scene;
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"AlienWalking.pvr.ccz"];
    [_scene addChild:spriteSheet z:18];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"AlienWalking.plist"];

    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0005.png"];
    _alienSprite = [CCSprite spriteWithSpriteFrame:frame];
    [spriteSheet addChild:_alienSprite z:19];
    
    for(int i=1; i<=kNumberOfAlienVoices; i++)
    {
        NSString *soundFileName = [NSString stringWithFormat:kSoundAlienVoice, i];
        [[SimpleAudioEngine sharedEngine] preloadEffect:soundFileName];
    }
    
    humanWordLabel = nil;
    return;
}

-(CCSprite*) alienSprite 
{
    return _alienSprite;
}

-(id) walkAction
{
    NSMutableArray *walkAnimFrames = [NSMutableArray array];

    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0005.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0006.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0007.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0008.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0009.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0010.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0011.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0012.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0011.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0010.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0009.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0008.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0007.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0006.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0005.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0004.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0003.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0002.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0001.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0002.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0003.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0004.png"]];
    [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0005.png"]];
    
    CCAnimation *walkAnimation = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.02f];

    id walkAction = [CCRepeatForever actionWithAction:
                   [CCAnimate actionWithAnimation:walkAnimation]];
    
    [walkAction setTag:alienWalkAnimationTag];

    return walkAction;
}


-(void) blinkAnimation
{
    NSMutableArray *blinkAnimFrames = [NSMutableArray array];
    
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0001.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0003.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0005.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0007.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0009.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0010.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0009.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0007.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0005.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0003.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_blink0001.png"]];
    [blinkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0005.png"]];
    
    CCAnimation *blinkAnimation = [CCAnimation animationWithSpriteFrames:blinkAnimFrames delay:0.02f];
    
    id blinkAction = [CCAnimate actionWithAnimation:blinkAnimation];
    
    [_alienSprite runAction:blinkAction];
}

-(void) stanceAnimation
{
    NSMutableArray *stanceAnimFrames = [NSMutableArray array];
    
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0001.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0002.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0003.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0004.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0005.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0006.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0007.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0008.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0009.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0010.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0011.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0012.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0013.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0014.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0015.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0016.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0017.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0018.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0019.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0020.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0021.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0022.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0023.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0022.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0021.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0020.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0019.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0018.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0017.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0016.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0015.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0014.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0013.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0012.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0011.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0010.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0009.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0008.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0007.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0006.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0005.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0004.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0003.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0002.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_stance_noblink0001.png"]];
    [stanceAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"alien_walk0005.png"]];

    CCAnimation *stanceAnimation = [CCAnimation animationWithSpriteFrames:stanceAnimFrames delay:0.02f];
    
    id stanceAction = [CCAnimate actionWithAnimation:stanceAnimation];
    
    [_alienSprite runAction:stanceAction];
}


-(void) startWalkAnimation
{    
    if(hasSpeechBubble)
    {
        [self removeSpeechBubble];
    }
    
    [_alienSprite runAction:[self walkAction]];
}


-(void) stopWalkAnimation
{
    [_alienSprite stopActionByTag:alienWalkAnimationTag];
    [self blinkAnimation];
    
    
}


-(void) showSpeechBubble:(NSString*) speechBubbleSpriteFrameName withText:(NSString*) text
{    
    if(hasSpeechBubble) 
    { 
//        NSLog(@"hasSpeechBubble, cancel new speech bubble"); 
        return; 
    }
    if(isShowingStreakSpeechBubble) { 
//        NSLog(@"isShowingStreakSpeechBubble, cancel new speech bubble"); 
        return; 
    }
    if([_alienSprite numberOfRunningActions]>0) { 
//        NSLog(@"numberOfRunningActions>0, cancel new speech bubble"); 
        return; 
    }
    if( text != nil && [[Dictionary getInstance] isProfanity:text] ) { 
//        NSLog(@"%@ isProfanity, cancel new speech bubble", text); 
        return; 
    }
    
    hasSpeechBubble = YES;
    
//    NSLog(@"Showing alien speech bubble: %@", speechBubbleSpriteFrameName);
    
    CGPoint position = _alienSprite.position;
    position.x += 45;
    position.y -= 50;
    
    speechBubbleSprite = [CCSprite spriteWithSpriteFrameName:speechBubbleSpriteFrameName];
    [speechBubbleSprite setAnchorPoint:ccp(0,0)];
    [speechBubbleSprite setPosition:position];
    [_alienSprite.parent addChild:speechBubbleSprite z:20];
    
    
    if(text != nil)
    {
//        NSLog(@"Speech buble spelled word: %@", text);
        position = _alienSprite.position;
        position.x += 120;
        position.y += 10;
        

        humanWordLabel = [CCLabelTTF labelWithString:text dimensions:CGSizeMake(147, 50) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:25];
        [humanWordLabel setPosition:position];
        [_scene addChild:humanWordLabel z:21];

    }
    
    [self playRandomAlienVoiceSound];

    [self performSelector:@selector(removeSpeechBubble) withObject:nil afterDelay:kSpeechBubbleDuration];
}

-(void) showRandomSpeechBubble
{    
    int chance = arc4random() % 100;
    
    if(chance < 50) 
    {
//        NSLog(@"will showSpelledWordSpeechBubble");
        [self showSpelledWordSpeechBubble];
    } else
    {
//        NSLog(@"will showAlienSpeechBubble");

        int randomBubbleChance = arc4random() % 7;

        NSString *filename = [NSString stringWithFormat:@"speechBubble_%d.png", (randomBubbleChance+1)];
        [self showSpeechBubble:filename withText:nil];
    }
}

-(void) showSpelledWordSpeechBubble
{
    int spelledWordsCount = [[[Dictionary getInstance] spelledWords] count];
    
//    NSLog(@"Spelled words count is %d", spelledWordsCount);
    
    if(spelledWordsCount > 0)
    {
        NSArray *markCharacters = [NSArray arrayWithObjects:@"!", @"?", @"", nil];
        int index = arc4random() % [markCharacters count];
        
        int randomSpelledWordIndex = arc4random() % spelledWordsCount;
        NSString *randomSpelledWord = [[[[Dictionary getInstance] spelledWords] objectAtIndex:randomSpelledWordIndex] uppercaseString];
        
        NSString *wordBubble = [NSString stringWithFormat:@"%@%@", randomSpelledWord, [markCharacters objectAtIndex:index]];
        
        [self showSpeechBubble:@"speechBubble_blank.png" withText:wordBubble];
    }
}

-(void) showHappySpeechBubble
{
    [self showSpeechBubble:@"speechBubble_happy.png" withText:nil];
}

-(void) showAngrySpeechBubble
{
    [self showSpeechBubble:@"speechBubble_angry.png" withText:nil];
}


-(void) showStreakSpeechBubble
{
//    NSLog(@"About to showStreakSpeechBubble at %@", [NSDate date]);
 
    if([_alienSprite numberOfRunningActions] > 0 ) 
    {
        [_alienSprite stopAllActions];
    }
    
    if( hasSpeechBubble )
    {
        [self removeSpeechBubble];
    }
    
    isShowingStreakSpeechBubble = YES;
    
    CGPoint position = _alienSprite.position;
    position.x += 40;
    position.y -= 50;

    speechBubbleSprite = [CCSprite spriteWithSpriteFrameName:@"streakPowerUp_05.png"];
    [speechBubbleSprite setAnchorPoint:ccp(0,0)];
    [speechBubbleSprite setPosition:position];
    [_alienSprite.parent addChild:speechBubbleSprite z:20];
    
    NSMutableArray *streakAnimFrames = [NSMutableArray array];
    
    [streakAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"streakPowerUp_05.png"]];
    [streakAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"streakPowerUp_04.png"]];
    [streakAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"streakPowerUp_03.png"]];
    [streakAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"streakPowerUp_02.png"]];
    [streakAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"streakPowerUp_01.png"]];
    [streakAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"streakPowerUpFinished.png"]];

    CCAnimation *streakAnimation = [CCAnimation animationWithSpriteFrames:streakAnimFrames delay:3.0f];
   
    id streakAction = [CCAnimate actionWithAnimation:streakAnimation];
    id hideAction = [CCCallFunc actionWithTarget:self selector:@selector(hideStreakSpeechBubble)];
    id sequence = [CCSequence actionOne:streakAction two:hideAction];
    
    [speechBubbleSprite runAction:sequence];
}

-(void) hideStreakSpeechBubble
{
//    NSLog(@"About to hideStreakSpeechBubble at %@", [NSDate date]);

    isShowingStreakSpeechBubble = NO;
    [speechBubbleSprite removeFromParentAndCleanup:YES];
    speechBubbleSprite = nil;
}


-(void) removeSpeechBubble
{
    hasSpeechBubble = NO;

    if(speechBubbleSprite == nil) { return; }
    if(isShowingStreakSpeechBubble) { return; }
    
    [speechBubbleSprite removeFromParentAndCleanup:YES];
    speechBubbleSprite = nil;
    
    if( humanWordLabel != nil)
    {
//        NSLog(@"About to remove humanWordLabel");
        [humanWordLabel removeFromParentAndCleanup:YES];
        humanWordLabel = nil;
    }
}

-(void) playAlienVoiceSoundNumber:(int) voiceNumber
{
    NSString *soundFileName = [NSString stringWithFormat:kSoundAlienVoice, voiceNumber];
    [[SimpleAudioEngine sharedEngine] playEffect:soundFileName];
}

-(void) playRandomAlienVoiceSound
{
    int voiceSound = arc4random() % 8;
    voiceSound++;
    [self playAlienVoiceSoundNumber:voiceSound];
}

-(BOOL) isShowingStreakSpeechBubble
{
    return isShowingStreakSpeechBubble;
}

-(void) dealloc
{
    NSLog(@"On dealloc for alienSprite");
    [super dealloc];
}

@end
