//
//  CurrencyDataObject.m
//  Forex
//
//  Created by Jaroslaw Szpilewski on 06.08.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CurrencyDataObject.h"


@implementation CurrencyDataObject
@synthesize currencyCode;
@synthesize currencyDescription;


- (id) initWithCoder: (NSCoder *) coder
{
	[super init];
	currencyCode = [[coder decodeObjectForKey:@"currencyCode"] retain];
	currencyDescription = [[coder decodeObjectForKey:@"currencyDescription"] retain];
	
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: currencyCode forKey: @"currencyCode"];
	[coder encodeObject: currencyDescription forKey: @"currencyDescription"];
}


- (void) dealloc
{
	//NSLog(@"-----------------------------------------------------------------");
	//NSLog(@"deallocationg cdo!");
	//NSLog(@"\tcurrencyCode RI: %i",[currencyCode retainCount]);
	//NSLog(@"\tcurrencyDescription RI: %i",[currencyDescription retainCount]);
	//NSLog(@"-----------------------------------------------------------------");
	
	[currencyCode release];
	[currencyDescription release];
	
	[super dealloc];
}


@end
