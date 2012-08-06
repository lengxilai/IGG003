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
#import "IGBoxTools03.h"
#import "IGBoxTools04.h"
#import "IGBoxTools05.h"
#import "IGBoxTools06.h"
#import "IGBoxTools07.h"
#import "IGMusicUtil.h"

@class CL02;
@interface SL01 : IGLayer
{
    GameMatrixType matrixType;
    IGParticleManager *particleManager;
    BOOL isMoving;
}

-(void)showBoxs;
-(void)reloadBoxs;
-(void)showMoveBox:(MxPoint)mp;
-(void)runMoveBox:(MxPoint)mp;
-(void)runTools01:(MxPoint)mp;
-(void)runTools02:(MxPoint)mp;
-(void)runTools03:(MxPoint)mp;
-(void)runTools04:(MxPoint)mp;
-(void)runTools06:(MxPoint)mp;
@end
