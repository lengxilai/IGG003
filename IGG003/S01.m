//
//  S01.m
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "S01.h"

@implementation S01
+(IGScene *) scene{
	// 'scene' is an autorelease object.
	IGScene *scene = [IGScene node];
	
	// 游戏层
	SL01 *sl01 = [SL01 node];
	[scene addChild: sl01];
    
    // 控制层
    CL01 *cl01 = [CL01 node];
    [scene addChild:cl01];
    
    CL02 *cl02 = [CL02 node];
    [scene addChild:cl02];
    // 给控制层设定游戏层
    [cl01 setSl01:sl01];
	
	return scene;
}
@end
