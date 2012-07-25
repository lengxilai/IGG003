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
        
        // 添加图片缓存
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"igt003_default.plist"];
        CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"igt003_default.png"];
        [self addChild:batch];
        
        // 粒子效果缓存
        particleManager = [[IGParticleManager alloc] initWithScene:self];
        [particleManager add:16 particleOfType:@"pop" atZ:1];
        [particleManager add:9 particleOfType:@"tools01" atZ:2];
        
        // 显示所有箱子
        [self showBoxs];
	}
	return self;
}

// 根据坐标删除一个箱子，在CL01中调用
-(void)runMoveBox:(MxPoint)mp
{
    IGBoxBase *t = [[IGBoxBase alloc] initForLayer:self forParticle:particleManager];
    [t run:mp];
    [t release];
}

// 运行T01道具
-(void)runTools01:(MxPoint)mp
{
    IGBoxTools01 *t01 = [[IGBoxTools01 alloc] initForLayer:self forParticle:particleManager];
    [t01 run:mp];
    [t01 release];
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
}

// 刷新所有箱子的位置，显示动画效果
-(void)reloadBoxs
{
    // 取消定时运行本方法
    [self unschedule:_cmd];
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
#pragma mark 动画相关的处理
// 动画之后删除精灵
-(void)actionEndCallback:(id)sender
{
    IGSprite *s = (IGSprite*)sender;
    [s removeFromParentAndCleanup:YES];
}

@end
