/**
 * RootViewController.m
 * AdMob iPhone SDK publisher code.
 */

#import "TableViewAdViewController.h"
#import "AdMobView.h"
//#import "AdMobSampleTableViewAdAppDelegate.h"

@implementation TableViewAdViewController

// The designated initializer.  Override if you create the controller programmatically 
// and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
    self.title = @"TableView Ad";
  }
  return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"MyIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    // Request an AdMob ad for this table view cell
    [cell.contentView addSubview:[AdMobView requestAdWithDelegate:self]];
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if((indexPath.section == 0) && (indexPath.row == 0)) {
    return 48.0; // this is the height of the AdMob ad
  }
  
  return 44.0; // this is the generic cell height
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherId {
  return @"a14af986666c6db"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIColor *)adBackgroundColor {
  return [UIColor colorWithRed:0.271 green:0.592 blue:0.247 alpha:1]; // this should be prefilled; if not, provide a UIColor
}


- (UIColor *)primaryTextColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation {
  return YES; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
}

// To receive test ads rather than real ads...

- (BOOL)useTestAd 
{
  return YES;
}
 
- (NSString *)testAdAction 
{
  return @"url"; // see AdMobDelegateProtocol.h for a listing of valid values here
}



- (void)didReceiveAd:(AdMobView *)adView {
  NSLog(@"AdMob: Did receive ad");
}

- (void)didFailToReceiveAd:(AdMobView *)adView {
  NSLog(@"AdMob: Did fail to receive ad");
}

@end