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
@synthesize isMusicOn;
@synthesize isSoundOn;
@synthesize m_scoreListNormal;
@synthesize m_scoreListBroken;
@synthesize m_tool_type;
@synthesize isGameCenter;
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
    
    // 分数初始化
    m_scoreListNormal = [[NSMutableArray alloc] initWithCapacity:21];
    m_scoreListBroken = [[NSMutableArray alloc] initWithCapacity:21];
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
                int bType = arc4random()%self.m_box_level + 1;
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

// 音效控制
- (void) soundContorl
{
    SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
    engin.effectsVolume = isSoundOn == YES? 1.0 : 0.0;
}

// 背景音乐控制
- (void) musicContorl
{
    SimpleAudioEngine* engin = [SimpleAudioEngine sharedEngine];
    engin.backgroundMusicVolume = isMusicOn == YES? 1.0 : 0.0;
}

// 保存游戏数据
- (void) save
{
	id tmpId = [NSNumber numberWithBool:isSoundOn];
	[self storeUserData:tmpId forKey:@"isSoundOn"];
	
	tmpId = [NSNumber numberWithBool:isMusicOn];
	[self storeUserData:tmpId forKey:@"isMusicOn"];
    
    [self storeUserData:m_scoreListNormal forKey:@"ScoreListNormal"];
    [self storeUserData:m_scoreListBroken forKey:@"ScoreListBroken"];
}

// 读取游戏数据
- (void) load
{
    id tmpId = [self getUserData:@"isSoundOn"];
	if (tmpId)
	{
		isSoundOn = [(NSNumber*)tmpId boolValue]?YES:NO;
	}
	[self soundContorl];
    
	tmpId = [self getUserData:@"isMusicOn"];
	if (tmpId)
	{
		isMusicOn = [(NSNumber*)tmpId boolValue]?YES:NO;
	}
    [self musicContorl];
    
    tmpId = [self getUserData:@"ScoreListNormal"];
	if (tmpId)
	{
		[m_scoreListNormal release];
		m_scoreListNormal = [[NSMutableArray alloc] initWithArray:(NSArray*)tmpId];
	}
    
    tmpId = [self getUserData:@"ScoreListBroken"];
	if (tmpId)
	{
		[m_scoreListBroken release];
		m_scoreListBroken = [[NSMutableArray alloc] initWithArray:(NSArray*)tmpId];
	}
}

// 添加游戏分数
- (void) insertScore:(int) score
{
    if(self.gameMode == IGGameMode1){
        [self insertScore:score scoreList:m_scoreListNormal];
    }
    if(self.gameMode == IGGameMode2){
        [self insertScore:score scoreList:m_scoreListBroken];
    }
}

// 根据游戏模式添加分数，内部用
- (void) insertScore:(int) score
		   scoreList:(NSMutableArray*)socreList 
{
	int count = [socreList count];
	int insertIdx = 0;
	
    // 游戏分数排序
	for ( ; insertIdx < count; insertIdx++)
	{
		NSNumber* curScore = [socreList objectAtIndex:insertIdx];
		if (score >= [curScore intValue])
		{
			break;
		}
	}
	
	NSNumber* num = [[NSNumber alloc] initWithInt:score];
	[socreList insertObject:num atIndex:insertIdx];
	[num release];
	// 最多显示20回的分数
	if ([socreList count] > 20)
	{
		[socreList removeLastObject];
	}	
}

// 释放player IGMusicUtil showDeleteMusicWithNumberLoops中调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player release];
}

@end
