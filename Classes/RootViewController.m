//
//  RootViewController.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "MainView.h"


@implementation RootViewController

@synthesize infoButton;
@synthesize flipsideNavigationBar;
@synthesize mainViewController;
@synthesize flipsideViewController;


- (void)viewDidLoad {
	whichViewActive = 0;
	
	UIApplication *app = [UIApplication sharedApplication];
	[app setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//	[app setNetworkActivityIndicatorVisible: YES];

	
	MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = viewController;
	[viewController release];
	
	//NSLog(@"Main View Controller retain count: %i",[mainViewController retainCount]);
	
	[self.view insertSubview:mainViewController.view belowSubview:infoButton];

	
	//MainView *m = [[self mainViewController] view];
	
//	[m setAddButton: infoButton];
//	[infoButton setHidden: YES];
}


- (void)loadFlipsideViewController {
	
	FlipsideViewController *viewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	self.flipsideViewController = viewController;
	[viewController release];
	
	// Set up the navigation bar
	UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	[aNavigationBar setAutoresizingMask: UIViewAutoresizingFlexibleWidth];
	aNavigationBar.barStyle = UIBarStyleBlackOpaque;
	self.flipsideNavigationBar = aNavigationBar;

	
	
	[aNavigationBar release];
	
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView:)];
	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Currency.app"];
	navigationItem.rightBarButtonItem = buttonItem;
	[flipsideNavigationBar pushNavigationItem:navigationItem animated:NO];
	[navigationItem release];
	[buttonItem release];
}



- (IBAction)toggleView: (id) sender;
{	
	//if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	//	return;
		
//	MainView *m = [[self mainViewController] view];
//	[m addCellToTableView: self];
	
	//MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"AddView" bundle:nil];
	//self.mainViewController = viewController;
	//[viewController release];
	
	
	
	
//	return;
	/*
	 This method is called when the info or Done button is pressed.
	 It flips the displayed view from the main view to the flipside view and vice-versa.
	 */
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}
	
	UIView *mainView = mainViewController.view;
	//[mainView retain];
	
	UIView *flipsideView = flipsideViewController.view;
	
	
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		CGRect r = [flipsideView frame];
		[flipsideView setFrame: CGRectMake(r.origin.x, r.origin.y, 480, 320)];
		[self.flipsideNavigationBar setFrame: CGRectMake(0.0, 0.0, 480.0, 44.0)];
	}
	else
	{
		CGRect r = [flipsideView frame];
		[flipsideView setFrame: CGRectMake(r.origin.x, r.origin.y, 320, 480)];
		[self.flipsideNavigationBar setFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
	}
	
	
	
	//NSLog(@"************************************************");
	//NSLog(@"toggling views");
	//NSLog(@"main view retain count: %i",[mainView retainCount]);
	//NSLog(@"flip view retain count: %i",[flipsideView retainCount]);
	//NSLog(@"************************************************");
		  
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:(whichViewActive ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if (whichViewActive == 0)
	{
		
		[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		//[mainView retain];
	//	[flipsideView release];
		//[mainView removeFromSuperview];
        [infoButton removeFromSuperview];
		[self.view addSubview:flipsideView];
		[self.view insertSubview:flipsideNavigationBar aboveSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];
		whichViewActive = 1;

	} else {
		//[mainView release];
		//[flipsideView retain];

		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[flipsideNavigationBar removeFromSuperview];
		//[self.view addSubview:mainView];
		[self.view insertSubview:infoButton aboveSubview:mainViewController.view];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
		whichViewActive = 0;
	}
	[UIView commitAnimations];
	
	//NSLog(@"************************************************");
	//NSLog(@"toggling done");
	//NSLog(@"main view retain count: %i",[mainView retainCount]);
	//NSLog(@"flip view retain count: %i",[flipsideView retainCount]);
	//NSLog(@"************************************************");
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	NSLog(@"rotate?");

	return YES;
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
	//NSLog(@"*****************************************");
	//NSLog(@"RootViewController dealloc!");
	//NSLog(@"infoButton retainCount: %i",[infoButton retainCount]);
	//NSLog(@"flipsideNavigationBar retainCount: %i",[flipsideNavigationBar retainCount]);
	//NSLog(@"mainViewController retainCount: %i",[mainViewController retainCount]);
	//NSLog(@"flipsideViewController retainCount: %i",[flipsideViewController retainCount]);
	//NSLog(@"*****************************************");
	
	
	
	[infoButton release];
	[flipsideNavigationBar release];
	[mainViewController release];
	[flipsideViewController release];
	[super dealloc];
}


@end
