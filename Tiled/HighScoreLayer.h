//
//  HighScoreLayer.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-05-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HighScores.h"

//HighScoreLayer
@interface HighScoreLayer : CCLayer
{
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

// initializes the instance
-(id) init;

// releases all retained objects
-(void) dealloc;

@end
