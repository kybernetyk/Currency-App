//
//  InterstitialSampleAppDelegate.h
//  InterstitialSample
//
//  Copyright AdMob 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InterstitialSampleViewController;

@interface InterstitialSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    InterstitialSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet InterstitialSampleViewController *viewController;

@end

