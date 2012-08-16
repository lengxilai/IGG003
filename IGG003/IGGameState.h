//
//  IGGameState.h
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 游戏模式
typedef enum{
    IGGameMode1 = 1,IGGameMode2 = 2,
}IGGameMode;

// 箱子类型 苹果 橙子 柠檬 西瓜 菠萝 草莓 香蕉 葡萄 石头
typedef enum{
    eGbt0 = 0,eGbt1 = 1,eGbt2 = 2,eGbt3 = 3,eGbt4 = 4,eGbt5 = 5,eGbt6 = 6,eGbt7 = 7,eGbt8 = 8,eGbt99 = 99,
} GameBoxType;

// 道具类型 地雷  欢乐时光  十字斩 增加时间 炸弹  闪电  冰冻         
typedef enum{
    toolsNO = 0,tools01 = 1,tools02 = 2,tools03 = 3,tools04 = 4,tools05 = 5,tools06 = 6,tools07 = 7,
} GameToolType;

// 矩阵的状态
typedef enum{
    eGMoving,egNothing,
} GameMatrixType;

// 控制层的状态
typedef enum{
    eCNothing,eCSelected,
} GameControlType;

// 矩阵中的点
struct MxPoint{
    int R;
    int C;
};
typedef struct MxPoint MxPoint;
CG_INLINE MxPoint 
MxPointMake(int r, int c)
{
    MxPoint p; p.R = r; p.C = c; return p;
};

@interface IGGameState : NSObject
{
    NSArray *m;
    // 当前分数
    int				m_score;
    // 当前游戏时间
    int             m_time;
    // 当前连击数
    int             m_combo;
    
    BOOL isHappyTime;
    
    // 水果种类数
    int m_box_level;
    
    // 上一次消除的数量
    int m_del_count;
    
    // 上一次消除的石头数量
    int m_broken_count;
    
    // 游戏模式
    IGGameMode gameMode; 
    
    // 当前石头的数量
    int m_s_count;
    BOOL isPaused;

    // 是否破纪录
    BOOL isBreakBest;
}
@property(nonatomic,retain) NSArray *m;
@property(nonatomic,assign) int m_score;
@property(nonatomic,assign) int m_time;
@property(nonatomic,assign) int m_combo;
@property(nonatomic,assign) int m_box_level;
@property(nonatomic,assign) int m_del_count;
@property(nonatomic,assign) int m_broken_count;
@property(nonatomic,assign) int m_s_count;
@property(nonatomic,assign) IGGameMode gameMode;
@property(nonatomic,assign) BOOL isHappyTime;
@property(nonatomic,assign) BOOL isPaused;
@property(nonatomic,assign) BOOL isBreakBest;

+(IGGameState*)gameState;
-(id)init;
// 升级，水果数量增加
-(void)levelUp;
// 设定分数
-(void)setScore:(int)score;
-(void)clearGameState;
@end
