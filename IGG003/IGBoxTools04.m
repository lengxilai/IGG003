//
//  IGBoxTools04.m
//  IGG003
//
//  Created by Ming Liu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools04.h"
#import "IGMusicUtil.h"

@implementation IGBoxTools04

#pragma mark -
#pragma mark 外部接口

// 运行道具
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *delBoxs = [self delAllBox:mp];
    NSArray *newBoxs = [super processRun:mp];
    
    SpriteBox *targetBox = (SpriteBox *)[node getChildByTag:mp.R*kBoxTagR+mp.C];
    CGPoint point = targetBox.position;
    [targetBox removeTool];
    
    // 循环删除箱子并且显示动画效果
    for (SpriteBox *box in delBoxs) {
        [self removeBoxChildForMxPoint:box];
    }
    CL02 *cl02 = [CL02 getCL02];
    [cl02 clickAddTimeTool];
    
    // 动画效果，飞到左上角
    [self showAnime:point];
    
    //增加时间音效
    [IGMusicUtil showMusciByName:@"addtime.caf"];
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:0.3*fTimeRate];
}

-(void)showAnime:(CGPoint)point
{
    IGSprite *clock = [IGSprite spriteWithSpriteFrameName:@"t4-1.png"];
    clock.position = point;
    [clock setScale:1.5];
    [node addChild:clock];
    CCMoveTo *mt = [CCMoveTo actionWithDuration:0.5 position:ccp(30,kWindowH-30)];
    CCEaseOut *ei = [CCEaseOut actionWithAction:mt rate:2.0f];
    
    CCScaleTo *st = [CCScaleTo actionWithDuration:0.5 scale:0.8];
    
    CCSpawn *sp = [CCSpawn actions:ei,st, nil];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
    [clock runAction:[CCSequence actions:sp,delCallback, nil]];
}

@end
