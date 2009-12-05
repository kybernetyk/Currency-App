/**
 * AdViewController.m
 * AdMob iPhone SDK publisher code.
 *
 * Sample code. See AdViewController.h for instructions.
 */

#import "AdMobView.h"
#import "AdViewController.h"

@implementation AdViewController

- (void)awakeFromNib {
  // If using this object in a nib other than MainWindow.xib (like this example), keep the following [self retain] line, else this object will be autoreleased
  // out of existence -- see http://developer.apple.com/releasenotes/DeveloperTools/RN-InterfaceBuilder/index.html#//apple_ref/doc/uid/TP40001016-SW5
  // section "FAQ: What is different about NIB loading in a Cocoa Touch application?"
  // You can tell that this is occurring if you never get any calls back to -didReceiveAd: or -didFailToReceiveAd:.
  [self retain];
  self.view.hidden = YES; // when there's no ad, let our (placeholder) view be unobstructive
  adMobAd = [AdMobView requestAdWithDelegate:self]; // start a new ad request
  [adMobAd retain]; // this will be released when it loads (or fails to load)
}

- (void)dealloc {
  [refreshTimer invalidate];
  [adMobAd release];
  [super dealloc];
}

// Request a new ad. If a new ad is successfully loaded, it will be animated into location.
- (void)refreshAd:(NSTimer *)timer {
  [adMobAd requestFreshAd];
}

#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherId {
  return @"a14af986666c6db"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIColor *)adBackgroundColor {
  return [UIColor colorWithRed:0.271 green:0.592 blue:0.247 alpha:1]; // this should be prefilled; if not, provide an RGB-based UIColor
}

- (UIColor *)primaryTextColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)secondaryTextColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1]; // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation {
  return NO; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
}

// To receive test ads rather than real ads...

/*- (BOOL)useTestAd {
  return YES;
}

- (NSString *)testAdAction {
  return @"url"; // see AdMobDelegateProtocol.h for a listing of valid values here
}
*/

// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView {
  NSLog(@"AdMob: Did receive ad");
  self.view.hidden = NO;
  adMobAd.frame = [self.view convertRect:self.view.frame fromView:self.view.superview]; // put the ad in the placeholder's location
	UIColor *col = [UIColor colorWithWhite: 1.0 alpha: 0.0];
	[adMobAd setBackgroundColor: col];
	
  [self.view addSubview:adMobAd];
  [refreshTimer invalidate];
  refreshTimer = [NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:self selector:@selector(refreshAd:) userInfo:nil repeats:YES];
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
  NSLog(@"AdMob: Did fail to receive ad");
  [adMobAd release];
  adMobAd = nil;
  // we could start a new ad request here, but it is unlikely that anything has changed in the last few seconds,
  // so in the interests of the user's battery life, let's not
}

@end