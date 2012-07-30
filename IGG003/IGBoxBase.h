//
//  IGBoxBase.h
//  IGG003 普通消除
//
//  Created by Ming Liu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGParticleManager.h"
#import "SpriteBox.h"
#import "IGBoxToolUtil.h"
#import "CL03.h"

@class IGAnimeUtil;
@interface IGBoxBase : NSObject
{
    CCNode *node;
    IGParticleManager *particleManager;
}
@property(nonatomic, retain)CCNode *node;
@property(nonatomic, retain)IGParticleManager *particleManager;

// 初始化
-(id)initForLayer:(CCNode*)sender forParticle:(IGParticleManager*)pm;

// 消除时的共通处理，同时返回新的箱子
-(NSArray*)processRun:(MxPoint)mp;

// 普通消除
-(void)run:(MxPoint)mp;

// 取得一个箱子周围的8个箱子（不包括自己）
-(NSArray*)getLRUDBox:(SpriteBox*)box;

// 重新刷新箱子矩阵
-(void)reload:(NSArray*)newBoxs;

// 普通消除的十字消除
-(void)removeBoxChildForMxPoint:(SpriteBox*)box;
@end
