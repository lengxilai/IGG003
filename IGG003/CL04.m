//
//  CL04.m
//  IGG003
//
//  Created by wang chong on 12-8-1.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL04.h"

@implementation CL04
-(void)dealloc
{
    [super dealloc];
}
-(id)init
{
    if (self=[super init]) {
        
        IGSprite *bak = [IGSprite spriteWithFile:@"paused.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
        
        IGSprite *title = [IGSprite spriteWithSpriteFrameName:@"paused_title.png"];
        title.position = ccp(kWindowW/2,400);
        [self addChild:title];
        
        CCSprite* resumeNormal=[CCSprite spriteWithSpriteFrameName:@"btn5-1.png"];
        CCSprite* resumeSecelt=[CCSprite spriteWithSpriteFrameName:@"btn5-2.png"];
        resumeSecelt.scale=0.95f;
        

        CCMenuItemSprite* resumeSprite=[CCMenuItemSprite itemFromNormalSprite:resumeNormal selectedSprite:resumeSecelt target:self selector:@selector(removePauseGameLayer)];
        
        CCSprite* restartNormal=[CCSprite spriteWithSpriteFrameName:@"btn6-1.png"];
        CCSprite* restartSecelt=[CCSprite spriteWithSpriteFrameName:@"btn6-2.png"];
        restartSecelt.scale=0.95f;
        
        CCMenuItemSprite* restartSprite=[CCMenuItemSprite itemFromNormalSprite:restartNormal selectedSprite:restartSecelt target:self selector:@selector(restartGame)];
        
        CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
        CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
        restartSecelt.scale=0.95f;
        
        CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
        
        CCMenu* menu=[CCMenu menuWithItems:resumeSprite,restartSprite,menuSprite,nil]; //添加一个返回游戏按钮；

        [self addChild:menu];
        menu.position=ccp(kWindowW/2, 200);
        [menu alignItemsVerticallyWithPadding:30];
        
    }
    return self;
}

-(void)restartGame
{
    IGGameState *gs = [IGGameState gameState];
    if (gs.gameMode == IGGameMode1) {
        [[CCDirector sharedDirector] replaceScene:[S01 scene]];
    }else {
        [[CCDirector sharedDirector] replaceScene:[S01 sceneForBroken]];
    }
}

-(void)gobackMenu
{
    [[CCDirector sharedDirector] replaceScene:[S00 scene:YES]];
}

-(void)removePauseGameLayer //退出暂停界面，返回游戏；
{
    S01 *s01 = [S01 getS01];
    [s01 pauseGameOver];
    [self.parent removeChild:self cleanup:YES]; //
}


@end
