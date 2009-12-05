//
//  InterstitialSampleViewController.h
//  InterstitialSample
//
//  Copyright AdMob 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMobDelegateProtocol.h"
#import "AdMobInterstitialDelegateProtocol.h"
#import "AdMobInterstitialAd.h"

@class MPMoviePlayerController;

@interface InterstitialSampleViewController : UIViewController<AdMobDelegate, AdMobInterstitialDelegate> {
  IBOutlet UILabel *label;
  IBOutlet UIButton *playMovieButton;
  BOOL playMovieButtonPressed;
  
  MPMoviePlayerController *moviePlayer;

  AdMobInterstitialAd *prerollInterstitial;
  BOOL interstitialPlaying;
  
  UIImageView *splashView;
  UIView *blackScreen;
}

- (IBAction)buttonPressed:(id)button; 
- (void)welcomeUser;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *playMovieButton;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

@end

