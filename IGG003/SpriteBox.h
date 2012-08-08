//
//  SpriteBox.h
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGSprite.h"

#define kAnimeTag 901
#define kToolAnimeTag 902

@class IGGameState;
@interface SpriteBox : IGSprite
{
    GameBoxType bType;
    BOOL isTarget;
    BOOL isDel;
    int beforeTag;
    BOOL isBefore;
    // 是否是道具
    BOOL isTool;
    // 正在显示动画
    BOOL animeRunning;
    // 道具类型
    GameToolType tType;
    CCAction * toolAnime;
    // 石头次数
    int sCount;
}
@property(nonatomic)GameBoxType bType;
@property(nonatomic)BOOL isTarget;
@property(nonatomic)BOOL isDel;
@property(nonatomic)int beforeTag;
@property(nonatomic)int sCount;
@property(nonatomic)BOOL isBefore;
@property(nonatomic)BOOL isTool;
@property(nonatomic)GameToolType tType;
@property(nonatomic, retain)CCAction * toolAnime;

+(id)spriteBoxWithType:(GameBoxType)type;
+(id)spriteBoxWithRandomType;
// 碎石
-(void)upSCount;
-(MxPoint)getMxPointByTag;
-(MxPoint)setToolByType:(GameToolType)type;
-(void)removeTool;

// 运行一个动画
-(void)runAnime;
// 不停地运行动画
-(void)runAnimeForever;
-(void)stopAnimeForever;
// 在自己身上运行道具的动画
-(void)runToolAnime;
@end
