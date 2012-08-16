//
//  S01.h
//  IGT003 游戏界面
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGScene.h"
#import "SL01.h"
#import "CL03.h"
#import "CL02.h"
#import "CL01.h"
#import "CL05.h"

@interface S01 : IGScene
+(IGScene *) scene;
+(IGScene *) sceneForBroken;
+(S01*)getS01;
-(void)pauseGame;
-(void)pauseGameOver;
-(void)overGame;
-(void)overGameForMode2;
-(void)loadCL05;
@end
