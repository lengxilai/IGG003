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
@synthesize m_box_level;
@synthesize isHappyTime;
@synthesize m_del_count;
@synthesize m_broken_count;
@synthesize m_s_count;
@synthesize gameMode;
@synthesize isPaused;

+(IGGameState*)gameState
{
    if (staticGameState == nil) {
        staticGameState = [[IGGameState alloc] init];
        return staticGameState;
    }else {
        return staticGameState;
    }
}

-(void)dealloc
{
    [super dealloc];
    [m release];
}

-(id)init
{
    self = [super init];
    
    return self;
}

-(void)clearGameState
{
    // 水果种类数
    self.m_box_level = kInitBoxTypeCount;
    if (self) {
        NSMutableArray *mr = [NSMutableArray arrayWithCapacity:kGameSizeRows];
        for (int i = 0; i < kGameSizeRows; i++) {
            NSMutableArray *mc = [NSMutableArray arrayWithCapacity:kGameSizeCols];
            for (int j = 0; j < kGameSizeCols; j++) {
                int bType = CCRANDOM_0_1()*self.m_box_level + 1;
                [mc addObject:[NSNumber numberWithInt:bType]];
            }
            [mr addObject:mc];
        }
        self.m = (NSArray*)mr;
    }
    
    // 时间初始化
    m_time = 60;
    // 分数初始化
    m_score = 0;
    // 连击数初始化
    m_combo = 0;
    
    isHappyTime = NO;
    
    m_del_count = 0;
    m_broken_count = 0;
    m_s_count = 0;
    isPaused = NO;
}

// 设定分数，10000,25000,50000,100000时升级
-(void)setScore:(int)score
{
    if (self.m_score <= 7500 && score > 7500) {
        [self levelUp];
    }
    if (self.m_score <= 15000 && score > 15000) {
        [self levelUp];
    }
    if (self.m_score <= 30000 && score > 30000) {
        [self levelUp];
    }
    if (self.m_score <= 100000 && score > 100000) {
        [self levelUp];
    }
    self.m_score = score;

}

-(void)levelUp
{
    if (self.m_box_level < eGbt8) {
        self.m_box_level = self.m_box_level + 1;
    }
}

@end
