//
//  CL05.m
//  IGG003
//
//  Created by wang chong on 12-8-7.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL05.h"

@implementation CL05
-(void)dealloc
{
    [super dealloc];
}
-(id)init
{
    if (self=[super init]) {
        
        [self enterGameOverGameLayer]; //所有动作停止；
        //加载游戏终了背景图片
        IGSprite *bak = [IGSprite spriteWithFile:@"paused.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
    }
    return self;
}
//进入暂停界面
-(void)enterGameOverGameLayer
{
    
}

@end
