//
//  IGBoxTools07.m
//  IGG003
//
//  Created by Ming Liu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools07.h"
#import "IGMusicUtil.h"

@implementation IGBoxTools07

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
    CL02 *cl02 = [CL02 getCL02];
    // 粒子效果
    CCParticleSystemQuad *popParticle = [particleManager particleOfType:@"snow"];
    popParticle.position = ccp(kWindowW/2,kWindowH);
    [popParticle resetSystem];
    [self performSelector:@selector(stopSnow:) withObject:popParticle afterDelay:pauseTime];
    
    [cl02 clickIceTool];
    
    // 冰冻音效
    [IGMusicUtil showMusciByName:@"snowfly.caf"];
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:0.3*fTimeRate];
}

-(void)stopSnow:(id)data
{
    CCParticleSystemQuad *popParticle = data;
    [data stopSystem];
}
@end
