//
//  HighScores.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScores.h"

@implementation HighScores

const int HIGH_SCORE_COUNT = 10;

+(void) addNewHighScore:(HighScoreRecord *)score
{
	NSMutableArray *locals = [HighScores getLocalHighScores];
	
	if(locals.count < HIGH_SCORE_COUNT)	{
		
		[locals addObject:score];
		
		NSMutableArray *sortedLocals = [HighScores sortLocalHighScores:locals];
		
		[HighScores saveLocalHighScores:sortedLocals];
		
		[sortedLocals release];
	} 
	else {
		HighScoreRecord *lastRecord = [locals objectAtIndex:(HIGH_SCORE_COUNT - 1)];
		if([score.totalScore intValue] > [lastRecord.totalScore intValue]) {
			
			[locals removeLastObject];
			[locals addObject:score];
			
			NSMutableArray *sortedLocals = [HighScores sortLocalHighScores:locals];
			
			[HighScores saveLocalHighScores:sortedLocals];
			
			[sortedLocals release];
		}
	}
}

+(NSString *) highScoresFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"HighScoresFile"];
}

+(NSMutableArray *) getLocalHighScores {
	NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[HighScores highScoresFilePath]];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	NSArray *highScores = [unarchiver decodeObjectForKey:@"HighScores"];
	
	return [[[NSMutableArray alloc] initWithArray:highScores copyItems:NO] autorelease];
}

+(void) saveLocalHighScores:(NSArray *)highScoreArray {
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject:highScoreArray forKey:@"HighScores"];
	[archiver finishEncoding];
	
	[data writeToFile:[HighScores highScoresFilePath] atomically:YES];
	[archiver release];
	[data release];
}

+(NSMutableArray *)sortLocalHighScores:(NSMutableArray *)highScoreArray {
	NSString *SORT_KEY = @"totalScore";
	NSSortDescriptor *scoreDescriptor = [[[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:NO selector:@selector(compare:)] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:scoreDescriptor, nil];
	
	NSArray *sortedArray = [highScoreArray sortedArrayUsingDescriptors:sortDescriptors];
	
	return [[NSMutableArray alloc] initWithArray:sortedArray copyItems:NO];
}

@end
