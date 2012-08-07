//
//  CL01.m
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CL01.h"

@implementation CL01
@synthesize sl01;

- (void) dealloc
{
	[super dealloc];
    [wBar removeFromSuperview];
    [hBar removeFromSuperview];
    [wBar release];
    [hBar release];
    //[sl01 release];
}

-(id) init
{
	if( (self=[super init])) {
        // 接受用户操作
        self.isTouchEnabled = YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize]; 
        
        // 初始化透明指示条,2和6就是一个调节偏差，没有实际意义
        wBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedbar.png"]];
        hBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectedbar.png"]];
        wBar.frame = CGRectMake(kSL01StartX - kBoxSize/2-2, size.height - kSL01StartY, kSL01OffsetX*kGameSizeCols, wBar.frame.size.height);
        hBar.frame = CGRectMake(kSL01StartX, size.height - kSL01StartY-8*kSL01OffsetY+kBoxSize/2+6, hBar.frame.size.width, kSL01OffsetY*kGameSizeRows-6);
        // 添加到UIView中
        [[[CCDirector sharedDirector] openGLView] addSubview:wBar];
        [[[CCDirector sharedDirector] openGLView] addSubview:hBar];
        wBar.hidden = YES;
        hBar.hidden = YES;

        cType = eCNothing;
	}
	return self;
}

#pragma mark -
#pragma mark 触摸事件
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    
    // 如果状态为eCNothing，则显示透明指示条
    if (cType == eCNothing) {
        // 求出触摸点在矩阵中的位置
        MxPoint mp = [self getMxPoint:touches];
        [self showBarWithTouches:mp];
    }
    
}
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent*)event
{
    // 求出触摸点在矩阵中的位置
    MxPoint mp = [self getMxPoint:touches];
    // 设定透明指示条位置
    [self showBarWithTouches:mp];
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent*)event
{
    // 求出触摸点在矩阵中的位置
    MxPoint mp = [self getMxPoint:touches];
    // 如果选中点超出范围，则直接返回
    if (mp.R == kMxPointNone && mp.C == kMxPointNone) {
        return;
    }
    
    // 如果状态为eCNothing，则更改状态为eCSelected（第一次选中不进行消除）
    if (cType == eCNothing) {
        // 设定透明指示条位置
        [self showBarWithTouches:mp];
        // 显示本次即将删除的箱子
        [self.sl01 showMoveBox:mp];
        // 记忆当前选中点
        mxPoint = mp;
        cType = eCSelected;
    }
    // 如果状态为eCSelected
    else if (cType == eCSelected) {
        // 如果选中点没有发生变化，则进行消除
        if (mp.R == mxPoint.R && mp.C == mxPoint.C) {
            wBar.hidden = YES;
            hBar.hidden = YES;
            
            [self.sl01 runMoveBox:mp];
            cType = eCNothing;
        }else {
            // 否则不进行消除，重新设定透明指示条位置（选中点发生了变化）
            // 设定透明指示条位置
            [self showBarWithTouches:mp];
            // 显示本次即将删除的箱子
            [self.sl01 showMoveBox:mp];
            // 记忆当前选中点
            mxPoint = mp;
            cType = eCSelected;
        }
        
    }
}

#pragma mark -
#pragma mark 一些坐标计算的方法

// 触摸转换方法-把触摸转换为OpenGL坐标
-(CGPoint) glPointFromTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];    
}

// 求触摸点在矩阵中的位置
-(MxPoint) getMxPoint:(NSSet *)touches
{
    CGPoint point = [self glPointFromTouches:touches];
    
    // 求出触摸点为矩阵的行列值，floorf求不大于目标的最大整数
    int r = floorf((point.y - kSL01StartY + kBoxSize/2)/kSL01OffsetY);
    int c = floorf((point.x - kSL01StartX + kBoxSize/2)/kSL01OffsetX);
    // 如果点不在矩阵区域，则返回不存在的点
    if (r >= kGameSizeRows || c >= kGameSizeCols || r < 0 || c < 0) {
        return MxPointMake(kMxPointNone,kMxPointNone);
    }
    return MxPointMake(r,c);
}

#pragma mark -
#pragma mark 显示用的方法
-(void)showBarWithTouches:(MxPoint)mp
{
    // 如果选中点超出范围，则直接返回
    if (mp.R == kMxPointNone && mp.C == kMxPointNone) {
        return;
    }
    wBar.hidden = NO;
    hBar.hidden = NO;
    // 设定透明指示条的位置
    CGSize size = [[CCDirector sharedDirector] winSize]; 
    wBar.frame = CGRectMake(wBar.frame.origin.x, size.height - (mp.R*kSL01OffsetY+kSL01StartY + kBarSize/2), wBar.frame.size.width, wBar.frame.size.height);
    hBar.frame = CGRectMake(mp.C*kSL01OffsetX+kSL01StartX-kBarSize/2, hBar.frame.origin.y, hBar.frame.size.width, hBar.frame.size.height);
}

-(void)gamePause
{
    CL04 *cl04 = [CL04 node];
}
@end
