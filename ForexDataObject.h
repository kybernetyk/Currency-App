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
	NSDecimalNumber *exchangeRate1;
	NSDecimalNumber *exchangeRate2;
}

@property (readwrite,retain) NSString *fromCurrencyCode;
@property (readwrite,retain) NSString *toCurrencyCode;
@property (readwrite,copy) NSDecimalNumber *exchangeRate1;
@property (readwrite,copy) NSDecimalNumber *exchangeRate2;

- (void) updateExchangeRate; //phone yahooo

@end
