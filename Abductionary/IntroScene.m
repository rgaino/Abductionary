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
        [self setIsTouchEnabled:YES];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"abductionary" ofType:@"mov"];
        NSURL *url = [NSURL fileURLWithPath:path];
        moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackFinished)     name:MPMoviePlayerPlaybackDidFinishNotification  object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieReadyToPlayCallback:) name:MPMoviePlayerLoadStateDidChangeNotification object:moviePlayer];

        
        
        if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
            moviePlayer.controlStyle = MPMovieControlStyleNone;
//            moviePlayer.shouldAutoplay = YES;
            moviePlayer.repeatMode = MPMovieRepeatModeNone;
            CGRect win = [[UIScreen mainScreen] bounds];
            
            float width = 825;
            float height = 480;
            float xPosition = (win.size.height -  width) / 2;
            float yPosition = (win.size.width -  height) / 2; 
            
            moviePlayer.view.frame = CGRectMake(xPosition, yPosition, width, height);
            
            [[[CCDirector sharedDirector] view] addSubview:moviePlayer.view];
            [[[CCDirector sharedDirector] view] sendSubviewToBack:moviePlayer.view];
//            [viewController.view  addSubview:moviePlayer.view];
//            [viewController.view  sendSubviewToBack:moviePlayer.view];        
//        } else {
//            moviePlayer.movieControlMode = MPMovieControlModeHidden;
//            [moviePlayer play];
        }	


        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];


        
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
//        subtitleLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(winSize.width, 100) hAlignment:kCCTextAlignmentCenter fontName:kCommonFontName fontSize:25];
//        [subtitleLabel setPosition:ccp(winSize.width/2,50)];
//        [self addChild:subtitleLabel z:2];

        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, 825, 60)];
        [subtitleLabel setTextAlignment:UITextAlignmentCenter];
        [subtitleLabel setBackgroundColor:[UIColor lightGrayColor]];
        [subtitleLabel setTextColor:[UIColor whiteColor]];
        [subtitleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [subtitleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [subtitleLabel setNumberOfLines:2]; 
//        [subtitleLabel setText:@"This is the UILabel"];
        [moviePlayer.view addSubview:subtitleLabel];
        
        
    }
        
	return self;
}

-(void)movieReadyToPlayCallback:(NSNotification*)aNotification {
    
    MPMoviePlayerController *mp = [aNotification object];
    
    NSLog(@"Movie ready to play. Status %d", [mp loadState]);
    if( [mp loadState] == MPMovieLoadStatePlayable || [mp loadState] == MPMovieLoadStatePlaythroughOK ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:mp] ;
        [self scheduleAllSubtitles];
    }
    
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch detected");
    [self moviePlaybackFinished];
}

- (void) moviePlaybackFinished
{
//    [[[CCDirector sharedDirector] view] addSubview:moviePlayer.view];
    [moviePlayer.view removeFromSuperview];
    [moviePlayer release];

    NSLog(@"Movie completed");
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}



-(void) scheduleAllSubtitles
{
    
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_01" afterDelay:9.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_02" afterDelay:15.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_03" afterDelay:23.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_04" afterDelay:26.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_05" afterDelay:28.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_06" afterDelay:33.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_07" afterDelay:37.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_08" afterDelay:39.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_09" afterDelay:53.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_10" afterDelay:61.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_11" afterDelay:64.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_12" afterDelay:72.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_13" afterDelay:76.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_14" afterDelay:79.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_15" afterDelay:96.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_16" afterDelay:99.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_17" afterDelay:102.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_18" afterDelay:109.0f];
    [self performSelector:@selector(displaySubtitleWithKey:) withObject:@"Intro_subtitles_19" afterDelay:118.0f];
}

-(void) displaySubtitleWithKey:(NSString*) subtitleKey 
{
    NSString *subtitleText = [[I18nManager getInstance] getLocalizedStringFor:subtitleKey];
    
    NSLog(@"Displaying subtitle for key %@: %@", subtitleKey, subtitleText);
    
    [subtitleLabel setText:subtitleText];
}


-(void) dealloc
{
    [super dealloc];
}


@end
