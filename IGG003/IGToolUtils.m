//
//  IGToolUtils.m
//  IGG003
//
//  Created by 鹏 李 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGToolUtils.h"

@implementation IGToolUtils

@synthesize m_SL01;

// 用炸弹消除某一个箱子
-(void)removeBoxForTools01:(MxPoint)mp
{
    int r = mp.R;
    int c = mp.C;
    NSLog(@"%@ start",NSStringFromSelector(_cmd));
    
    // 取得目标箱子
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *b = (SpriteBox *)[m_SL01 getChildByTag:targetBoxTag];
    
    assert([b isKindOfClass:[SpriteBox class]]);
    
    // 所有列
    for (int j = 0; j < kGameSizeCols; j++) {
        
        // 需要相减的行数
        int subRCount = 0;
        
        // 所有行
        for (int i = 0; i < kGameSizeRows; i++) {
            // C列固定
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[self getChildByTag:boxTag];
            // 如果在目标箱子周围1的范围内
            if ((r - i)*(r - i) <= 1 && (c - j)*(c - j) <= 1) {
                if (r == i && c == j) {
                    [self removeBoxChildForTools01:box isTarget:YES];
                }else {
                    [self removeBoxChildForTools01:box isTarget:NO];
                }
                // 相减行数加一
                subRCount++;
                // 继续下一次循环
                continue;
            }
            // 根据相减行数重新计算箱子位置（tag就代表位置）
            box.tag = box.tag - kBoxTagR*subRCount;
        }
        // 根据相减行数，在最上面追加新的箱子
        for (int i = 0; i < subRCount; i++) {
            SpriteBox *s = [SpriteBox spriteBoxWithRandomType];
            // 添加到区域外
            s.position = ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + (kGameSizeRows + i)*kSL01OffsetY);
            // 设定tag：总行数－消去行数＋i
            s.tag = (kGameSizeRows-subRCount+i)*kBoxTagR+j;
            // 添加之后先不显示
            s.visible = NO;
            [self addChild:s];
        }
    }
    
    // 延时刷新矩阵
    [self schedule:@selector(reloadBoxs) interval:0.3*fTimeRate];
}

@end
