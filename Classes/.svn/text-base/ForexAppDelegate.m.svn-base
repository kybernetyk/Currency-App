//
//  ForexAppDelegate.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "ForexAppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "MainView.h"

@implementation ForexAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[window addSubview:[rootViewController view]];
//	[application setStatusBarHidden:YES animated:YES];
	[window makeKeyAndVisible];
	//NSLog(@"Root View Controller retain count: %i",[rootViewController retainCount]);
	
	
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	//NSLog(@"Will terminate!");
	MainViewController *mvc = [rootViewController mainViewController];
	MainView *mv = (MainView *)[mvc view];
	
	[mv saveCalcList];
	[mv release];
	
	[rootViewController release];

	//	[self release];
	//verursach absturz oO ^^
}

- (void)dealloc 
{
	//NSLog(@"*****************************************");
	//NSLog(@"App Delegate dealloc!");
	//NSLog(@"Root View Controller retaincount: %i",[rootViewController retainCount]);
	//NSLog(@"*****************************************");
	
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
