//
//  InterstitialSampleViewController.m
//  InterstitialSample
//
//  Copyright AdMob 2009. All rights reserved.
//

#import "InterstitialSampleViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <math.h>


// Replace this with your own movie URL to test pre-roll.
#define MOVIE_URL @"http://mmv.admob.com/p/v/77/4b/774b0bc3eb7959af8d690fa63ee3f9da/video.mov"


@interface InterstitialSampleViewController()

- (void)startMovie;
- (void)dimTheLights;
- (void)turnUpTheLights;

@end


@implementation InterstitialSampleViewController

@synthesize label, playMovieButton;
@synthesize moviePlayer;


- (void)loadView
{
  [super loadView];
  
  // Show Default.png (the splash screen) until the interstitial request completes.
  splashView = [[UIImageView alloc] initWithFrame:self.view.frame];
  splashView.image = [UIImage imageNamed:@"Default.png"];
  [self.view addSubview:splashView];
  
  // Since our application starts in landscape we need to rotate Default.png to landscape too.
  splashView.transform = CGAffineTransformMakeRotation(-M_PI/2);
  splashView.center = CGPointMake(CGRectGetMidY(self.view.frame), CGRectGetMidX(self.view.frame));
}

- (void)dealloc 
{
  // remove movie notifications
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:moviePlayer];
  [moviePlayer release];
  [splashView release];
  [blackScreen release];
  [prerollInterstitial release];
  [super dealloc];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)welcomeUser
{
  // Remove the splash screen image if it was showing.
  if(splashView)
  {
    [splashView removeFromSuperview];
    [splashView release];
    splashView = nil;
  }
  
  // Customize our view.
  [label setText:@"Welcome!"];
  playMovieButton.hidden = NO;
}

- (void)startMovie
{
  // Note we should always create a new MPMoviePlayerController object.  Apple's 
  // implementation has bugs if we try to reuse the player to play the same movie
  // again.
  self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:MOVIE_URL]];
  
  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(moviePlayBackDidFinish:) 
                                               name:MPMoviePlayerPlaybackDidFinishNotification 
                                             object:self.moviePlayer];
  
  [self.moviePlayer play];
}


- (IBAction)buttonPressed:(id)button
{
  // first darken the screen
  [self dimTheLights];
  
  if(prerollInterstitial.ready)
  {
    // Show the pre-roll interstitial.  When it completes the delegate -interstitialDidDisappear
    // will be called and that will call -startMovie.
    [prerollInterstitial show];
    interstitialPlaying = YES;
    
    // Throw away the interstitial and get a new one.
    [prerollInterstitial release];
    prerollInterstitial = nil;
    
    [AdMobInterstitialAd requestInterstitialAt:AdMobInterstitialEventPreRoll 
                                      delegate:self 
                          interstitialDelegate:self];
  }
  else
  {
    [self startMovie];
  }
}

// Keep the screen dark between the pre-roll interstitial video and our video.

- (void)dimTheLights
{
  if(!blackScreen)
  {
    blackScreen = [[UIView alloc] initWithFrame:self.view.bounds];
    blackScreen.backgroundColor = [UIColor blackColor];
  }
  
  [UIView beginAnimations:nil context:nil];
  [self.view addSubview:blackScreen];
  [UIView commitAnimations];
}

- (void)turnUpTheLights
{
  [UIView beginAnimations:nil context:nil];
  [blackScreen removeFromSuperview];
  [UIView commitAnimations];
}

//  Notification called when the movie finished playing.
- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
  // Workaround for bug in Apple's movie player.  The movie player is implemented
  // as a singleton so even though we registered for notifications to the
  // self.moviePlayer object, we'll also get notifications to the interstitial's movie player.
  // This flag tells us whether it was the interstitial video that completed or
  // self.moviePlayer.
  if(!interstitialPlaying)
  {
    // Workaround for another bug in Apple's MPMoviePlayerController in 3.x.  This makes the
    // movie actually stop.
    self.moviePlayer.initialPlaybackTime = -1;
    
    // this is our movie finishing, so we can transition back to our own view.
    [self turnUpTheLights];
  }
}

#pragma mark AdMobInterstitialDelegate methods

// Sent when an interstitial ad request succefully returned an ad.  At the next transition
// point in your application call [ad show] to display the interstitial.
- (void)didReceiveInterstitial:(AdMobInterstitialAd *)ad
{
  switch(ad.applicationEvent)
  {
    case AdMobInterstitialEventAppOpen:
      // Show the interstitial.  This is just after the splash screen but before -welcomeUser.
      [ad show];
      
      // Request another interstitial to show later before playing MOVIE_URL.
      [AdMobInterstitialAd requestInterstitialAt:AdMobInterstitialEventPreRoll 
                                        delegate:self 
                            interstitialDelegate:self];
      break;
    case AdMobInterstitialEventPreRoll:
      // Hold onto the interstitial until the movie is played.
      prerollInterstitial = [ad retain];
      break;
  }
}

// Sent when an interstitial ad request completed without an interstitial to show.  This is
// common since interstitials are shown sparingly to users.
- (void)didFailToReceiveInterstitial:(AdMobInterstitialAd *)ad
{
  NSLog(@"No interstitial ad retrieved.  This is ok.");
  
  // check the ad type to know what we do next.
  switch(ad.applicationEvent)
  {
    case AdMobInterstitialEventAppOpen:
      // No interstitial so immediately replace the splash screen (Default.png) with this view.
      [self welcomeUser];
      break;
    case AdMobInterstitialEventPreRoll:
      // There was no pre-roll interstitial so we have nothing to do.
      break;
  }  
}

- (void)interstitialWillDisappear:(AdMobInterstitialAd *)ad
{
  if(ad.applicationEvent == AdMobInterstitialEventAppOpen)
  {
    // The app-oven interstitial is about to disapper revealing self.view.
    [self welcomeUser];
  }
}

- (void)interstitialDidDisappear:(AdMobInterstitialAd *)ad
{
  interstitialPlaying = NO;
  
  if(ad.applicationEvent == AdMobInterstitialEventPreRoll)
  {
    // The pre-roll has completed.
    // on the simulator this will often play the interstitial ad video.
    // This does not occur on the device.
    [self startMovie];
  }
}

#pragma mark AdMobDelegate methods

// Use this to provide a publisher id for an ad request. Get a publisher id
// from http://www.admob.com
- (NSString *)publisherId
{
  return @"a14af986666c6db";
}

#pragma mark AdMobDelegate test ad methods

// These force the interstitial video test ad to be returned.

- (BOOL)useTestAd
{
  return YES;
}

- (NSString *)testAdAction 
{
  return @"video_int";
}


@end