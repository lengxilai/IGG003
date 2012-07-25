//
//  IGBoxBase.m
//  IGG003
//
//  Created by Ming Liu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxBase.h"

@implementation IGBoxBase
@synthesize node;
@synthesize particleManager;

- (void) dealloc
{
	[super dealloc];
    [self.node release];
    [self.particleManager release];
}

-(id)initForLayer:(CCNode*)sender forParticle:(IGParticleManager*)pm
{
    self = [super init];
    if (self) {
        self.node = sender;
        self.particleManager = pm;
    }
    return self;
}

// 运行普通消除
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *t01Boxs = [self delAllBox:mp];
    // 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
    NSArray *newBoxs = [self getNewBox];

    // 循环删除箱子并且显示动画效果
    for (SpriteBox *box in t01Boxs) {
        [self removeBoxChildForMxPoint:box];
    }
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:0.3*fTimeRate];
}

// 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
-(NSArray*)delAllBox:(MxPoint)mp
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
    int r = mp.R;
    int c = mp.C;
    
    // 取得目标箱子
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *b = (SpriteBox *)[node getChildByTag:targetBoxTag];
    
    assert([b isKindOfClass:[SpriteBox class]]);
    
    for (int i = 0; i < kGameSizeRows; i++) {
        for (int j = 0; j < kGameSizeCols; j++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[node getChildByTag:boxTag];
            // 如果没有被删除并且类型一致
            if (!box.isDel && box.bType == b.bType && 
                    (box.tag/kBoxTagR == r || box.tag%kBoxTagR == c)) {
                box.isDel = YES;
                [result addObject:box];
            }
        }
    }
    
    return result;
}

// 重新刷新箱子矩阵
-(void)reload:(NSArray*)newBoxs
{
    for (SpriteBox *newBox in newBoxs) {
        // 如果不是新建但是要移动位置，则去beforeTag设定为当前tag
        if (newBox.isBefore) {
            newBox.tag = newBox.beforeTag;
            newBox.isBefore = NO;
        }else {
            [node addChild:newBox];
        }
    }
    // 延时刷新矩阵
    [node schedule:@selector(reloadBoxs) interval:0.1];
}

// 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
-(NSArray*)getNewBox
{
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

// 取得一个箱子周围的8个箱子（不包括自己）
-(NSArray*)getLRUDBox:(SpriteBox*)box
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:8];
    { 
        // 左上
        int tag = box.tag-1+kBoxTagR;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 上
        int tag = box.tag+kBoxTagR;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 右上
        int tag = box.tag+1+kBoxTagR;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 左
        int tag = box.tag-1;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 右
        int tag = box.tag+1;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 左下
        int tag = box.tag-1-kBoxTagR;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 下
        int tag = box.tag-kBoxTagR;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    { 
        // 右下
        int tag = box.tag+1-kBoxTagR;
        if (tag >= 0 && tag / kBoxTagR < kGameSizeRows && tag % kBoxTagR < kGameSizeCols){
            SpriteBox *b = (SpriteBox *)[node getChildByTag:tag];
            if (b != nil) {
                [result addObject:b];
            }
        }
    }
    return result;
}



// 显示消除箱子时的动画效果，在IGAnimeUtil showReadyRemoveBoxAnime中使用回调调用
-(void)showPopParticle:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showRemoveBoxAnime:box forBoxBase:self];
}

// 从Layer中删除箱子，在下面的removeTargetBoxForMxPoint中调用
-(void)removeBoxChildForMxPoint:(SpriteBox*)box
{
    // 先把box的tag设定为0,这句很重要，表明已经从矩阵中删除了箱子
    box.tag = 999;
    // // 准备消除时的晃动效果
    [IGAnimeUtil showReadyRemoveBoxAnime:box forBoxBase:self];
}

@end
