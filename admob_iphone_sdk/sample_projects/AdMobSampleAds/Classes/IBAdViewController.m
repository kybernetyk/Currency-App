/**
 * IBAdViewController.m
 * AdMob iPhone SDK sample code.
 *
 * Sample code. See AdViewController.h for instructions.
 */

#import "AdMobView.h"
#import "IBAdViewController.h"

@implementation IBAdViewController

// The designated initializer.  Override if you create the controller programmatically 
// and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    // Custom initialization
    self.title = @"IB Ad";
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

@end