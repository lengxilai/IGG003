//
//  SL01.h
//  IGT003 游戏界面的一个层
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGLayer.h"
#import "IGGameState.h"
#import "SpriteBox.h"
#import "IGParticleManager.h"
#import "IGAnimeUtil.h"
#import "IGBoxTools01.h"

@interface SL01 : IGLayer
{
    GameMatrixType matrixType;
//    CCParticleSystem* popParticle;
    IGParticleManager *particleManager;
}

-(void)showBoxs;
-(void)reloadBoxs;
// 消除目标点箱子的两个方法，第一个方法会调用第二个方法
-(void)removeBoxForMxPoint:(MxPoint)mp;
-(void)removeTargetBoxForMxPoint:(MxPoint)mp;
-(void)removeBoxForTools01:(SpriteBox*)box;
@end
