//
//  MainLayer.h
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-21.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// MainLayer
@interface MainLayer : CCLayer
{
}

// returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;

// initializes the instance
-(id) init;

// initializes the menu
-(void) initMenu;

// releases all retained objects
-(void) dealloc;

@end
