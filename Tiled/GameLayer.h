//
//  GameLayer.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCExtensions.h"
#import "Gem.h"
#import "Slot.h"

//const int SLOT_FILE_SIZE = 400;
//const int SLOT_SIZE = 80;

// GameLayer
@interface GameLayer : CCLayer
{
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

// initializes the instance
-(id) init;

// updates the objects every frame
-(void) nextFrame:(ccTime)dt;

//resets everything when a gem is missed
-(void) gemMissed:(Gem *)gem;

// releases all retained objects
-(void) dealloc;

@end
