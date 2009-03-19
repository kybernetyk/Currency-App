//
//  MainViewController.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainViewController.h"
#import "RootViewController.h"
#import "MainView.h"

@implementation MainViewController
@synthesize rootController;

- (IBAction) toggleInfoView: (id) sender
{
	NSLog(@"toggle! %@",rootController);
	
	[rootController toggleView: sender];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
	}
	return self;
}



//If you need to do additional setup after loading the view, override viewDidLoad.
 - (void)viewDidLoad {
	 MainView *m = (MainView *)[self view];
	 [m didLoad];
	 [m release];
	// [m release];
	 //[m release];
	 
	 //NSLog(@"Main View retaincount: %i",[[self view] retainCount]);
 }



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	//NSLog(@"*****************************************");
	//NSLog(@"MainViewController dealloc!");
	//NSLog(@"Main View retaincount: %i",[[self view] retainCount]);
	//NSLog(@"*****************************************");

	[[self view] release];
	[super dealloc];

}


@end
