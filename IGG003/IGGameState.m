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
@synthesize isBreakBest;
@synthesize isDataSaved;
@synthesize isMusicOn;
@synthesize isSoundOn;

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
    
    // 是否有保存的游戏数据
    isDataSaved = NO;
    // 游戏音乐开启
	isMusicOn = YES;
	// 游戏音效开启
    isSoundOn = YES;
    
    [self load];
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

///////////////////

// 读取游戏数据
- (GamePlayingData*) getPlayingData
{
	return &m_playingData;
}

// 取得用户信息
- (id) getUserData:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

// 写入用户信息
- (void) storeUserData:(id)data forKey:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

// 音效音量初始化
- (CGFloat) realSoundVolume
{
	return isSoundOn == YES ? 1.0 : 0;
}

// 背景音乐音量初始化
- (CGFloat) realMusicVolume
{
	return isMusicOn == YES ? 1.0 : 0;
}

- (void) save
{
	id tmpId = [NSNumber numberWithInt:1];
	tmpId = [NSNumber numberWithBool:isSoundOn];
	[self storeUserData:tmpId forKey:@"isSoundOn"];
	
	tmpId = [NSNumber numberWithBool:isMusicOn];
	[self storeUserData:tmpId forKey:@"isMusicOn"];
}


- (void) load
{
    id tmpId = [NSNumber numberWithInt:1];
	tmpId = [self getUserData:@"isSoundOn"];
	if (tmpId)
	{
		isSoundOn = [(NSNumber*)tmpId boolValue]?YES:NO;
	}
	
	tmpId = [self getUserData:@"isMusicOn"];
	if (tmpId)
	{
		isMusicOn = [(NSNumber*)tmpId boolValue]?YES:NO;
	}
}

@end
