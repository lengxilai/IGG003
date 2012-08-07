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
    currentGameLayer=Nil; //别忘了，释放内存；
    [super dealloc];
}
-(id)init
{
    if (self=[super init]) {
        
        //currentGameLayer=delegate;
        [self enterGameOverGameLayer]; //进入游戏暂停界面；
        
        IGSprite *bak = [IGSprite spriteWithFile:@"paused.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
    }
    return self;
}
//进入暂停界面
-(void)enterGameOverGameLayer
{
    [currentGameLayer onExit]; //游戏界面暂时推出场景；（游戏界面所有的动作和预约方法等都将暂停）
    
}

@end
