//
//  IGGameState.m
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGGameState.h"

@implementation IGGameState
static IGGameState *staticGameState;
@synthesize m;
@synthesize m_score;
@synthesize m_time;
@synthesize m_combo;

+(IGGameState*)gameState
{
    if (staticGameState == nil) {
        staticGameState = [[IGGameState alloc] init];
        return staticGameState;
    }else {
        return staticGameState;
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *mr = [NSMutableArray arrayWithCapacity:kGameSizeRows];
        for (int i = 0; i < kGameSizeRows; i++) {
            NSMutableArray *mc = [NSMutableArray arrayWithCapacity:kGameSizeCols];
            for (int j = 0; j < kGameSizeCols; j++) {
                int bType = CCRANDOM_0_1()*kInitBoxTypeCount + 1;
                [mc addObject:[NSNumber numberWithInt:bType]];
            }
            [mr addObject:mc];
        }
        m = (NSArray*)mr;
    }
    
    // 时间初始化
    m_time = 60;
    // 分数初始化
    m_score = 0;
    // 连击数初始化
    m_combo = 0;
    return self;
}

@end
