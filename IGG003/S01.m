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
    
    //CL04 *cl04 = [CL04 node];
    //[scene addChild:cl04];

    // 给控制层设定游戏层
    [cl01 setSl01:sl01];
    
    staticS01 = scene;
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
}
@end
