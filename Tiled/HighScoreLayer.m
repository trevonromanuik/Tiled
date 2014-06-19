//
//  HighScoreLayer.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-05-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighScoreLayer.h"
#import "MainLayer.h"

@implementation HighScoreLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object
	HighScoreLayer *layer = [HighScoreLayer node];
	
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
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		int midScreenX = winSize.width / 2;
		
		NSMutableArray *highScores = [HighScores getLocalHighScores];
		if(highScores.count == 0)
		{
			CCLabelTTF *label = [CCLabelTTF labelWithString:@"No High Scores" fontName:@"Arial" fontSize:32];
			label.position = ccp(midScreenX, 400);
			[self addChild:label];
		}
		else
		{
			for(int i = 0; i < highScores.count; i++)
			{
				HighScoreRecord *highScore = [highScores objectAtIndex:i];
				CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d. %d", i + 1, [[highScore totalScore] intValue]] fontName:@"Arial" fontSize:32];
				label.position = ccp(midScreenX, winSize.height - 20 - (i * 40));
				[self addChild:label];
			}
		}
		
		CCMenu *menu = [CCMenu menuWithItems:
						[CCMenuItemLabel 
						 itemWithLabel:[CCLabelTTF labelWithString:@"Back" fontName:@"Marker Felt" fontSize:64]
						 block:^(id sender) {
							 [[CCDirector sharedDirector] replaceScene:[MainLayer scene]];
						 }],
						nil];
		
		//[menu alignItemsVertically];
		menu.position = ccp(midScreenX, 40);
		[self addChild:menu];
	}
	return self;
}

-(void) dealloc
{
	// NOTE: cocos2D will automatically release all of the children
	
	[super dealloc];
}

@end
