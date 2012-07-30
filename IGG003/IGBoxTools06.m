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
    NSArray *newBoxs = [super processRun:mp];
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
    box.isTarget = YES;
    [result addObject:box];
    NSArray *LRUDBox = [self getLRUDBox:box];
    for (SpriteBox* b in LRUDBox) {
        b.isDel = YES;
        [result addObject:b];
    }
    return result;
}


// 显示消除箱子时的动画效果，在IGAnimeUtil showReadyRemoveBoxAnime中使用回调调用
-(void)showPopParticle:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showTools06BoxAnime:box forBoxBase:self];
}

// 从Layer中删除箱子，在下面的removeTargetBoxForMxPoint中调用
-(void)removeBoxChildForMxPoint:(SpriteBox*)box
{
    // 先把box的tag设定为0,这句很重要，表明已经从矩阵中删除了箱子
    box.tag = 999;
    // // 准备消除时的晃动效果
    [IGAnimeUtil showReadyTools06BoxAnime:box forBoxBase:self];
    
    if (box.isTarget) {
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        NSMutableArray *frames = [[NSMutableArray array] retain];
        // 构造每一个帧的实际图像数据
        for (int i = 1; i <= 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"sd%d.png", i]];
            [frames addObject:frame];
        }
        {
            // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"sd1.png"];
            CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.05*fTimeRate]];
            // 通过回调函数删除用于显示动画效果的Sprite
            id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
            sprite.position = ccp(box.position.x+kBoxSize/2, box.position.y);
            [node addChild:sprite];
            [sprite runAction:[CCSequence actions:animation,delCallback, nil]];
        }
    }
}

@end
