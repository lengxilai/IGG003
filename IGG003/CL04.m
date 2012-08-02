//
//  CL04.m
//  IGG003
//
//  Created by wang chong on 12-8-1.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL04.h"

@implementation CL04
-(id)init
{
    if (self=[super init]) {
        
        //currentGameLayer=delegate;
        [self enterGamePauseGameLayer]; //进入游戏暂停界面；
        
        IGSprite *bak = [IGSprite spriteWithFile:@"paused.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
        
        CCSprite* playNormal=[CCSprite spriteWithFile:@"resume-1.png"];
        CCSprite* playSecelt=[CCSprite spriteWithFile:@"resume-2.png"];
        playSecelt.scale=0.9f;
        
        CCMenuItemSprite* startSprite=[CCMenuItemSprite itemFromNormalSprite:playNormal selectedSprite:playSecelt target:self selector:@selector(removePauseGameLayer)];
        
        CCMenu* menu=[CCMenu menuWithItems:startSprite,nil]; //添加一个返回游戏按钮；
        menu.position=CGPointZero;
        [self addChild:menu];
        menu.position=ccp(kWindowW/2, 320);
        
    }
    return self;
}

-(void)enterGamePauseGameLayer //进入暂停界面；
{
    [currentGameLayer onExit]; //游戏界面暂时推出场景；（游戏界面所有的动作和预约方法等都将暂停）
    //[currentGameLayer addChild:self];
}

-(void)removePauseGameLayer //退出暂停界面，返回游戏；
{
    S01 *s01 = [S01 getS01];
    [s01 pauseGameOver];
    [currentGameLayer onEnter];
    [self.parent removeChild:self cleanup:YES]; //
}

-(void)dealloc
{
    currentGameLayer=Nil; //别忘了，释放内存；
    [super dealloc];
}
@end
