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
#import "IGBoxTools02.h"

@interface SL01 : IGLayer
{
    GameMatrixType matrixType;
    IGParticleManager *particleManager;
}

-(void)showBoxs;
-(void)reloadBoxs;
-(void)runMoveBox:(MxPoint)mp;
-(void)runTools01:(MxPoint)mp;
-(void)runTools02:(MxPoint)mp;
@end
