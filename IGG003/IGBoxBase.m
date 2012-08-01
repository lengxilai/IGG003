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
    [node release];
    [particleManager release];
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

// 消除时的共通处理，同时返回新的箱子
-(NSArray*)processRun:(MxPoint)mp
{
    // 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
    NSArray *newBoxs = [IGBoxToolUtil getNewBoxBringTool:node clickPoint:mp];
    
    
    int deleteNo = 0;
    // 取得元素
    CCArray* array = [node children];
    // 取得消除元素个数
    for( CCNode *child in array ) {
        // 如果不是箱子则跳过
        if (![child isKindOfClass:[SpriteBox class]]){
            continue;
        }
        if(((SpriteBox*)child).isDel){
            deleteNo ++;
        }
    }
    IGGameState *gameState = [IGGameState gameState];
    // 如果消除个数大于界限值
    if (deleteNo > kComboBoxLimit) {
        gameState.m_combo = gameState.m_combo + 1;
    }else {
        gameState.m_combo = 0;
    }
    
    CL03 *cl03 = [CL03 getCL03];
    [cl03 addPointForBoxNum:deleteNo forPoint:ccp(kSL01StartX + mp.R*kSL01OffsetX,kSL01StartY + mp.C*kSL01OffsetY)];
    
    return newBoxs;
}

// 运行普通消除
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *delBoxs = [self delAllBox:mp];
    NSArray *newBoxs = [self processRun:mp];

    // 循环删除箱子并且显示动画效果
    for (SpriteBox *box in delBoxs) {
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
            NSLog(@"change before box : %d",newBox.tag);
        }else {
            [node addChild:newBox];
            NSLog(@"add new box : %d",newBox.tag);
        }
    }
    // 延时刷新矩阵
    [node schedule:@selector(reloadBoxs) interval:0.1];
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
