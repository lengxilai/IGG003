//
//  CL01.h
//  IGT003 控制层
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGLayer.h"
#import "IGSprite.h"
#import "SpriteBox.h"
#import "CL04.h"
#import "CL02.h"

@class SL01;

@interface CL01 : IGLayer
{
    // 横向与纵向的透明指示条
    UIImageView *wBar;
    UIImageView *hBar;
    // 记忆用的，上一次选中的位置
    MxPoint mxPoint;
    // 当前控制层的状态
    GameControlType cType;
    // SL01,游戏层
    SL01* sl01;
    CL02 *cl02;
}
@property(nonatomic,retain) SL01* sl01;
@property(nonatomic,retain) CL02 *cl02;
-(MxPoint) getMxPoint:(NSSet *)touches;
-(void)showBarWithTouches:(MxPoint)mp;
@end
