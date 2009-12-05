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
@synthesize exchangeRate1;
@synthesize exchangeRate2;

- (void) updateExchangeRate
{
	[[Reachability sharedReachability] setHostName:@"download.finance.yahoo.com"];
	NetworkStatus internetConnectionStatus = [[Reachability sharedReachability] remoteHostStatus];
	
	if (internetConnectionStatus == NotReachable)
	{	

	}
	else
	{	
		//NSLog(@"internet connection status: %i",internetConnectionStatus);
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
		NSString *url = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@%@=X&f=l1",fromCurrencyCode,toCurrencyCode];
		NSString *data = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
		
		double ex1 = [data doubleValue];

		url = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@%@=X&f=l1",toCurrencyCode,fromCurrencyCode];
		data = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
		double ex2 = [data doubleValue];		


		
		

		NSDecimalNumber *dec1 = [NSDecimalNumber decimalNumberWithString: [NSString stringWithFormat: @"%f", ex1]];
		NSDecimalNumber *dec2 = [NSDecimalNumber decimalNumberWithString: [NSString stringWithFormat: @"%f", ex2]];
		NSDecimalNumber *decOne = [NSDecimalNumber one];
		
	//	NSLog(@"dec1: %@",dec1);
	//	NSLog(@"dec2: %@",dec2);
		
		
		if (ex2 > ex1)
		{	
			dec1 = [decOne decimalNumberByDividingBy: dec2];
		}
		if (ex1 > ex2)
		{	
			dec2 = [decOne decimalNumberByDividingBy: dec1];
		}
		
	//	NSLog(@"dec1: %@",dec1);
	//	NSLog(@"dec2: %@",dec2);
		
		[self setExchangeRate1: dec1];
		[self setExchangeRate2: dec2];
		
/*		if ([self exchangeRate1] > [self exchangeRate2])
			[self setExchangeRate2: [self exchangeRate1] / [self exchangeRate2]];
		if ([self exchangeRate2] > [self exchangeRate1])
			[self setExchangeRate1: [self exchangeRate2] / [self exchangeRate1]];*/
		
		
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
	[exchangeRate1 release];
	[exchangeRate2 release];
	
	[super dealloc];
}

- (id) initWithCoder: (NSCoder *) coder
{
	[super init];
	fromCurrencyCode = [[coder decodeObjectForKey:@"fromCurrencyCode"] retain];
	toCurrencyCode = [[coder decodeObjectForKey:@"toCurrencyCode"] retain];
	
	
	[self setExchangeRate1: [coder decodeObjectForKey:@"exchangeRate1"]];
	[self setExchangeRate2: [coder decodeObjectForKey:@"exchangeRate2"]];
	
	return self;
	
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: fromCurrencyCode forKey: @"fromCurrencyCode"];
	[coder encodeObject: toCurrencyCode forKey: @"toCurrencyCode"];
	[coder encodeObject: exchangeRate1 forKey: @"exchangeRate1"];
	[coder encodeObject: exchangeRate2 forKey: @"exchangeRate2"];
}



@end
