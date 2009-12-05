//
//  RootViewController.m
//  AdMobSampleAds
//
//  Created by Michael Ying on 6/2/09.
//  Copyright AdMob, Inc. 2009. All rights reserved.
//

#import "RootViewController.h"
#import "IBAdViewController.h"
#import "ProgrammaticAdViewController.h"
#import "TableViewAdViewController.h"

static NSString *kCellIdentifier = @"AdMobIdentifier";
static NSString *kTitleKey = @"title";
static NSString *kViewControllerKey = @"viewController";

@implementation RootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.navigationItem.title = self.title;
  // this will create three different ways of integrating AdMob ads into your application.
  // initialize three different view controllers.
  menuList = [[NSMutableArray alloc] init];
  
  // we are demonstrating three different integration styles:
  
  // 1. Interface Builder integration
  IBAdViewController *ibAdViewController = [[IBAdViewController alloc] initWithNibName:@"IBAdViewController"
                                                                                bundle:nil];
  [menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                       NSLocalizedString(@"IBAdView Integration", @""), kTitleKey,
                       ibAdViewController, kViewControllerKey,
                       nil]];
  
  // 2. Programmatic integration
  ProgrammaticAdViewController *programmaticAdViewController = [[ProgrammaticAdViewController alloc] init];
  
  [menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                       NSLocalizedString(@"Programmatic Integration", @""), kTitleKey,
                       programmaticAdViewController, kViewControllerKey,
                       nil]];
  
  // 3. Table View Controller integration
  TableViewAdViewController *tableViewAdViewController = 
  [[TableViewAdViewController alloc] initWithNibName:@"TableViewAdViewController" bundle:nil];
  [menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                       NSLocalizedString(@"TableViewAdView Integration", @""), kTitleKey,
                       tableViewAdViewController, kViewControllerKey,
                       nil]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
  
}
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [menuList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  if (cell == nil) {
#ifdef __IPHONE_3_0    
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
#else
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
#endif
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
	// Configure the cell.
#ifdef __IPHONE_3_0
  cell.textLabel.text = [[menuList objectAtIndex:indexPath.row] objectForKey:kTitleKey];
#else
  cell.text = [[menuList objectAtIndex:indexPath.row] objectForKey:kTitleKey];
#endif
  
  return cell;
}



// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
  UIViewController *targetViewController = [[menuList objectAtIndex:indexPath.row] objectForKey:kViewControllerKey];
  [[self navigationController] pushViewController:targetViewController animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
  [menuList release];
  
  [super dealloc];
}


@end

