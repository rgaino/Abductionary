//
//  IntroScene.m
//  Abductionary
//
//  Created by Rafael Gaino on 2/2/12.
//  Copyright 2012 DOJO. All rights reserved.
//

#import "IntroScene.h"
#import "LoadingScene.h"
#import "MainMenuScene.h"
#import "I18nManager.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation IntroScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroScene *layer = [IntroScene node];
	[scene addChild:layer];	
	return scene;
}

-(id) init
{
	if( (self=[super init])) 
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"abductionary" ofType:@"mov"];
        NSURL *url = [NSURL fileURLWithPath:path];
        MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackFinished)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        
        
        if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
            moviePlayer.controlStyle = MPMovieControlStyleNone;
            moviePlayer.shouldAutoplay = YES;
            moviePlayer.repeatMode = MPMovieRepeatModeOne;
            CGRect win = [[UIScreen mainScreen] bounds];
            
            float width = 825;
            float height = 480;
            float xPosition = (win.size.height -  width) / 2; 
            float yPosition = (win.size.width -  height) / 2; 
            
            
//            moviePlayer.view.frame = CGRectMake(0, 0, win.size.height, win.size.width);
              moviePlayer.view.frame = CGRectMake(xPosition, yPosition, width, height);
            
            [[[CCDirector sharedDirector] view] addSubview:moviePlayer.view];
            [[[CCDirector sharedDirector] view] sendSubviewToBack:moviePlayer.view];
            
//            [viewController.view  addSubview:moviePlayer.view];
//            [viewController.view  sendSubviewToBack:moviePlayer.view];        
        } else {
//            moviePlayer.movieControlMode = MPMovieControlModeHidden;
//            [moviePlayer play];
        }	
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];


        

//        [CCVideoPlayer setDelegate: self]; 
//        [CCVideoPlayer playMovieWithFile: @"abductionary.mov"];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        subtitleLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(winSize.width, 100) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:25];
        [subtitleLabel setPosition:ccp(winSize.width/2,50)];
        [self addChild:subtitleLabel z:2];

        
        
        [self scheduleAllSubtitles];
    }
        
	return self;
}

- (void) moviePlaybackFinished
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

- (void) movieStartsPlaying
{
//    [[CCDirector sharedDirector] stopAnimation];
}

-(void) scheduleAllSubtitles
{
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_01" afterDelay:12.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_02" afterDelay:15.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_03" afterDelay:23.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_04" afterDelay:26.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_05" afterDelay:28.0f];
}

-(void) displaySubtitleWithKey:(NSString*) subtitleKey 
{
    NSString *subtitleText = [[I18nManager getInstance] getLocalizedStringFor:subtitleKey];
    
    NSLog(@"Displaying subtitle for key %@: %@", subtitleKey, subtitleText);
    
    [subtitleLabel setString:subtitleText];
}


-(void) dealloc
{
    [CCVideoPlayer setDelegate:nil];
    [super dealloc];
}


@end
