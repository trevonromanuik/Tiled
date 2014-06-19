//
//  Belt.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-06-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Belt.h"

const int MIN_BELT_SPEED = 100;
const int MAX_BELT_SPEED = 500;

const int GEM_DISTANCE = 200;

const int BELT_FILE_SIZE = 400;
const int BELT_SIZE = 100;
const int GEM_FILE_SIZE = 400;
const int GEM_SIZE = 80;

const int GEM_STREAK = 5;
const int NUM_GEMS = 6;

Gem *selGem;

//private properties
@interface Belt ()
@property (nonatomic,readwrite,assign) CCLayer *beltLayer;
@property (nonatomic,readwrite,assign) CCLayer *gemLayer;
@end

@implementation Belt
@synthesize onGemGrab;
@synthesize onGemMove;
@synthesize onGemDrop;
@synthesize onGemMissed;
@synthesize onPowerUp;
@synthesize beltLayer;
@synthesize gemLayer;

+(id) beltWithHeight:(int)height
{
	return [[[self alloc] initWithHeight:height] autorelease];
}

-(id) initWithHeight:(int)height
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if(self=[super init])
	{
		//init variables
		beltSpeed = MIN_BELT_SPEED;
		direction = 1;
		gemSpawnRate = (float)GEM_DISTANCE / beltSpeed;
		curGemSpawnTime = 0;
		
		onGemGrab = ^(Gem *gem, UITouch * touch) { };
		onGemMove = ^(Gem *gem, UITouch * touch) { };
		onGemDrop = ^(Gem *gem, UITouch * touch) { return YES; };
		onGemMissed = ^(Gem *gem) { };
		onPowerUp = ^(int powerUp) { };
		
		self.contentSize = ccs(BELT_SIZE, height);
		
		beltLayer = [CCLayer node];
		[self addChild:beltLayer];
		
		int numBelts = (height / BELT_SIZE) + 1;
		for(int i = 0; i <= numBelts; i++)
		{
			CCSprite *belt = [CCSprite spriteWithFile:@"conveyorbelt.png"];
			belt.scale = (float)BELT_SIZE / BELT_FILE_SIZE;
			belt.position = ccp(0, i * BELT_SIZE);
			[beltLayer addChild:belt];
		}
		
		gemLayer = [CCLayer node];
		[self addChild:gemLayer];
		
		// enable touch
		self.isTouchEnabled = YES;
	}
	return self;
}

-(void) nextFrame:(ccTime)dt {
	
	//update the belt positions
	for(int i = 0; i < [beltLayer.children count]; i++)
	{
		CCSprite *belt = [beltLayer.children objectAtIndex:i];
		belt.position = ccp(belt.position.x, belt.position.y - beltSpeed * dt);
	}
	
	//check the first object in the array to see if it has gone off of the screen
	CCSprite *belt = [beltLayer.children objectAtIndex:0];
	if(belt.position.y < -BELT_SIZE / 2)
	{
		CCSprite *lastBelt = [beltLayer.children lastObject];
		belt.position = ccp(belt.position.x, lastBelt.position.y + BELT_SIZE);
		
		[belt retain];
		[belt removeFromParentAndCleanup:YES];
		[beltLayer addChild:belt];
		[belt release];
	}
	
	for(int i = [gemLayer.children count] - 1; i >= 0; i--)
	{
		CCSprite *sprite = [gemLayer.children objectAtIndex:i];
		sprite.position = ccp(sprite.position.x, sprite.position.y - beltSpeed * dt);
		if(sprite.position.y < -GEM_SIZE / 2) {
			
			//TODO: Figure out how to tell type
			if([sprite isKindOfClass:[Gem class]])
			{
				Gem *gem = (Gem*)sprite;
				if (gem.isShiny)
				{
					isInStreak = false;
					numGemsToSpawn = 0;
					numGemsStreak = 0;
					
					//unshiny the gems
					for (int i = 0; i < gemLayer.children.count; i++) {
						CCSprite *sprite = [gemLayer.children objectAtIndex:i];
						sprite.color = ccc3(255, 255, 255);
					}
				}
				onGemMissed((Gem*)sprite);
			}
				
			[sprite removeFromParentAndCleanup:YES];
		}
		else if ([sprite respondsToSelector:@selector(nextFrame:)])
		{
			[sprite nextFrame:dt];
		}
	}
	
	//spawn a new gem
	curGemSpawnTime += dt;
	if(curGemSpawnTime > gemSpawnRate)
	{
		curGemSpawnTime -= gemSpawnRate;
		
		if (!isInStreak && shouldSpawnStreak) {
			shouldSpawnStreak = false;
			isInStreak = true;
			numGemsToSpawn = GEM_STREAK;
			numGemsStreak= GEM_STREAK;
		}
		
		if (shouldSpawnPowerup) {
			shouldSpawnPowerup = false;
			Spinner *spinner = [Spinner spinner];
			spinner.scale = 0.8;
			spinner.position = ccp(0, self.contentSize.height + GEM_SIZE / 2);
			[gemLayer addChild:spinner];
			
			return;
		}
		
		int r = arc4random_uniform(NUM_GEMS) + 1;
		NSString *file = [NSString stringWithFormat:@"gem_%d.png", r];
		
		Gem *gem = [Gem spriteWithFile:file];
		gem.gemCode = r;
		gem.spawnTime = [NSDate date];
		gem.scale = (float)GEM_SIZE / GEM_FILE_SIZE;
		gem.color = ccc3(255, 255, 255);
		gem.position = ccp(0, self.contentSize.height + GEM_SIZE / 2);
		gem.isShiny = false;
		
		if (isInStreak && numGemsToSpawn > 0) {
			gem.color = ccc3(120, 120, 120);
			gem.isShiny = true;
			numGemsToSpawn--;
		}
		
		[gemLayer addChild:gem];
	}
}

-(int) updateBeltSpeed:(int)deltaSpeed
{
	beltSpeed += deltaSpeed;
	
	if(beltSpeed < MIN_BELT_SPEED)
		beltSpeed = MIN_BELT_SPEED;
	else if (beltSpeed > MAX_BELT_SPEED)
		beltSpeed = MAX_BELT_SPEED;
	
	gemSpawnRate = (float)GEM_DISTANCE / beltSpeed;
	
	return beltSpeed;
}

-(void) changeDirection
{
	direction = -direction;
}

-(void) queueStreak
{
	shouldSpawnStreak = true;
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGPoint location = [self convertTouchToNodeSpace:touch];
	
	for(int i = [gemLayer.children count] - 1; i >= 0; i--)
	{
		CCSprite *sprite = [gemLayer.children objectAtIndex:i];
		if (CGRectContainsPoint(sprite.boundingBox, location))
		{
			if ([sprite isKindOfClass:[Gem class]])
			{
				selGem = (Gem*)sprite;
			
				[selGem retain];
				[selGem removeFromParentAndCleanup:YES];
			
				onGemGrab(selGem, touch);
			
				[selGem release];
				
				return YES;
			}
			else if ([sprite isKindOfClass:[Spinner class]])
			{
				onPowerUp(((Spinner*)sprite).curPowerUp);
				[sprite removeFromParentAndCleanup:YES];
			}
		}
	}
	
	return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(selGem != nil)
	{
		onGemMove(selGem, touch);
	}
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(selGem != nil)
	{
		bool val = onGemDrop(selGem, touch);
		if (isInStreak && selGem.isShiny) {
			if (val) {
				numGemsStreak--;
				if (numGemsStreak <= 0) {
					isInStreak = false;
					shouldSpawnPowerup = true;
				}
			}
			else {
				isInStreak = false;
				numGemsToSpawn = 0;
				numGemsStreak = 0;
				
				//unshiny the gems
				for (int i = 0; i < gemLayer.children.count; i++) {
					CCSprite *sprite = [gemLayer.children objectAtIndex:i];
					sprite.color = ccc3(255, 255, 255);
				}
			}
		}
		[selGem removeFromParentAndCleanup:YES];
		selGem = nil;
	}
}

-(void) dealloc
{
	// NOTE: cocos2D will automatically release all of the children
	[super dealloc];
}

@end
