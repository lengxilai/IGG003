//
//  SL01.m
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SL01.h"

@implementation SL01

- (void) dealloc
{
	[super dealloc];
    [particleManager release];
}

#pragma mark -
#pragma mark 外部接口
-(id) init
{
	if( (self=[super init])) {
        
        // 添加图片缓存
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"igt003_default.plist"];
        CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"igt003_default.png"];
        [self addChild:batch];
        
        // 粒子效果缓存
        particleManager = [[IGParticleManager alloc] initWithScene:self];
        [particleManager add:16 particleOfType:@"pop" atZ:1];
        
        // 显示所有箱子
        [self showBoxs];
	}
	return self;
}

// 根据坐标删除一个箱子，在CL01中调用
-(void)removeBoxForMxPoint:(MxPoint)mp
{
    
    // 计算十字线上相同的箱子一起消除
    [self removeTargetBoxForMxPoint:mp];
    
    // 延时刷新矩阵
    [self schedule:@selector(reloadBoxs) interval:0.3*fTimeRate];
}

#pragma mark -
#pragma mark 关于矩阵的处理

// 显示所有箱子
-(void)showBoxs
{
    NSLog(@"%@ start",NSStringFromSelector(_cmd));
    // 取得游戏状态中的矩阵
    IGGameState *gs = [IGGameState gameState];
    NSArray *m = gs.m;
    
    for (int i = 0; i < kGameSizeRows; i++) {
        NSArray *mr = (NSArray*)[m objectAtIndex:i];
        for (int j = 0; j < kGameSizeCols; j++) {
            GameBoxType type = [(NSNumber*)[mr objectAtIndex:j] intValue];
            SpriteBox *s = [SpriteBox spriteBoxWithType:type];
            s.position = ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY);
            s.tag = i*kBoxTagR+j;
            [self addChild:s];
        }
    }
}

// 刷新所有箱子的位置，显示动画效果
-(void)reloadBoxs
{
    // 取消定时运行本方法
    [self unschedule:_cmd];
    NSLog(@"%@ start",NSStringFromSelector(_cmd));
    for (int i = 0; i < kGameSizeRows; i++) {
        for (int j = 0; j < kGameSizeCols; j++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[self getChildByTag:boxTag];
            CGPoint point = box.position;
            // 让其显示，刚添加的时候是不显示的
            box.visible = YES;
            
            // 如果坐标与当前在矩阵中的位置不符
            if (!CGPointEqualToPoint(point, ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY))) {
                float moveTime = fTimeMoveto*(point.y - kSL01StartY - i*kSL01OffsetY)/kSL01OffsetY;
                // fTimeMoveto时间内移动到矩阵中位置对应的坐标
                CCMoveTo *moveTo = [CCMoveTo actionWithDuration:moveTime position:ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY)];
                [box runAction:moveTo];
            }
        }
    }
}

#pragma mark -
#pragma mark 关于箱子的处理

// 显示消除箱子时的动画效果，在IGAnimeUtil showReadyRemoveBoxAnime中使用回调调用
-(void)showPopParticle:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showRemoveBoxAnime:box forLayer:self forParticleManager:particleManager];
}

// 从Layer中删除箱子，在下面的removeTargetBoxForMxPoint中调用
-(void)removeBoxChildForMxPoint:(SpriteBox*)box
{
    // 先把box的tag设定为0,这句很重要，表明已经从矩阵中删除了箱子
    box.tag = 0;
    // // 准备消除时的晃动效果
    [IGAnimeUtil showReadyRemoveBoxAnime:box forLayer:self];
}

// 计算十字线上相同的箱子一起消除
-(void)removeTargetBoxForMxPoint:(MxPoint)mp
{
    int r = mp.R;
    int c = mp.C;
    NSLog(@"%@ start",NSStringFromSelector(_cmd));
    
    // 取得目标箱子
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *b = (SpriteBox *)[self getChildByTag:targetBoxTag];
    
    // 目标箱子的类型
    GameBoxType targetBoxType = b.bType;
    
    assert([b isKindOfClass:[SpriteBox class]]);
    
    // 先计算该列的所有行
    // 需要相减的行数
    int subRCount = 0;
    // 所有行的c列
    for (int i = 0; i < kGameSizeRows; i++) {
        // C列固定
        int boxTag = i*kBoxTagR+c;
        // 取得相应位置的箱子
        SpriteBox *box = (SpriteBox *)[self getChildByTag:boxTag];
        // 取得箱子类型
        GameBoxType boxType = box.bType;
        // 与目标箱子的类型相同
        if (boxType == targetBoxType) {
            [self removeBoxChildForMxPoint:box];
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
        s.position = ccp(kSL01StartX + c*kSL01OffsetX,kSL01StartY + (kGameSizeRows + i)*kSL01OffsetY);
        // 设定tag：总行数－消去行数＋i
        s.tag = (kGameSizeRows-subRCount+i)*kBoxTagR+c;
        // 添加之后先不显示
        s.visible = NO;
        [self addChild:s];
    }
    
    // 计算所有列
    for (int j = 0; j < kGameSizeCols; j++) {
        if (j == c) {
            continue;
        }
        // R行固定
        int boxTag = r*kBoxTagR+j;
        // 取得相应位置的箱子
        SpriteBox *box = (SpriteBox *)[self getChildByTag:boxTag];
        // 取得箱子类型
        GameBoxType boxType = box.bType;
        // 与目标箱子的类型相同
        if (boxType == targetBoxType) {
            [self removeBoxChildForMxPoint:box];
            // 循环r行以上的行
            for (int i = r + 1; i < kGameSizeRows; i++) {
                int afterTag = i*kBoxTagR + j;
                // 取得相应位置的箱子
                SpriteBox *afterBox = (SpriteBox *)[self getChildByTag:afterTag];
                // 把相应箱子的tag值减一行
                afterBox.tag = afterTag - kBoxTagR;
            }
            // 在最上面的区域外添加一个新的箱子
            SpriteBox *s = [SpriteBox spriteBoxWithRandomType];
            // 添加到区域外
            s.position = ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + kGameSizeRows*kSL01OffsetY);
            s.tag = (kGameSizeRows-1)*kBoxTagR+j;
            // 添加之后先不显示
            s.visible = NO;
            [self addChild:s];
        }
    }
}

#pragma mark -
#pragma mark 动画相关的处理
// 动画之后删除精灵
-(void)actionEndCallback:(id)sender
{
    IGSprite *s = (IGSprite*)sender;
    [s removeFromParentAndCleanup:YES];
}

@end
