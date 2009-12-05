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
	[formatter setDateFormat: @"_d_M_Y"];
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
	
	//NSLog(@"trying %@",filename);

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
- (void) loadChart
{
	
	
	
	NSDate	*today = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	//								   initWithDateFormat:@"_%1d_%1m_%Y" allowNaturalLanguage:NO] autorelease];
	[formatter setDateFormat: @"_d_M_Y"];	
	
	NSString *filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	
	filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
	
//	NSLog(@"fname %@",filename);
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename])
	{
		//NSLog(@"file exists. let's load it!");
		//[chartImageView setImage:[UIImage imageWithContentsOfFile:filename]];
		
	//	NSLog(@"the final filename: %@",filename);
		
		NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
		//NSLog(@"%@",s);
		
		[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
		
		
		return;
	}
	
	
	[[Reachability sharedReachability] setHostName:@"ichart.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
	
	if (internetConnectionStatus == NotReachable)
	{	
	//	NSLog(@"not reachable. let's get cache");
		
		NSString *filename = getLastCachedImageFilenameForObject(objectToShowHistory, 0);
	//	NSLog(@"cache file: %@",filename);
		if (filename && ![filename isEqualToString:[NSString string]])
		{	
			NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
			[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
			return;
		}
		else
		{	
			NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><h2>You're offline!<p>There was also<p> no cached chart found!<p> Please connect<p>to the internet!</h2></center></body></html>",filename];
			[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];

			return;
		}
		
		return;
	}
	else
	{
		UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ichart.finance.yahoo.com/3m?%@%@=x",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]]]];
		//NSLog(@"file doesn't exist. let's save it!");
		NSData *d = UIImagePNGRepresentation(img);
		
		
		NSDate *today = [NSDate date];
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		//									   initWithDateFormat:@"_%1d_%1m_%Y" allowNaturalLanguage:NO] autorelease];
		[formatter setDateFormat: @"_d_M_Y"];
		filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: today]];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
		
		//NSLog(@"saving as %@",filename);
		[d writeToFile:filename atomically: NO];
		
		//[chartImageView setImage: img];
		//[img release];
		
		//delete old image
		
		/*		NSTimeInterval secondsPerDay = 24 * 60 * 60;
		 NSDate *yesterday = [NSDate
		 dateWithTimeIntervalSinceNow:-secondsPerDay];
		 
		 
		 filename = [NSString stringWithFormat:@"%@_%@%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode],[formatter stringFromDate: yesterday]];
		 filename = [NSString stringWithFormat:@"%@/%@.png",documentsDirectory,filename];
		 
		 NSLog(@"trying to delete %@",filename);
		 
		 [[NSFileManager defaultManager] removeItemAtPath: filename error: NULL];*/
	}
	
	//NSLog(@"the final filename: %@",filename);
	
	NSString *s = [NSString stringWithFormat:@"<html><head></head><body style='background-color: transparent; color: white;'><p><center><img src='%@' width=94%%></center></body></html>",filename];
	//NSLog(@"%@",s);
	
	[chartImageView loadHTMLString:s baseURL: [NSURL URLWithString: @"file:///"]];
	
	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[[self navigationItem] setRightBarButtonItem:[self backButton] animated: NO];
	
	[chartImageView setOpaque: NO];
	[chartImageView setBackgroundColor: [UIColor clearColor]];
	[chartImageView setAlpha: 1.0f];
	[chartImageView setScalesPageToFit: YES];
	[chartImageView setDetectsPhoneNumbers: NO];
	[self loadChart];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);

//	NSLog(@"tttttrotate?");
	return YES;
}

- (void) handleOrientationDidChange: (NSNotification *) notification
{
	

	//NSLog(@"%f,%f,%f,%f",[[self view] frame].origin.x,[[self view] frame].origin.y,[[self view] frame].size.width,[[self view] frame].size.height);
	
	
	/*if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		CGRect r = [chartImageView frame];
		[chartImageView setFrame: CGRectMake(r.origin.x,r.origin.y,320.0f,416.0f)];
		[chartImageView setScalesPageToFit: YES];
		[chartImageView reload];
		[chartImageView setNeedsDisplay];
		NSLog(@"omfg changed!");

	}*/
	//[self loadChart];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handleOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
	
	[[self view] setNeedsDisplay];
	//rotate >.< if device rotated ...
	//apple should do this for us!
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		
	
		NSLog(@"will appear! %i", [[UIDevice currentDevice] orientation]);
		//[[UIDevice currentDevice] setOrientation: 4];
		//CGRect r = [[[self view] superview] frame];
		[[self view] setFrame: CGRectMake(0, 0, 480, 320)];
		[[self view] setNeedsDisplay];
	
		//r = [chartImageView frame];
		
		//[chartImageView setFrame: CGRectMake(r.origin.x,r.origin.y,480,240)];
		
		//NSLog(@"%f,%f,%f,%f",r.origin.x,r.origin.y,r.size.width,r.size.height);
	}

	//NSLog(@"%@",[NSString stringWithFormat:@"Chart: %@/%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]);
	[self setTitle: [NSString stringWithFormat:@"Chart: %@/%@",[objectToShowHistory fromCurrencyCode],[objectToShowHistory toCurrencyCode]]];
	

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
//	NSLog(@"dealloc!");
    [super dealloc];
}

- (IBAction) goBack: (id) sender
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver: self];
	
	//CGRect r = [[self view] frame];
	
//	NSLog(@"%f,%f,%f,%f",r.origin.x,r.origin.y,r.size.width,r.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView: [[self view] superview] cache:YES];
	
	//[[self view] setTransform: CGAffineTransformMakeTranslation(320,0)];
	//[callingView setTransform: CGAffineTransformMakeTranslation(0,0)];
	[UIView commitAnimations];

	[[self view] removeFromSuperview];
	
	[self release];
	
}


@end
