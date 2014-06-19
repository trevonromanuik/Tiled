//
//  HighScoreRecord.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScoreRecord : NSObject <NSCoding, NSCopying> {
	NSNumber *totalScore;
	NSDate *dateRecorded;
}

-(id) initWithScore:(NSNumber *)score;

-(NSComparisonResult) compare:(id)other;

@property (nonatomic, retain) NSNumber *totalScore;
@property (nonatomic, retain) NSDate *dateRecorded;

@end
