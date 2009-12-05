//
//  InterstitialSampleAppDelegate.m
//  InterstitialSample
//
//  Copyright AdMob 2009. All rights reserved.
//

#import "InterstitialSampleAppDelegate.h"
#import "InterstitialSampleViewController.h"
#import "AdMobInterstitialAd.h"

@interface InterstitialSampleAppDelegate()


@end


@implementation InterstitialSampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
  // Override point for customization after app launch
  
  // Request an interstitial at "Application Open" time.
  [AdMobInterstitialAd requestInterstitialAt:AdMobInterstitialEventAppOpen 
                                    delegate:viewController 
                        interstitialDelegate:viewController];

  // Add any other initialization code here.  It will process while the ad
  // request is being processed.
  
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];

  
  // Depending on if there is an interstitial to show or not the next method
  // to be called will be one of:
  //   [viewController didReceiveInterstitial]
  //   [viewController didFailToReceiveInterstitial]
}

- (void)dealloc
{
  [viewController release];
  [window release];
  [super dealloc];
}


@end
