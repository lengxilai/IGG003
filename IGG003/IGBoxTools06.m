//
//  IGBoxTools06.m
//  IGG003
//
//  Created by Ming Liu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools06.h"

@implementation IGBoxTools06

#pragma mark -
#pragma mark 外部接口

// 运行道具
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *delBoxs = [self delAllBox:mp];
    // 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
    NSArray *newBoxs = [self getNewBox];
    // 循环删除箱子并且显示动画效果
    for (SpriteBox *box in delBoxs) {
        [self removeBoxChildForMxPoint:box];
    }
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:0.3*fTimeRate];
}

#pragma mark -
#pragma mark 内部实现

// 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
-(NSArray*)delAllBox:(MxPoint)mp
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
    int r = mp.R;
    int c = mp.C;
    
    // 取得目标箱子
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *box = (SpriteBox *)[node getChildByTag:targetBoxTag];
    box.isDel = YES;
    [result addObject:box];
    NSArray *LRUDBox = [self getLRUDBox:box];
    for (SpriteBox* b in LRUDBox) {
        b.isDel = YES;
        [result addObject:b];
    }
    return result;
}

@end
