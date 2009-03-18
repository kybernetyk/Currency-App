//
//  DetailViewController.m
//  Currency
//
//  Created by jrk on 17.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "DetailViewController.h"
#import "Reachability.h"

@implementation DetailViewController
@synthesize objectToShowHistory;
@synthesize callingView;
@synthesize backButton;
@synthesize chartImageView;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

NSString *getLastCachedImageFilenameForObject (ForexDataObject *objectToShowHistory, NSTimeInterval intvl)
{

	
	
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:-intvl];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat: @"_d_m_Y"];
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
	
	NSLog(@"trying %@",filename);

	//[formatter release];
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
		return filename;
	else
	{	
		intvl += secondsPerDay;
		
		if (intvl > 24*60*60*5)
			return [NSString string];
		
		return getLastCachedImageFilenameForObject(objectToShowHistory,intvl);
		
	}
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[[self navigationItem] setRightBarButtonItem:[self backButton] animated: NO];
	
	NSDate	*today = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//								   initWithDateFormat:@"_%1d_%1m_%Y" allowNaturalLanguage:NO] autorelease];
	[formatter setDateFormat: @"_d_m_Y"];	

	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
	
	NSLog(@"fname %@",filename);
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
	{
		NSLog(@"file exists. let's load it!");
		[chartImageView setImage:[UIImage imageWithContentsOfFile:filename]];
		
		return;
	}

	
	[[Reachability sharedReachability] setHostName:@"ichart.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
	
	if (internetConnectionStatus == NotReachable)
	{	
		NSLog(@"not reachable. let's get cache");
		
		NSString *filename = getLastCachedImageFilenameForObject(objectToShowHistory, 0);
		NSLog(@"cache file: %@",filename);
		if (filename && ![filename isEqualToString:[NSString string]])
			[chartImageView setImage:[UIImage imageWithContentsOfFile:filename]];			
		else
			[chartImageView setImage: [UIImage imageNamed:@"offline.png"]];
	}
	else
	{
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ichart.finance.yahoo.com/3m?%@%@=x",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]]]];
		NSLog(@"file doesn't exist. let's save it!");
		NSData *d = UIImagePNGRepresentation(img);
		
		
		NSDate *today = [NSDate date];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//									   initWithDateFormat:@"_%1d_%1m_%Y" allowNaturalLanguage:NO] autorelease];
		[formatter setDateFormat: @"_d_m_Y"];
		filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
		
		NSLog(@"saving as %@",filename);
		[d writeToFile:filename atomically: NO];
		
		[chartImageView setImage: img];

		//delete old image
		
/*		NSTimeInterval secondsPerDay = 24 * 60 * 60;
		NSDate *yesterday = [NSDate
							 dateWithTimeIntervalSinceNow:-secondsPerDay];

		
		filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: yesterday]];
		filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
		
		NSLog(@"trying to delete %@",filename);
		
		[[NSFileManager defaultManager] removeItemAtPath: filename error: NULL];*/
	}
		

	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);

	NSLog(@"tttttrotate?");
	return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
	[[self view] setNeedsDisplay];
	//rotate >.< if device rotated ...
	//apple should do this for us!
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		NSLog(@"will appear! %i", [[UIDevice currentDevice] orientation]);
		//[[UIDevice currentDevice] setOrientation: 4];
		CGRect r = [[self view] frame];
		[[self view] setFrame: CGRectMake(r.origin.x, r.origin.y, 480, 320)];
	//	[[self view] setNeedsDisplay];
	
		NSLog(@"%f,%f,%f,%f",r.origin.x,r.origin.y,r.size.width,r.size.height);
	}

	NSLog(@"%@",[NSString stringWithFormat:@"Chart: %@/%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]);
	[self setTitle: [NSString stringWithFormat:@"Chart: %@/%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]];
	

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	NSLog(@"dealloc!");
    [super dealloc];
}

- (IBAction) goBack: (id) sender
{
	CGRect r = [[self view] frame];
	
	NSLog(@"%f,%f,%f,%f",r.origin.x,r.origin.y,r.size.width,r.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: [[self view] superview] cache:YES];
	
	//[[self view] setTransform: CGAffineTransformMakeTranslation(320,0)];
	//[callingView setTransform: CGAffineTransformMakeTranslation(0,0)];
	[UIView commitAnimations];

	[[self view] removeFromSuperview];
	
	[self release];
	
}


@end
