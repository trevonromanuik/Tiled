//
//  Spinner.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-06-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Spinner.h"

const int NUM_POWERUPS = 3;

@implementation Spinner

@synthesize curPowerUp;

//TODO make constructor

-(id) init2 {
    if(self=[super initWithFile:@"bomb.png"]){
        curSpinTime = 0;
		spinTime = 1;
		curPowerUp = 0;
    }
    return self;
}

+(id) spinner {
	return [[[self alloc] init2] autorelease];
}

-(void) nextFrame:(ccTime)dt {
	curSpinTime += dt;
	if (curSpinTime > spinTime) {
		curSpinTime -= spinTime;
		
		curPowerUp = (++curPowerUp) % NUM_POWERUPS;
		NSString *filename;
		switch (curPowerUp) {
			case 0:
				filename = @"bomb.png";
				break;
			case 1:
				filename = @"key.png";
				break;
			case 2:
				filename = @"clock.png";
				break;
			default:
				filename = nil;
				break;
		}
		CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
		[self setTexture:texture];
	}
}

- (void) dealloc
{
    [super dealloc];
}

@end
