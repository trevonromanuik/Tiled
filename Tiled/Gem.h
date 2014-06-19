//
//  Gem.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@interface Gem : CCSprite {
	int gemCode;
	NSDate *spawnTime;
	bool isShiny;
}

@property (readwrite) int gemCode;
@property (nonatomic, retain) NSDate *spawnTime;
@property (readwrite, assign) bool isShiny;
@end
