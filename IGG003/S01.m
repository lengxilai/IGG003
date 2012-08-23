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

	// 'scene' is an autorelease object.
	IGScene *scene = [S01 node];
    
    IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [scene addChild:bak];
    [scene showReady];
    
	// 游戏层
    [scene performSelector:@selector(gameStart) withObject:Nil afterDelay:1.1];
    staticS01 = scene;
    
    // ready go之后播放背景音乐
    [scene performSelector:@selector(showBackMusic) withObject:nil afterDelay:1.1];
    // 水果掉落音效
    [scene performSelector:@selector(showDropMusic) withObject:nil afterDelay:1.4];

    // 普通模式
    IGGameState *gs = [IGGameState gameState];
    gs.gameMode = IGGameMode1;
	return scene;
}


+(IGScene *) sceneForBroken{
    
	// 'scene' is an autorelease object.
	IGScene *scene = [S01 node];
    
    IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [scene addChild:bak];
    
    [scene showReady];
	// 游戏层
    [scene performSelector:@selector(gameStartForBroken) withObject:Nil afterDelay:1.1];
    
    staticS01 = scene;

    // ready go之后播放背景音乐
    [scene performSelector:@selector(showBreakBackMusic) withObject:nil afterDelay:1.1];
    // 水果掉落音效
    [scene performSelector:@selector(showDropMusic) withObject:nil afterDelay:1.4];

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
        
        // 时间停止音效
        [self performSelector:@selector(readyForGameOver) withObject:nil afterDelay:1.8];

        [self performSelector:@selector(loadCL05) withObject:Nil afterDelay:2.8];
        
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
    // 结束时候显示的分数小时，对应右上角显示分数问题
    CCLabelBMFont *ccPoint = [(CL03 *)[staticS01 getChildByTag:10013] getChildByTag:200003];
    if(ccPoint != nil){
        [ccPoint removeFromParentAndCleanup:YES];
    }
    
    // 游戏结束时候将透明条隐藏
    CL01 * cl01 = (CL01 *)[staticS01 getChildByTag:10011];
    if (cl01!=nil) {
        [cl01 hiddenBar];
    }
    
    SL01 *sl01 = [self getChildByTag:1001];
    CCScaleTo *st = [CCScaleTo actionWithDuration:0.8 scale:0];
    CCRotateBy *rb = [CCRotateBy actionWithDuration:0.8 angle:300];
    CCSpawn *spawn = [CCSpawn actions:st,rb, nil];
    [IGMusicUtil showMusciByName:@"xuanzhuan.caf"];
    [sl01 runAction:spawn];
}

-(void)overGameForMode2
{
    CL01 *cl01 = (CL01 *)[staticS01 getChildByTag:10011];
    
    [cl01 onExit];
    [self readyForGameOver];
    [self performSelector:@selector(loadCL05) withObject:Nil afterDelay:1];
}
-(void)showReady{
    CCSprite *readyImg = [CCSprite spriteWithSpriteFrameName:@"ready.png"];
    id readyac0 = [readyImg runAction:[CCPlace actionWithPosition:ccp(kWindowW/2,kWindowH/2)]]; 
    [IGMusicUtil showMusciByName:@"ready_go.caf"];
    id readyac1 = [CCScaleBy actionWithDuration:0.3 scaleX:3.0f scaleY:3.0f];  
    id readyac2 = [CCFadeOut actionWithDuration:0.3];
    [readyImg runAction:[CCSequence actions:readyac0, readyac1, readyac2, nil]]; 
    [self addChild:readyImg];
    //调用显示GO
    [self performSelector:@selector(showGo) withObject:Nil afterDelay:0.6];
    
}
-(void)showGo{
    CCSprite *goImg = [CCSprite spriteWithSpriteFrameName:@"go.png"];
    [self addChild:goImg];
    id goac0 = [goImg runAction:[CCPlace actionWithPosition:ccp(kWindowW/2,kWindowH/2)]]; 
    id goac1 = [CCScaleBy actionWithDuration:0.3 scaleX:3.0f scaleY:3.0f];  
    id goac2 = [CCFadeOut actionWithDuration:0.1];
    [goImg runAction:[CCSequence actions:goac0, goac1, goac2, nil]]; 
}
-(void)gameStart{
    SL01 *sl01 = [SL01 node];
    [staticS01 addChild: sl01];
    [sl01 setTag:1001];

    // 控制层
    CL01 *cl01 = [CL01 node];
    [staticS01 addChild:cl01];
    [cl01 setTag:10011];

    // 分数
    CL03 *cl03 = [CL03 node];
    [staticS01 addChild:cl03];
    [cl03 setTag:10013];

    CL02 *cl02 = [CL02 node];
    [staticS01 addChild:cl02];
    [cl02 setTag:10012];

    // 给控制层设定游戏层
    cl01.sl01 = sl01;
}
-(void)gameStartForBroken{
    SL01 *sl01 = [SL01 node];
	[staticS01 addChild: sl01];
    [sl01 setTag:1001];
    
    // 控制层
    CL01 *cl01 = [CL01 node];
    [staticS01 addChild:cl01];
    [cl01 setTag:10011];
    
    // 分数
    CL03 *cl03 = [CL03 node];
    [staticS01 addChild:cl03];
    [cl03 setTag:10013];
    
    CL02 *cl02 = [CL02 node];
    [staticS01 addChild:cl02];
    [cl02 setTag:10012];
    // 不显示计时
    cl02.visible = NO;
    
    // 给控制层设定游戏层
    cl01.sl01 = sl01;
}
// 游戏背景音乐
-(void)showBackMusic {
    // 背景音乐
    int musicId = arc4random()%3;
    NSString *musicName = [NSString stringWithFormat:@"bg_music%d.caf", musicId];
    [IGMusicUtil showBackgroundMusic:musicName]; 
}
// break游戏背景音乐
-(void)showBreakBackMusic {
    // 背景音乐
    [IGMusicUtil showBackgroundMusic:@"bg_music4.m4a"]; 
}
// 开始掉落水果音效
-(void)showDropMusic {
    [IGMusicUtil showMusciByName:@"drop.caf"];
}
@end
