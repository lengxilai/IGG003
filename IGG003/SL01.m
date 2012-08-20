//
//  SL01.m
//  IGT003 Liuming
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
        
        // 粒子效果缓存
        particleManager = [[IGParticleManager alloc] initWithScene:self];
        [particleManager add:16 particleOfType:@"pop" atZ:1];
        [particleManager add:9 particleOfType:@"tools01" atZ:2];
        [particleManager add:1 particleOfType:@"snow" atZ:3];
        [particleManager add:1 particleOfType:@"heart" atZ:4];
        
        // 取得游戏状态中的矩阵
        IGGameState *gs = [IGGameState gameState];
        // 初始化游戏状态
        [gs clearGameState];
        
        // 取得保存数据
        [gs load];
        
        // 显示所有箱子
        [self showBoxs];
	}
	return self;
}

-(void)showMoveBox:(MxPoint)mp
{
    // 判断移动中的标记，如果正在移动，则不继续
    if (isMoving) {
        return;
    }
    // 如果为HappyTime，不走后面的语句
    IGGameState *gameState = [IGGameState gameState];
    if (gameState.isHappyTime) {
        return;
    }
    int targetBoxTag = mp.R*kBoxTagR+mp.C;
    SpriteBox *b = (SpriteBox *)[self getChildByTag:targetBoxTag];
    // 如果为道具则退出
    if (b.isTool) {
        return;
    }
    
    [self showNoTool:mp];
}

// 根据坐标删除一个箱子，在CL01中调用
-(void)runMoveBox:(MxPoint)mp
{
    
    // 判断移动中的标记，如果正在移动，则不继续
    if (isMoving) {
        return;
    }else {
        isMoving = YES;
    }
    
    // 如果为HappyTime，直接运行，不走后面的语句
    // 欢乐时光触发式修改 lipeng
    IGGameState *gameState = [IGGameState gameState];
    if (gameState.isHappyTime) {
        [self runTools02:mp];
        return;
    }

    // 先停止正在显示的动画
    [self clearShow];
    
    // 取得目标箱子
    int targetBoxTag = mp.R*kBoxTagR+mp.C;
    SpriteBox *b = (SpriteBox *)[self getChildByTag:targetBoxTag];
    
//    IGGameState *gameState = [IGGameState gameState];
    if (b.bType == eGbt99) {
        isMoving = NO;
        return;
    }
    
    // 调用游戏层进行消除
    switch (b.tType) {
        case toolsNO:
            // 进行普通消除
            [self runNoTool:mp];
            break;
        case tools01:
            // 进行道具01的消除
            [self runTools01:mp];
            break;
        case tools02:
            // 进行道具02的消除
            [self runTools02:mp];
            break;
        case tools03:
            // 进行道具03的消除
            [self runTools03:mp];
            break;
        case tools05:
            // 进行道具05的消除
            [self runTools05:mp];
            break;
        case tools04:
            // 进行道具04的消除
            [self runTools04:mp];
            break;
        case tools06:
            // 进行道具04的消除
            [self runTools06:mp];
            break;
        case tools07:
            // 进行道具07的消除
            [self runTools07:mp];
            break;
        default:
            // 进行普通消除
            break;
    }
}

// 停止显示箱子的效果
-(void)clearShow
{
    for (int i = 0; i < kGameSizeRows; i++) {
        for (int j = 0; j < kGameSizeCols; j++) {
            int tag = i*kBoxTagR+j;
            SpriteBox *sb = [self getChildByTag:tag];
            [sb stopAnimeForever];
        }
    }
}

// 显示没有道具消除的箱子
-(void)showNoTool:(MxPoint)mp
{
    [self clearShow];
    IGBoxBase *t = [[IGBoxBase alloc] initForLayer:self forParticle:particleManager];
    [t show:mp];
    [t release];
}

// 运行没有道具的消除
-(void)runNoTool:(MxPoint)mp
{
    IGBoxBase *t = [[IGBoxBase alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}

// 运行T01道具
-(void)runTools01:(MxPoint)mp
{
    IGBoxTools01 *t = [[IGBoxTools01 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}
// 运行T02道具
-(void)runTools02:(MxPoint)mp
{
    IGBoxTools02 *t = [[IGBoxTools02 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}
// 运行T03道具
-(void)runTools03:(MxPoint)mp
{
    IGBoxTools03 *t = [[IGBoxTools03 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}
// 运行T04道具
-(void)runTools04:(MxPoint)mp
{
    IGBoxTools04 *t = [[IGBoxTools04 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}
// 运行T05道具
-(void)runTools05:(MxPoint)mp
{
    IGBoxTools05 *t = [[IGBoxTools05 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}
// 运行T06道具
-(void)runTools06:(MxPoint)mp
{
    IGBoxTools06 *t = [[IGBoxTools06 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}
// 运行T07道具
-(void)runTools07:(MxPoint)mp
{
    IGBoxTools07 *t = [[IGBoxTools07 alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}

#pragma mark -
#pragma mark 关于矩阵的处理

// 显示所有箱子
-(void)showBoxs
{
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
    
    [self schedule:@selector(runRandomBoxAnime) interval:3];
}

// 随机显示一个水果的动作
-(void)runRandomBoxAnime
{
    int randomR = kGameSizeRows * CCRANDOM_0_1();
    int randomC = kGameSizeCols * CCRANDOM_0_1();
    int randomTag = randomR*kBoxTagR + randomC;
    SpriteBox *box = [self getChildByTag:randomTag];
    if (box != nil) {
        [box runAnime];
    }

}

// 刷新所有箱子的位置，显示动画效果
-(void)reloadBoxs
{
    // 取消定时运行本方法
    float maxMoveTime = 0;
    int sCount = 0;
    for (int i = 0; i < kGameSizeRows; i++) {
        for (int j = 0; j < kGameSizeCols; j++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[self getChildByTag:boxTag];
            CGPoint point = box.position;
            // 让其显示，刚添加的时候是不显示的
            box.visible = YES;
            // 如果是石头
            if (box.bType == eGbt99) {
                sCount ++;
            }
            
            // 如果坐标与当前在矩阵中的位置不符
            if (!CGPointEqualToPoint(point, ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY))) {
                float moveTime = 0.4;
                // fTimeMoveto时间内移动到矩阵中位置对应的坐标
                CCMoveTo *moveTo1 = [CCMoveTo actionWithDuration:moveTime-0.08 position:ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY-8)];
                CCMoveTo *moveTo2 = [CCMoveTo actionWithDuration:0.04 position:ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY+4)];
                CCMoveTo *moveTo3 = [CCMoveTo actionWithDuration:0.04 position:ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + i*kSL01OffsetY)];
                [box runAction:[CCSequence actions:moveTo1,moveTo2,moveTo3, nil]];
                if (moveTime > maxMoveTime) {
                    maxMoveTime = moveTime;
                }
            }
        }
    }
    // 取最大移动时间，更新移动中的标记
    [self performSelector:@selector(moveOver) withObject:nil afterDelay:maxMoveTime];
    
    // 更新当前石头的数量
    IGGameState *gs = [IGGameState gameState];
    gs.m_s_count = sCount;
    
    if (sCount >= kGameSizeRows*kGameSizeCols) {
        [self performSelector:@selector(overGameForMode2) withObject:nil afterDelay:2];
    }
}

-(void)overGameForMode2
{
    S01 *s01 = [S01 getS01];
    [s01 overGameForMode2];
}

#pragma mark -
#pragma mark 动画相关的处理
// 动画之后删除精灵
-(void)actionEndCallback:(id)sender
{
    IGSprite *s = (IGSprite*)sender;
    [s removeFromParentAndCleanup:YES];
}

// 更新移动中的标记
-(void)moveOver
{
    isMoving = NO;
}

@end
