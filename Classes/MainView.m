//
//  MainView.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MainView.h"
#import "ForexAppDelegate.h"
#import "ForexDataObject.h"
#import "CurrencyDataObject.h"
#import "AtomTableViewCell.h"
#import "AddCell.h"
#import "Reachability.h"
#import "DetailViewController.h"

BOOL mayRotate = YES;

@implementation MainView

@synthesize lastUpdated;
@synthesize calcList, currencyList;

- (IBAction) calc: (id) sender
{
	/*NSString *data = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://download.finance.yahoo.com/d/quotes.csv?s=PLNEUR=X&f=sl1d1t1ba&e=.csv"]];
	NSArray *arr = [data componentsSeparatedByString:@","];
	*/

	//NSString *data = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://download.finance.yahoo.com/d/quotes.csv?s=PLNEUR=X&f=l1"]];
	
	
//	[self setUmrechnungsFaktor:[[arr objectAtIndex:1] floatValue]];
	
	////NSLog(@"%.4f",[data floatValue]);
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/maps?f=q&geocode=&q=gdansk&ie=UTF8&ll=54.414934,18.38562&spn=0.327645,1.757813&t=h&z=10&iwloc=addr"]];

	
	[tableView reloadData];
	
}

- (IBAction) updateExchangeRates: (id) sender
{
//	UIApplication *app = [UIApplication sharedApplication];
//	[app setNetworkActivityIndicatorVisible:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSLog(@"testing yahoo");
	[[Reachability sharedReachability] setHostName:@"download.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];

	NSLog(@"testing flux");
	[[Reachability sharedReachability] setHostName:@"www.fluxforge.com"];
	NetworkStatus internetConnectionStatus2 = [[Reachability sharedReachability] remoteHostStatus];



	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

	
	
	if (internetConnectionStatus == NotReachable || internetConnectionStatus2 == NotReachable)
	{	
		//NSLog(@"INTERNETS NO THER!");
		//if (exchangeRate == 0.0f)
		//	[self setExchangeRate: 0.0f];
		//[lastUpdatedLabel setText: @"No Internet Connection."];
		NSString *formattedDateString = nil;
		if (lastUpdated != nil)
			formattedDateString = [dateFormatter stringFromDate:lastUpdated];
		else
			formattedDateString = @"No update yet!";
			
		[lastUpdatedLabel setText: [NSString stringWithFormat:@"[No Network] Last update: %@", formattedDateString]];
	}
	else
	{
		//NSLog(@"test");
			//NSLog(@"internet found. let's fetch uptodate currency list");
			NSURL *listUrl = [NSURL URLWithString:@"http://www.fluxforge.com/services/english_currency_list.txt"];

			NSString *theList = [NSString stringWithContentsOfURL: listUrl];
			NSArray *arr = [theList componentsSeparatedByString:@","];

//		NSLog(@"%@",theList);
		
			//was the list found on the net?
			if (theList == nil)
			{
				//NSLog(@"ooops - no currency list on the net. let's look for our cached one ...");
				BOOL bLoad = [self loadCurrencyList];
				
				if (bLoad == NO)
				{
					//NSLog(@"\terror - no currency list found :((( create minimalistic one!");
					[self createDefaultCurrencyList];
				}
				else
				{
					//NSLog(@"\tok, loaded cached currency list ...");
				}
			}
			else
			{
				//NSLog(@"\tloading currency list from fluxforge ...");
				currencyList = [[NSMutableArray alloc] init];
				
				int i = 0;
				for (i = 0; i < [arr count]; i+=2)
				{
					CurrencyDataObject *cdo = [[CurrencyDataObject alloc] init];
					[cdo setCurrencyCode: [arr objectAtIndex: i]];
					[cdo setCurrencyDescription:[arr objectAtIndex: i+1]];
					[currencyList addObject:cdo];
					[cdo release];
					//NSLog(@"\t cdo retaincount: %i",[cdo retainCount]);
				}
				[self saveCurrencyList];
			}
		[pickerView reloadAllComponents];
			
		
		for (ForexDataObject *fdo in calcList)
		{
			[fdo updateExchangeRate];	
		}
	
		[self setLastUpdated:[NSDate date]];

		NSString *formattedDateString = [dateFormatter stringFromDate:lastUpdated];
		[lastUpdatedLabel setText: [NSString stringWithFormat:@"Last update: %@", formattedDateString]];
		
		[self saveCalcList];
		[tableView reloadData];
		

	}
	//[activityIndicator stopAnimating];
	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (IBAction) toggleEdit: (id) sender
{
	//[activityIndicator stopAnimating];
	
	//vom editng nach nichtediting
	if ([tableView isEditing] == YES)
	{
		
	 //// sliden
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];		
		CGRect rect = mainBar.frame;
		rect.origin.x = 0;
		mainBar.frame = rect;		
		rect = editBar.frame;
		if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
			rect.origin.x = -480;
		else
			rect.origin.x = -320;
		
		//rect.origin.y = 0;
		editBar.frame = rect;

		[UIView commitAnimations];

		

		[tableView setEditing:NO animated:YES];	
		
		
/*		[tableView beginUpdates];
		[tableView setEditing:NO animated:YES];	
		[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[calcList count] inSection:0]] withRowAnimation: UITableViewRowAnimationLeft];
		[tableView endUpdates];*/
		
		
		////flippen
/*
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[editBar setHidden: YES];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:editBar cache:YES];	
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[mainBar setHidden:NO];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainBar cache:YES];	
		[UIView commitAnimations];
*/		


	}
	else
	{

		///schieben
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];

		CGRect rect = mainBar.frame;

		if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
			rect.origin.x = 480;
		else
			rect.origin.x = 320;
		

		mainBar.frame = rect;

		rect = editBar.frame;

		rect.origin.x = 0;
		//rect.origin.y = 0;
		editBar.frame = rect;
//		NSLog(@"%f,%f,%f,%f2",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
		[UIView commitAnimations];


		[tableView setEditing:YES animated:YES];		
		
		/*[tableView beginUpdates];
		[tableView setEditing:YES animated:YES];
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[calcList count] inSection:0]] withRowAnimation: UITableViewRowAnimationLeft];
		[tableView endUpdates];*/
		
	/*	
		////flippen
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[mainBar setHidden:YES];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mainBar cache:YES];	
		[UIView commitAnimations];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[editBar setHidden: NO];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:editBar cache:YES];	
		[UIView commitAnimations];
		*/



		
	}
//	[tableView reloadData];

}

- (IBAction) addViewReturnSave: (id) sender
{
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	mayRotate = YES;
	NSInteger from_code_index = [pickerView selectedRowInComponent: 0];
	NSInteger to_code_index = [pickerView selectedRowInComponent: 1];

	//[activityIndicator startAnimating];
	ForexDataObject *fdo = [[ForexDataObject init] alloc];
	[fdo setFromCurrencyCode: [[currencyList objectAtIndex: from_code_index] currencyCode]];
	[fdo setToCurrencyCode: [[currencyList objectAtIndex: to_code_index] currencyCode]];
	//[fdo updateExchangeRate];
	
	[calcList addObject: fdo];
	[self updateExchangeRates: self];
	
	BOOL b = [self saveCalcList];
	if (b == NO)
	{
		//NSLog(@"error saving calclist.dat!");
	}
	
	
	
	//[tableView insertRowsAtIndexPaths:<#(NSArray *)indexPaths#> withRowAnimation:<#(UITableViewRowAnimation)animation#>
	[tableView reloadData];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];	
	[addView removeFromSuperview];
	[UIView commitAnimations];
	//[activityIndicator stopAnimating];
	
	
	[fdo release];
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}

- (IBAction) addViewReturnCancel: (id) sender
{
	
	mayRotate = YES;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];	
	[addView removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction) addCellToTableView: (id) sender
{
	mayRotate = NO;
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		mayRotate = YES;
		UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"No space on screen!" message:@"Please turn your device to portrait mode!" delegate: nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
		
		[a show];
		[a release];
		
		return;
	}


	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];	
//	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];	

	/*if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
	{
		CGRect r = [addView frame];
		[addView setFrame: CGRectMake(r.origin.x, r.origin.y, 480, 320)];
		[addView setNeedsDisplay];
	}
	else
	{
		CGRect r = [addView frame];
		[addView setFrame: CGRectMake(r.origin.x, r.origin.y, 320, 480)];
		[addView setNeedsDisplay];
	}*/
	
	
	
	[self addSubview: addView];	

	
	if (addView != nil)
	{
		[addViewLabel1 setText: [[currencyList objectAtIndex:[pickerView selectedRowInComponent:0]] currencyDescription]];
		[addViewLabel2 setText: [[currencyList objectAtIndex:[pickerView selectedRowInComponent:1]] currencyDescription]];	
	}
	
	[UIView commitAnimations];
	
/*	if ([self superview] != nil) {
		[self s
		//[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [infoButton removeFromSuperview];
		[self.view addSubview:flipsideView];
		[self.view insertSubview:flipsideNavigationBar aboveSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];
		
	} else {
		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[flipsideNavigationBar removeFromSuperview];
		[self.view addSubview:mainView];
		[self.view insertSubview:infoButton aboveSubview:mainViewController.view];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
	}*/
	//[UIView commitAnimations];
	
	
	
	//[pickerView setHidden: NO];
	
	//[addButton setHidden: YES];
	
	//[self addSubview: addView];
	//[addView removeFromSuperview];
	//[addView setHidden: NO];
	
	
	/*ForexDataObject *fdo = [[[ForexDataObject alloc] init] autorelease];
	[fdo setFromCurrencyCode:@"PLN"];
	[fdo setToCurrencyCode:@"USD"];
	[fdo updateExchangeRate];
	[calcList addObject:fdo];*/
	//	[tableView reloadData];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"iForex 1.0";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	//NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:118800];
	NSString *formattedDateString = [dateFormatter stringFromDate:lastUpdated];
//	return formattedDateString;
//	//NSLog(@"formattedDateString for locale %@: %@",
//		  [[dateFormatter locale] localeIdentifier], formattedDateString);
	
	return [NSString stringWithFormat:@"Last updated: %@", formattedDateString];
	//return [lastUpdated description];
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

			return ([calcList count]+1);
	
	if ([tableView isEditing])
	{	
		//NSLog(@"is editing at numbersofrows");
		return ([calcList count]+1);
		
	}
	else
		return [calcList count];

	//return 0;
}


// hack damit die dele-buttons beim tap nach rechts nicht angezeigt werden
// mit StyleInsert gibts kein control, dass dann auftaucht
// shame on you apple
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ([tableView isEditing])
	{
		if ([indexPath row] == ([calcList count]))
			return UITableViewCellEditingStyleInsert;
		else
			return UITableViewCellEditingStyleDelete;
	}

	if ([indexPath row] == ([calcList count]))
		return UITableViewCellEditingStyleInsert;
	else
		return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{

//		NSObject *o = [calcList objectAtIndex:[indexPath row]];
		//NSLog(@"Deleting object:");
		//NSLog(@"\tretain count: %i",[o retainCount]);
		
		
		[calcList removeObjectAtIndex:[indexPath row]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

		BOOL b = [self saveCalcList];
		if (b == NO)
		{
			//NSLog(@"error saving calclist.dat at commitEditingStyle!");
		}
		
		////NSLog(@"delete %i", [indexPath row]);				
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
		////NSLog(@"add %i", [indexPath row]);
		[self addCellToTableView:self];
	}

	//[tableView reloadData];
}

/*- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self toggleEdit: self];
	
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSLog(@"Cell For Row At Index %i", indexPath.row);
	static NSString *MyIdentifier = @"MyIdentifier";
	static NSString *addIdentifier = @"addIdentifier";
	
	
	if ([indexPath row] == ([calcList count]))
	{	

		
		//NSLog(@"add cell!");
		AddCell *cell = (AddCell*)[tableView dequeueReusableCellWithIdentifier:addIdentifier];

		
		if (cell == nil) 
		{
			//NSLog(@"%@", [[NSBundle mainBundle] loadNibNamed:@"AddCell" owner:self options: nil]);
			
			cell = (AddCell*)[[[NSBundle mainBundle] loadNibNamed:@"AddCell" owner:self options: nil] objectAtIndex:0];
			
			UIImageView *iv = [[[UIImageView alloc] initWithImage: cellBackgroundImage] autorelease];
			[cell setBackgroundView:iv];
			
			[[cell cellText] setText:@"Add new ..."];
			
		//	[[cell cellText] release];
			
		}
		
		return cell;
		
		
		//NSLog(@"FICK DICH OPFER!");
		//[cell setText: @"Add to watchlist"];

		return cell;
	}
	
	
	
	//NSLog(@"normal cell!");
	AtomTableViewCell *cell = (AtomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) 
	{
		cell = (AtomTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"AtomCell" owner:self options: nil] objectAtIndex:0];

		UIImageView *iv = [[[UIImageView alloc] initWithImage: cellBackgroundImage] autorelease];
		[cell setBackgroundView:iv];
		
	}

	
	
	
	
	ForexDataObject *fdo = [calcList objectAtIndex:indexPath.row];
	double finput = [[inputField text] doubleValue];
	if ([fdo exchangeRate] > 0.0f)
	{
		double ex1 =  finput * [fdo exchangeRate];
		double ex2 =  finput / [fdo exchangeRate];	
	
		NSString *format = nil;
		if (finput >= 10.0)
			format = @"%.2f %@ = %.2F %@";
		else
			format = @"%.2f %@ = %.4F %@";
	
		NSString *zeile1_text = [[NSString stringWithFormat:format,finput, [fdo fromCurrencyCode],ex1,[fdo toCurrencyCode]] autorelease];
		NSString *zeile2_text = [[NSString stringWithFormat:format,finput, [fdo toCurrencyCode],ex2,[fdo fromCurrencyCode]] autorelease];	
	
		[zeile1_text retain];
		[zeile2_text retain];
		
		[cell setText1: zeile1_text];
		[cell setText2: zeile2_text];			
	}
	else
	{
		[cell setText1:@"Your are offline!"];
		[cell setText2:@"Conversion not possible."];	
	}
	/* oldschool
	zeile1.text = zeile1_text;
	zeile2.text = zeile2_text;
	*/


	return cell;
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
/*- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	//NSLog(@"will select?");

	
//	if ([tableView isEditing] && [indexPath row] == ([calcList count]))
		return indexPath;
		
	return nil;
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([indexPath row] == [calcList count])
	{	
		

		
		[self addCellToTableView: self];
		return;
	}
	
	

	DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle: nil];
	[dvc setCallingView: self];
	[dvc setObjectToShowHistory: [calcList objectAtIndex:indexPath.row]];
	[dvc viewWillAppear: YES];	

	//	[[UIDevice currentDevice] setOrientation: [[UIDevice currentDevice] orientation]];
	

	

	
	//NSLog(@"%@",[self superview]);
	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: [self superview] cache:YES];
	
	[[self superview] addSubview: [dvc view]];

	[UIView commitAnimations];
	
//	[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:NO];
	
	
}

/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

	return canEdit;
	
	//NSLog(@"edit?");	
	if ([tableView isEditing] == YES)
		{
			
			return YES;
		}
	return NO;
}*/


- (BOOL) loadCalcList
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	////NSLog(documentsDirectory);
	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"calclist.dat"];
	
	//NSLog(@"loading: %@",filename);
	
	//cellBackgroundImageView = [[[UIImageView alloc] initWithImage: cellBackgroundImage] autorelease];
	//[cellBackgroundImageView retain];
	
	NSMutableArray *newCalcList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];
	
	
	NSString *filename_lastUpdate = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"updated.dat"];
	//NSLog(@"loading: %@",filename_lastUpdate);
	
	NSDate *newLastUpdated = (NSDate *)[NSKeyedUnarchiver unarchiveObjectWithFile:filename_lastUpdate];
	
	if (newLastUpdated != nil)
	{
//		lastUpdated = newLastUpdated;
		[self setLastUpdated: newLastUpdated];
//		[self setLastUpdated:[NSDate date]];
		//NSLog(@"lastUpdate retaincount: %i", [lastUpdated retainCount]);
		//[lastUpdated retain];
	}
	
	if (newCalcList == nil)
	{	
		return NO;
	}	
	else
	{
//		calcList = newCalcList;
		//[calcList retain];
		
		[self setCalcList: newCalcList];
		
		//NSLog(@"calcList retaincount: %i", [calcList retainCount]);
 
		return YES;
	}
}

- (BOOL) saveCurrencyList
{
	//save it to disq!
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	////NSLog(documentsDirectory);
	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"currencylist.dat"];
	//NSLog(@"saving: %@",filename);
	
	BOOL b = [NSKeyedArchiver archiveRootObject:currencyList toFile:filename];
	

	return b;
}

- (BOOL) loadCurrencyList
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	////NSLog(documentsDirectory);
	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"currencylist.dat"];
	
	//NSLog(@"loading: %@",filename);
	
	//cellBackgroundImageView = [[[UIImageView alloc] initWithImage: cellBackgroundImage] autorelease];
	//[cellBackgroundImageView retain];
	
	NSMutableArray *newCurrencyList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:filename];

	
	
	if (newCurrencyList == nil)
	{	
		return NO;
	}	
	else
	{
		
		[self setCurrencyList: newCurrencyList];
		
		//NSLog(@"currencyList retaincount: %i",[currencyList retainCount]);
//		currencyList = newCurrencyList;
//		[currencyList retain];
		
		
		return YES;
	}
}

- (BOOL) saveCalcList
{
	//save it to disq!
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	////NSLog(documentsDirectory);
	
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"calclist.dat"];
	//NSLog(@"saving: %@",filename);
	
	BOOL b = [NSKeyedArchiver archiveRootObject:calcList toFile:filename];
	
	
	NSString *filename_lastUpdate = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"updated.dat"];
	//NSLog(@"saving: %@",filename_lastUpdate);

	BOOL c = [NSKeyedArchiver archiveRootObject:lastUpdated toFile:filename_lastUpdate];
	
	
	return (b && c);
}


- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == inputField)
    {
        // The return key is set to Done, so hide the keyboard
        [inputField resignFirstResponder];
    }
    return NO;
}


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (void) createDefaultCurrencyList
{
	currencyList = [[NSMutableArray alloc] init];

	CurrencyDataObject *cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"EUR"];
	[cdo setCurrencyDescription:@"Euro"];
	[currencyList addObject:cdo];
	[cdo release];
	
	cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"GBP"];
	[cdo setCurrencyDescription:@"British Pound"];
	[currencyList addObject:cdo];
	[cdo release];
	
	cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"JPY"];
	[cdo setCurrencyDescription:@"Japanese Yen"];
	[currencyList addObject:cdo];
	[cdo release];

	cdo = [[CurrencyDataObject alloc] init];
	[cdo setCurrencyCode: @"USD"];
	[cdo setCurrencyDescription:@"US Dollar"];
	[currencyList addObject:cdo];
	[cdo release];	
}

- (void) createDefaultCalcList
{
	calcList = [[NSMutableArray alloc] init];
	
	ForexDataObject *fdo = [[ForexDataObject alloc] init];
	[fdo setFromCurrencyCode:@"USD"];
	[fdo setToCurrencyCode:@"EUR"];
	//[fdo updateExchangeRate];
	[calcList addObject:fdo];
	[fdo release];
	
	fdo = [[ForexDataObject alloc] init];
	[fdo setFromCurrencyCode:@"USD"];
	[fdo setToCurrencyCode:@"GBP"];
	//[fdo updateExchangeRate];
	[calcList addObject:fdo];
	[fdo release];
	
}


/*
 If the view is stored in the nib file, when it's unarchived it's sent -initWithCoder:.
 This is the case in the example as provided.  See also initWithFrame:.
 */
- (id)initWithCoder:(NSCoder *)coder 
{
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;	
	if (self = [super initWithCoder:coder]) 
	{
		//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		cellBackgroundImage = [UIImage imageNamed:@"cell_1.png"];
		[cellBackgroundImage retain];
		
		BOOL bLoad = [self loadCalcList];
		
		if (bLoad == NO)
		{
			//NSLog(@"error loading saved calclist - create new one!");
			[self createDefaultCalcList];
			//[self updateExchangeRates: self];
//			return;
		}
		else
		{	
			//[newCalcList retain];
			//calcList = newCalcList;
			//NSLog(@"ok, calclist loaded. let's update it!");
		//	[self updateExchangeRates: self];
			
		}

		bLoad = [self loadCurrencyList];
		
		if (bLoad == NO)
		{
			//NSLog(@"\terror - no currency list found :((( create minimalistic one!");
			[self createDefaultCurrencyList];
		}
		
		//[session release];
		//[self setSession: newSession];

		[[Reachability sharedReachability] setHostName:@"www.fluxforge.com"];
		NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
		
		if (internetConnectionStatus == NotReachable)
		{	
			//NSLog(@"internet not reachable! let's load our cached currency list!");
		}


	}
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//NSLog(@"initWithCoder done");
	//[[self ] setTitle:@"Updating ..."];
	return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [currencyList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{	
	return [[currencyList objectAtIndex:row] currencyCode];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0)
		[addViewLabel1 setText: [[currencyList objectAtIndex:row] currencyDescription]];
	else
		[addViewLabel2 setText: [[currencyList objectAtIndex:row] currencyDescription]];
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
}

- (void) didLoad
{

	//NSLog(@"did load!");
	
	//sliden
	[self insertSubview:editBar belowSubview:mainBar];
	CGRect rect = editBar.frame;
	rect.origin.x = -320;
	editBar.frame = rect;
	
	
	[tableView setBackgroundColor:[UIColor clearColor]];
	[lastUpdatedLabel setText: @"Updating ..."];
	
	//show view first :/
	//fugly hack!
	[NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(updateExchangeRates:) userInfo:nil repeats:NO];
	
}

- (void)dealloc 
{
	//NSLog(@"Main View Dealloc!");
	
	[calcList release];
	[currencyList release];
	[super dealloc];
}


@end
