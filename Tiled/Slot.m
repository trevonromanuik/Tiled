//
//  Slot.m
//  Tiled
//
//  Created by Trevon Romanuik on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Slot.h"

@implementation Slot
@synthesize gemCode;

-(id) init {
    if(self=[super init]){
        gemCode = 0;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
