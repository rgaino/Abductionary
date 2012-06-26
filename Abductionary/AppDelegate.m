//
//  AppDelegate.m
//  Abductionary
//
//  Created by Rafael Gaino on 3/19/12.
//  Copyright DOJO 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroScene.h"
#import "LoadingScene.h"
#import "GameScene.h"
#import "CDAudioManager.h"
#import "PlaytomicManager.h"
#import "GameCenterManager.h"
#import "IntroAnimationScene.h"
#import "I18nScene.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;
@synthesize playerScore, failCounterValue, powerUpValue, currentGameMode;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGBA8   //kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
    [glView setOpaque:NO];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// set the Navigation Controller as the root view controller
//	[window_ setRootViewController:rootViewController_];
	[window_ addSubview:navController_.view];

	// make main window visible
	[window_ makeKeyAndVisible];

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// When in iPhone RetinaDisplay, iPad, iPad RetinaDisplay mode, CCFileUtils will append the "-hd", "-ipad", "-ipadhd" to all loaded files
	// If the -hd, -ipad, -ipadhd files are not found, it will load the non-suffixed version
//	[CCFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
//	[CCFileUtils setiPadSuffix:@""];					// Default on iPad is "" (empty string)
//	[CCFileUtils setiPadRetinaDisplaySuffix:@"-hd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

    
    //////////////////////////////////////////
    /////// CUSTOM ABDUCTIONARY CODE /////////
    //////////////////////////////////////////
    
    //setting up user defaults
    NSMutableDictionary *userDefaultsDefaults = [[NSMutableDictionary alloc] init];
    
    [userDefaultsDefaults setValue:[NSNumber numberWithFloat:1.0f] forKey:kUserDefaultsBackgroundMusicGain];
    [userDefaultsDefaults setValue:[NSNumber numberWithFloat:1.0f] forKey:kUserDefaultsSFXGain];
    [userDefaultsDefaults setValue:[NSNumber numberWithBool:NO] forKey:kSkipTutorials];
    
    for(int i=1; i <= kNumberOfTutorials; i++)
    {
        NSString *tutorialKey = [NSString stringWithFormat:kTutorialDefaultsString, i];
        [userDefaultsDefaults setValue:[NSNumber numberWithBool:NO] forKey:tutorialKey];
    }
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [userDefaultsDefaults release];
    
    
    //Set Denshion's mode so user can listen to iPod music while playing
    [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
	[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];

    
    //Authenticate player on GameCenter
    [[GameCenterManager getInstance] authenticateLocalPlayer];

    //log view on Playtomic
    [[PlaytomicManager getInstance] logView];

    //Reading default language (if none, push language selection screen)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userLanguage = [userDefaults stringForKey:kUserDefaultsLanguage];
    NSLog(@"user language is %@",userLanguage);

    if(userLanguage == nil) 
    {
        [director_ pushScene: [I18nScene scene]]; 
    } else {
        [director_ pushScene: [IntroScene scene]]; 
    }    

//	[director_ pushScene: [IntroScene scene]]; 
//	[director_ pushScene: [IntroAnimationScene scene]]; 
//	[director_ pushScene: [LoadingScene scene]]; 
//	[director_ pushScene: [GameScene scene]]; 
//	[director_ pushScene: [MainMenuScene scene]]; 

    //////////////////////////////////////////
    ///// END CUSTOM ABDUCTIONARY CODE ///////
    //////////////////////////////////////////
    

	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    [[PlaytomicManager getInstance] freeze];

	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [[PlaytomicManager getInstance] unfreeze];

	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end
