//
//  ForexDataObject.h
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForexDataObject : NSObject <NSCoding>
{

	NSString *fromCurrencyCode;
	NSString *toCurrencyCode;
	float exchangeRate;
}

@property (readwrite,retain) NSString *fromCurrencyCode;
@property (readwrite,retain) NSString *toCurrencyCode;
@property (readwrite,assign) float exchangeRate;

- (void) updateExchangeRate; //phone yahooo

@end
