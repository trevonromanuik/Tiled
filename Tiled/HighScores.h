//
//  HighScores.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighScoreRecord.h"

@interface HighScores : NSObject {}

+(void) addNewHighScore:(HighScoreRecord *)score;
+(void) saveLocalHighScores:(NSArray *)highScoreArray;

+(NSString *) highScoresFilePath;
+(NSMutableArray *) getLocalHighScores;
+(NSMutableArray *) sortLocalHighScores:(NSMutableArray *)highScoreArray;

@end
