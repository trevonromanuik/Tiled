//
//  HighScoreRecord.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoreRecord.h"

@implementation HighScoreRecord

@synthesize totalScore;
@synthesize dateRecorded;

-(id) initWithScore:(NSNumber *)score
{
	if(self = [super init])
	{
		totalScore = score;
		dateRecorded = [NSDate date];
	}
	return self;
}

-(NSComparisonResult) compare:(id)other
{
	return [self.totalScore compare:other];
}

#pragma mark -
#pragma mark NSCoding
-(void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:totalScore forKey:@"TotalScore"];
	[encoder encodeObject:dateRecorded forKey:@"DateRecorded"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
	if(self = [super init])
	{
		totalScore = [decoder decodeObjectForKey:@"TotalScore"];
		dateRecorded = [decoder decodeObjectForKey:@"DateRecorded"];
	}
	return self;
}

#pragma mark -
#pragma mark NSCopying
-(id) copyWithZone:(NSZone *)zone
{
	HighScoreRecord *copy = [[[self class] allocWithZone:zone] init];
	
	copy.totalScore = [self.totalScore copy];
	copy.dateRecorded = [self.dateRecorded copy];
	
	return copy;
}

#pragma mark -
-(void) dealloc
{
	[totalScore release];
	[dateRecorded release];
	
	[super dealloc];
}
@end
