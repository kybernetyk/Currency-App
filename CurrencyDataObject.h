//
//  CurrencyDataObject.h
//  Forex
//
//  Created by Jaroslaw Szpilewski on 06.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrencyDataObject : NSObject <NSCoding>
{
	NSString *currencyCode;
	NSString *currencyDescription;
}

@property (readwrite, retain) NSString *currencyCode;
@property (readwrite,retain) NSString *currencyDescription;

@end
