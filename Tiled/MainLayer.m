//
//  MainLayer.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "MainLayer.h"
#import "GameLayer.h"
#import "HighScoreLayer.h"

// MainLayer implementation
@implementation MainLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object
	MainLayer *layer = [MainLayer node];
	
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
		[self initMenu];
	}
	return self;
}

-(void) initMenu
{
	CCMenu *menu = [CCMenu menuWithItems:
					[CCMenuItemLabel 
					 itemWithLabel:[CCLabelTTF labelWithString:@"Play" fontName:@"Marker Felt" fontSize:64]
					 block:^(id sender) {
						 [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
					 }],
					[CCMenuItemLabel 
					 itemWithLabel:[CCLabelTTF labelWithString:@"High Scores" fontName:@"Marker Felt" fontSize:64]
					 block:^(id sender) {
						 [[CCDirector sharedDirector] replaceScene:[HighScoreLayer scene]];
					 }],
					nil];
	
	[menu alignItemsVertically];
	[self addChild:menu];
}

-(void) dealloc
{
	// NOTE: cocos2D will automatically release all of the children
	[super dealloc];
}

@end
