//
//  AdMobSampleAdsAppDelegate.h
//  AdMobSampleAds
//
//  Created by Michael Ying on 6/2/09.
//  Copyright AdMob, Inc. 2009. All rights reserved.
//

@interface AdMobSampleAdsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

