//
//  ForexDataObject.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 05.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ForexDataObject.h"

#import "Reachability.h"

@implementation ForexDataObject

@synthesize fromCurrencyCode;
@synthesize toCurrencyCode;
@synthesize exchangeRate;

- (void) updateExchangeRate
{
	[[Reachability sharedReachability] setHostName:@"download.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
	
	if (internetConnectionStatus == NotReachable)
	{	
		//NSLog(@"INTERNETS NO THER!");
		if (exchangeRate == 0.0f)
			[self setExchangeRate: 0.0f];
	}
	else
	{	
		//NSLog(@"internet connection status: %i",internetConnectionStatus);
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		NSString *url = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@%@=X&f=l1",fromCurrencyCode,toCurrencyCode];
		NSString *data = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
		[self setExchangeRate:[data floatValue]];
		//NSLog(@"%.4f",[self exchangeRate]);	
		
		//NSLog(@"-----------------------------------------------------------------");
		//NSLog(@"update exchange rate");
		//NSLog(@"\turl RI: %i",[url retainCount]);
		//NSLog(@"\tdata RI: %i",[data retainCount]);
		//NSLog(@"-----------------------------------------------------------------");

		[pool release];
	}
	
	return;
}

- (void) dealloc
{
	//NSLog(@"-----------------------------------------------------------------");
	//NSLog(@"deallocationg fdo!");
	//NSLog(@"\tfromCurrencyCode RI: %i",[fromCurrencyCode retainCount]);
	//NSLog(@"\ttoCurrencyCode RI: %i",[toCurrencyCode retainCount]);
	//NSLog(@"-----------------------------------------------------------------");
	
	[fromCurrencyCode release];
	[toCurrencyCode release];
	
	[super dealloc];
}

- (id) initWithCoder: (NSCoder *) coder
{
	[super init];
	fromCurrencyCode = [[coder decodeObjectForKey:@"fromCurrencyCode"] retain];
	toCurrencyCode = [[coder decodeObjectForKey:@"toCurrencyCode"] retain];
	
	
	exchangeRate = [coder decodeFloatForKey:@"exchangeRate"];
	
	return self;
	
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: fromCurrencyCode forKey: @"fromCurrencyCode"];
	[coder encodeObject: toCurrencyCode forKey: @"toCurrencyCode"];
	[coder encodeFloat: exchangeRate forKey: @"exchangeRate"];
	
}



@end
