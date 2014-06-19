//
//  Spinner.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-06-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Spinner : CCSprite {

	ccTime spinTime;
	ccTime curSpinTime;
	
	int curPowerUp;
}

@property (readwrite, assign) int curPowerUp;

//initializes a new spinner
//TODO add array of valid powerups to constructor
+(id) spinner;

// updates the objects every frame
-(void) nextFrame:(ccTime)dt;

@end
