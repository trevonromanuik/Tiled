//
//  Belt.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCExtensions.h"
#import "Gem.h"
#import "Spinner.h"

@interface Belt : CCLayer {
	@public 
	
	void (^onGemGrab)(Gem*, UITouch*);
	void (^onGemMove)(Gem*, UITouch*);
	BOOL (^onGemDrop)(Gem*, UITouch*);
	void (^onGemMissed)(Gem*);
	void (^onPowerUp)(int);
	
	@private 
	
	Gem* selGem;
	
	CCLayer *beltLayer;
	CCLayer *gemLayer;
		
	int beltSpeed;
	int direction;
	
	ccTime gemSpawnRate;
	ccTime curGemSpawnTime;
	
	bool shouldSpawnStreak;
	bool isInStreak;
	int numGemsToSpawn;
	int numGemsStreak;
	bool shouldSpawnPowerup;
}

@property (readwrite, copy) void (^onGemGrab)(Gem*, UITouch*);
@property (readwrite, copy) void (^onGemMove)(Gem*, UITouch*);
@property (readwrite, copy) BOOL (^onGemDrop)(Gem*, UITouch*);
@property (readwrite, copy) void (^onGemMissed)(Gem*);
@property (readwrite, copy) void (^onPowerUp)(int);

//initializes a new belt with a height
+(id) beltWithHeight:(int)height;

//initializes the instance
-(id) initWithHeight:(int)height;

// updates the objects every frame
-(void) nextFrame:(ccTime)dt;

//does all of the logic that goes along with updating the belt speed
-(int) updateBeltSpeed:(int)deltaSpeed;

//changes belt direction
-(void) changeDirection;

//queues a shiny gem streak
-(void) queueStreak;

// releases all retained objects
-(void) dealloc;

@end
