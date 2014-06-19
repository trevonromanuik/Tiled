//
//  Gem.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Gem.h"

@implementation Gem
@synthesize gemCode;
@synthesize spawnTime;
@synthesize isShiny;

-(id) init {
    if(self=[super init]){
        gemCode = 0;
		isShiny = false;
    }
    return self;
}

- (void) dealloc
{
	[spawnTime dealloc];
    [super dealloc];
}

@end
