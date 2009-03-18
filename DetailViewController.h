//
//  DetailViewController.h
//  Currency
//
//  Created by jrk on 17.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForexDataObject.h"

@interface DetailViewController : UIViewController 
{
	@private ForexDataObject *objectToShowHistory;
	@private UIView *callingView;
	@private IBOutlet id backButton;
	@private IBOutlet id chartImageView;
}
@property (readwrite, assign) ForexDataObject *objectToShowHistory;
@property (readwrite, assign) UIView *callingView;
@property (readwrite, assign) id backButton;
@property (readwrite, assign) id chartImageView;

- (IBAction) goBack: (id) sender;

@end
