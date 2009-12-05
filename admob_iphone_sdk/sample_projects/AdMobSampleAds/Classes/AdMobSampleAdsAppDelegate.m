//
//  AdMobSampleAdsAppDelegate.m
//  AdMobSampleAds
//
//  Created by Michael Ying on 6/2/09.
//  Copyright AdMob, Inc. 2009. All rights reserved.
//

#import "AdMobSampleAdsAppDelegate.h"
#import "RootViewController.h"


@implementation AdMobSampleAdsAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
  
  
#ifdef __IPHONE_3_0
  UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                       message:@"When you are using the iPhone 3.0 SDK, please use the AdMob 3.0 libraries in the extras directory" 
                                                      delegate:nil 
                                             cancelButtonTitle:nil 
                                             otherButtonTitles:@"OK", nil] autorelease];
  [alertView show];
#endif
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

