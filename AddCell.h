#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AddCell : UITableViewCell/* Specify a superclass (eg: NSObject or NSView) */ {
    IBOutlet UILabel *cellText;
}

@property (readwrite, retain) UILabel *cellText;

@end
