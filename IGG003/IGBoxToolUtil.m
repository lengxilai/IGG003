//
//  IGBoxToolUtil.m
//  IGG003
//
//  Created by 鹏 李 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxToolUtil.h"

@implementation IGBoxToolUtil

// 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
+(NSArray*)getNewBoxBringTool:(CCNode*) node clickPoint:(MxPoint)mp
{
    // 取得目标箱子   TODO 这个东西是不是能写个珙桐方法，或者直接传箱子，不传MxPoint
    int r = mp.R;
    int c = mp.C;
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *box = (SpriteBox *)[node getChildByTag:targetBoxTag];
    
    NSMutableArray *result = [self getNewBoxNoTool:node clickPoint:mp];
    // 如果当前点击的是道具，则不产生新道具
    if(box.isTool){
        return result;
    }
    // 生成随机道具
    GameToolType tooltype = CCRANDOM_0_1()*6 + 1;
    
    SpriteBox *tempBox = [result objectAtIndex:CCRANDOM_0_1()*[result count]];
    // 将道具添加到随机新箱子上
    tempBox.isTool = YES;
    tempBox.tType = tooltype;
    
    NSLog(@" 这个位置 : %d 是道具: %d  这个位置是个: %d",tempBox.tag,tempBox.tType,tempBox.bType);
    return result;
}

// 取新箱子的算法，从IGboxbase移动过来 
+(NSArray*)getNewBoxNoTool:(CCNode*) node clickPoint:(MxPoint)mp;
{
    // 取得目标箱子   TODO 这个东西是不是能写个珙桐方法，或者直接传箱子，不传MxPoint
    int r = mp.R;
    int c = mp.C;
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *box = (SpriteBox *)[node getChildByTag:targetBoxTag];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    // 所有列
    for (int j = 0; j < kGameSizeCols; j++) {
        // 需要相减的行数
        int subRCount = 0;
        // 所有行
        for (int i = 0; i < kGameSizeRows; i++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[node getChildByTag:boxTag];
            // 如果在目标箱子周围1的范围内
            if (box.isDel) {
                // 相减行数加一
                subRCount++;
                // 继续下一次循环
                continue;
            }
            // 根据相减行数重新计算箱子位置（tag就代表位置）
            // 这里不能直接改tag，需要先用beforeTag和isBefore备份一下
            box.beforeTag = box.tag - kBoxTagR*subRCount;
            box.isBefore = YES;
            [result addObject:box];
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
            [result addObject:s];
        }
    }
    return result;
}
@end
