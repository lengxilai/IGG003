//
//  IGBoxTools01.m
//  IGG003
//
//  Created by Ming Liu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools01.h"
#import "IGMusicUtil.h"

@implementation IGBoxTools01

#pragma mark -
#pragma mark 外部接口

// 运行T01道具
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *t01Boxs = [self delAllTools01Box:mp];
    NSArray *newBoxs = [super processRun:mp];
    int i = 0;
    float time = 0.8;
    // 循环爆炸点、删除爆炸点和周围的箱子并且显示动画效果
    for (SpriteBox *box in t01Boxs) {
        [self performSelector:@selector(removeBoxForTools01:) withObject:box afterDelay:i*time*fTimeRate];
        i++;
    }
    // 播放地雷音效
    [IGMusicUtil showDeleteMusicWithNumberLoops:@"dilei" ofType:@"caf" numberOfLoops:([t01Boxs count]-1)];
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:i*time*fTimeRate];
}

#pragma mark -
#pragma mark 内部实现

// 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
-(NSArray*)delAllTools01Box:(MxPoint)mp
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
    int r = mp.R;
    int c = mp.C;
    
    // 取得目标箱子
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *b = (SpriteBox *)[node getChildByTag:targetBoxTag];
    // 先给爆炸点箱子打标记
    [self delTool01Box:b];
    [result addObject:b];
    
    assert([b isKindOfClass:[SpriteBox class]]);
    
    for (int i = 0; i < kGameSizeRows; i++) {
        for (int j = 0; j < kGameSizeCols; j++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[node getChildByTag:boxTag];
            // 如果没有被删除并且类型一致，则作为一个爆炸点
            if (!box.isDel && box.bType == b.bType) {
                [self delTool01Box:box];
                [result addObject:box];
            }
        }
    }
    
    return result;
}

// 指定一个箱子，把箱子和它周围8个箱子标记为isDel
-(void)delTool01Box:(SpriteBox*)box
{
    box.isDel = YES;
    box.isTarget = YES;
    NSArray *LRUDBox = [self getLRUDBox:box];
    for (SpriteBox* b in LRUDBox) {
        b.isDel = YES;
    }
}

// 用炸弹消除某一个箱子
-(void)removeBoxForTools01:(SpriteBox*)box
{
    // 取得周围8个箱子进行消除
    NSArray *LRUDBox = [self getLRUDBox:box];
    for (SpriteBox* b in LRUDBox) {
        [self removeBoxChildForTools01:b];
    }
    // 然后再消除自己，isTarget代表是爆炸点
    box.isDel = YES;
    box.isTarget = YES;
    [self removeBoxChildForTools01:box];
}

// 显示Tools01时的动画效果，在IGAnimeUtil showReadyRemoveBoxAnime中使用回调调用
-(void)showPopParticleForTools01:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showTools01BoxAnime:box forBoxBase:self];
}

// 从Layer中删除箱子，在下面的removeTargetBoxForMxPoint中调用
-(void)removeBoxChildForTools01:(SpriteBox*)box
{
    // 先把box的tag设定为999,这句很重要，表明已经从矩阵中删除了箱子
    box.tag = 999;
    // 准备消除时的晃动效果
    [IGAnimeUtil showReadyTools01BoxAnime:box forBoxBase:self];
}
@end
