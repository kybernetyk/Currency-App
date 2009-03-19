//
//  MainViewController.h
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;

@interface MainViewController : UIViewController 
{
	RootViewController *rootController;

}
@property (readwrite,assign) RootViewController *rootController;

- (IBAction) toggleInfoView: (id) sender;

@end
