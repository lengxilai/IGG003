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

@interface S01 : IGScene
+(IGScene *) scene;
+(S01*)getS01;
-(void)pauseGame;
@end
