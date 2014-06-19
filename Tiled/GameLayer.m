//
//  GameLayer.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"
#import "MainLayer.h"
#import "HighScores.h"
#import "Belt.h"
#include <stdlib.h>

const int SLOT_FILE_SIZE = 400;
const int SLOT_SIZE = 80;

const int NUM_SLOTS = 8;

CCLayerColor *headerLayer;
CCLabelTTF *scoreLabel;
CCLabelTTF *multiplierLabel;
CCLabelTTF *missLabel;

CCLayerColor *centerLayer;
Belt * belt;
CCLayer *slotLayer;

const int BELT_SPEED_INC = 5;
const int BELT_SPEED_DEC = -200;

const int POINTS_FOR_STREAK = 1000;
int pointsSinceStreak;

int score;
int scoreMultiplier;

int streak;
const int MAX_STREAK = 5;

int missedGems;
const int MAX_MISSED_GEMS = 5;

ccTime streakDelay;

// GameLayer implementation
@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if(self=[super init])
	{
		//init variables
		score = 0;
		scoreMultiplier = 1;
		streak = 0;
		missedGems = 0;
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		////////////
		// CENTER //
		////////////
		
		centerLayer = [CCLayerColor layerWithColor:ccc4(128, 128, 128, 255) width:winSize.width height:winSize.height * 0.9];
		centerLayer.position = ccp(0, 0);
		[self addChild:centerLayer];
		
		void (^onGemGrab)(Gem*, UITouch*) = ^(Gem *gem, UITouch *touch) {
			[self addChild:gem];
			CGPoint location = [self convertTouchToNodeSpace:touch];
			gem.position = location;
		};
		
		void (^onGemMove)(Gem*, UITouch*) = ^(Gem *gem, UITouch *touch) {
			CGPoint location = [self convertTouchToNodeSpace:touch];
			gem.position = location;
		};
		
		BOOL (^onGemDrop)(Gem*, UITouch*) = ^(Gem *gem, UITouch *touch) {
			CGPoint location = [self convertTouchToNodeSpace:touch];
			if(CGRectContainsPoint(centerLayer.boundingBox, location))
			{
				location = [centerLayer convertTouchToNodeSpace:touch];
				for(int i = 0; i < NUM_SLOTS; i++)
				{
					Slot *slot = [slotLayer.children objectAtIndex:i];
					if(CGRectContainsPoint(slot.boundingBox, location))
					{
						if(gem.gemCode == slot.gemCode)
						{
							score += 100 * scoreMultiplier;
							pointsSinceStreak += 100;
							//Add score based on how fast you sort
							//TODO: Dont like how this works
							//score += 50 + 10 * [selGem.spawnTime timeIntervalSinceNow];
							scoreLabel.string = [NSString stringWithFormat:@"%d", score];
							
							streak++;
							if(streak >= MAX_STREAK)
							{
								streak = 0;
								scoreMultiplier++;
								multiplierLabel.string = [NSString stringWithFormat:@"x%d", scoreMultiplier];
							}
							
							[belt updateBeltSpeed:BELT_SPEED_INC];
							
							return YES;
						}
					}
				}
			}
			
			[self gemMissed:gem];
			
			return NO;
		};
		
		void (^onGemMissed)(Gem*) = ^(Gem *gem) {
			[self gemMissed:gem];
		};
		
		void (^onPowerUp)(int) = ^(int powerUp) {
			switch (powerUp) {
				case 0:
					missedGems = 0;
					missLabel.string = @"";
					break;
				case 1:
					score += 1000;
					scoreLabel.string = [NSString stringWithFormat:@"%d", score];
					break;
				case 2:
					[belt updateBeltSpeed:BELT_SPEED_DEC];
					break;
				default:
					break;
			}
		};
		
		//belt
		belt = [Belt beltWithHeight:centerLayer.contentSize.height];
		[centerLayer addChild:belt];
		belt.position = ccp(winSize.width / 2, 0);
		belt.onGemGrab = onGemGrab;
		belt.onGemMove = onGemMove;
		belt.onGemDrop = onGemDrop;
		belt.onGemMissed = onGemMissed;
		belt.onPowerUp = onPowerUp;
		
		slotLayer = [CCLayer node];
		[centerLayer addChild:slotLayer];
		
		int quarterScreenX = centerLayer.contentSize.width / 6;
		int threeQuarterScreenX = quarterScreenX * 5;
		int quarterScreenY = centerLayer.contentSize.height / 8;
		
		CGPoint slotPositions[8] = {
			ccp(quarterScreenX, quarterScreenY),
			ccp(threeQuarterScreenX, quarterScreenY),
			ccp(quarterScreenX, 3*quarterScreenY),
			ccp(threeQuarterScreenX, 3*quarterScreenY),
			ccp(quarterScreenX, 5*quarterScreenY),
			ccp(threeQuarterScreenX, 5*quarterScreenY),
			ccp(quarterScreenX, 7*quarterScreenY),
			ccp(threeQuarterScreenX, 7*quarterScreenY),
		};
		
		for(int i = 0; i < 8; i++)
		{
			Slot *slot = [Slot spriteWithFile:@"slotbase.png"];
			slot.gemCode = i + 1;
			
			if (slot.gemCode > 6)
				slot.gemCode -= 6;
			
			slot.scale = (float)100 / 400;
			slot.position = slotPositions[i];
			[slotLayer addChild:slot];
			
			CCSprite *mask = [CCSprite spriteWithFile:[NSString stringWithFormat:@"gem_%d_mask.png", slot.gemCode]];
			mask.scale = 0.8;
			mask.anchorPoint = ccp(-0.125, -0.125);
			[slot addChild:mask];
		}
		
		////////////
		// HEADER //
		////////////
		
		headerLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255) width:winSize.width height:winSize.height * 0.1];
		headerLayer.position = ccp(0, winSize.height * 0.9);
		[self addChild:headerLayer];
		
		scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score] fontName:@"Arial" fontSize:32];
		scoreLabel.position = ccp(headerLayer.contentSize.width * 0.2, headerLayer.contentSize.height * 0.5);
		[headerLayer addChild:scoreLabel];
		
		multiplierLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%d", scoreMultiplier] fontName:@"Arial" fontSize:32];
		multiplierLabel.position = ccp(headerLayer.contentSize.width * 0.8, headerLayer.contentSize.height * 0.5);
		[headerLayer addChild:multiplierLabel];
		
		missLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
		missLabel.position = ccp(headerLayer.contentSize.width * 0.5, headerLayer.contentSize.height * 0.5);
		missLabel.color = ccc3(255, 0, 0);
		[headerLayer addChild:missLabel];
		
		// schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
		
		// enable touch
		self.isTouchEnabled = YES;
	}
	return self;
}

-(void) nextFrame:(ccTime)dt {
	
	if (pointsSinceStreak >= POINTS_FOR_STREAK) {
		streakDelay = 10;
		pointsSinceStreak = 0;
		[belt queueStreak];
	}
	
	[belt nextFrame:dt];
}

-(void) gemMissed:(Gem *)gem
{
	missedGems++;			
	if(missedGems >= MAX_MISSED_GEMS)
	{
		HighScoreRecord *highScore = [[HighScoreRecord alloc] initWithScore:[NSNumber numberWithInt:score]];
		[HighScores addNewHighScore:highScore]; 
		
		[[CCDirector sharedDirector] replaceScene:[MainLayer scene]];
	}
	
	[belt updateBeltSpeed:BELT_SPEED_DEC];
	
	streak = 0;
	scoreMultiplier = 1;
	multiplierLabel.string = [NSString stringWithFormat:@"x%d", scoreMultiplier];
	
	switch (missedGems) {
		case 1:
			missLabel.string = @"X";
			break;
		case 2:
			missLabel.string = @"XX";
			break;
		case 3:
			missLabel.string = @"XXX";
			break;
		case 4:
			missLabel.string = @"XXXX";
			break;
		default:
			break;
	}
}

-(void) dealloc
{
	// NOTE: cocos2D will automatically release all of the children
	[super dealloc];
}

@end
