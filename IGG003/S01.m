//
//  S01.m
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "S01.h"
static S01 *staticS01;
@implementation S01
+(IGScene *) scene{
    // 背景音乐
    int musicId = CCRANDOM_0_1()*3;
    NSString *musicName = [NSString stringWithFormat:@"bg_music%d.caf", musicId];
    [IGMusicUtil showBackgroundMusic:musicName];

	// 'scene' is an autorelease object.
	IGScene *scene = [S01 node];
    
    IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [scene addChild:bak];
    
	// 游戏层
	SL01 *sl01 = [SL01 node];
	[scene addChild: sl01];
    [sl01 setTag:1001];
    
    // 控制层
    CL01 *cl01 = [CL01 node];
    [scene addChild:cl01];
    [cl01 setTag:10011];
    
    // 分数
    CL03 *cl03 = [CL03 node];
    [scene addChild:cl03];
    [cl03 setTag:10013];
    
    CL02 *cl02 = [CL02 node];
    [scene addChild:cl02];
    [cl02 setTag:10012];

    // 给控制层设定游戏层
    cl01.sl01 = sl01;
    
    staticS01 = scene;
    
    // 普通模式
    IGGameState *gs = [IGGameState gameState];
    gs.gameMode = IGGameMode1;
	return scene;
}


+(IGScene *) sceneForBroken{
    // 背景音乐
    int musicId = CCRANDOM_0_1()*3;
    NSString *musicName = [NSString stringWithFormat:@"bg_music%d.caf", musicId];
    [IGMusicUtil showBackgroundMusic:musicName];
    
	// 'scene' is an autorelease object.
	IGScene *scene = [S01 node];
    
    IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [scene addChild:bak];
    
	// 游戏层
	SL01 *sl01 = [SL01 node];
	[scene addChild: sl01];
    [sl01 setTag:1001];
    
    // 控制层
    CL01 *cl01 = [CL01 node];
    [scene addChild:cl01];
    [cl01 setTag:10011];
    
    // 分数
    CL03 *cl03 = [CL03 node];
    [scene addChild:cl03];
    [cl03 setTag:10013];
    
    CL02 *cl02 = [CL02 node];
    [scene addChild:cl02];
    [cl02 setTag:10012];
    // 不显示计时
    cl02.visible = NO;
    
    // 给控制层设定游戏层
    cl01.sl01 = sl01;
    
    staticS01 = scene;
    
    // 碎石模式
    IGGameState *gs = [IGGameState gameState];
    gs.gameMode = IGGameMode2;
    
	return scene;
}

+(S01*)getS01
{
    if (staticS01 == nil) {
        staticS01 = [S01 node];
        return staticS01;
    }else {
        return staticS01;
    }
}
-(void)pauseGame{
    CL01 *cl01 = (CL01 *)[staticS01 getChildByTag:10011];
    CL02 *cl02 = (CL02 *)[staticS01 getChildByTag:10012];
    CL03 *cl03 = (CL03 *)[staticS01 getChildByTag:10013];
    [cl01 onExit];
    [cl02 onExit];
    [cl03 onExit];
    
    CL04 *cl04 = [CL04 node];
    [staticS01 addChild:cl04];
}

-(void)pauseGameOver{
    CL01 *cl01 = (CL01 *)[staticS01 getChildByTag:10011];
    CL02 *cl02 = (CL02 *)[staticS01 getChildByTag:10012];
    CL03 *cl03 = (CL03 *)[staticS01 getChildByTag:10013];
    [cl01 onEnter];
    [cl02 onEnter];
    [cl02 endPause];
    [cl03 onEnter];
}
-(void)overGame{
    
    IGGameState *gs = [IGGameState gameState];
    if (gs.gameMode == IGGameMode1) {
        CL01 *cl01 = (CL01 *)[staticS01 getChildByTag:10011];
        CL02 *cl02 = (CL02 *)[staticS01 getChildByTag:10012];
        
        [cl01 onExit];
        [cl02 onExit];
        
        [self readyForGameOver];
        
        [self performSelector:@selector(loadCL05) withObject:Nil afterDelay:1];
        
    }
}
-(void)loadCL05{
    CL05 *cl05 = [CL05 node];
    CL03 *cl03 = (CL03 *)[staticS01 getChildByTag:10013];
    [cl03 onExit];
    [staticS01 addChild:cl05];
}

-(void)readyForGameOver
{
    // 
    CCLabelBMFont *ccPoint = [(CL03 *)[staticS01 getChildByTag:10013] getChildByTag:200003];
    if(ccPoint != nil){
        [ccPoint removeFromParentAndCleanup:YES];
    }
    
    SL01 *sl01 = [self getChildByTag:1001];
    CCScaleTo *st = [CCScaleTo actionWithDuration:0.8 scale:0];
    CCRotateBy *rb = [CCRotateBy actionWithDuration:0.8 angle:300];
    CCSpawn *spawn = [CCSpawn actions:st,rb, nil];
    [sl01 runAction:spawn];
}

-(void)overGameForMode2
{
    CL01 *cl01 = (CL01 *)[staticS01 getChildByTag:10011];
    
    [cl01 onExit];
    [self readyForGameOver];
    [self performSelector:@selector(loadCL05) withObject:Nil afterDelay:1];
}
@end
