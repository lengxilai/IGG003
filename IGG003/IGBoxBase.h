//
//  IGBoxBase.h
//  IGG003 普通消除
//
//  Created by Ming Liu on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGParticleManager.h"
#import "SpriteBox.h"

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

// 普通消除
-(void)run:(MxPoint)mp;

// 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
-(NSArray*)getNewBox;

// 取得一个箱子周围的8个箱子（不包括自己）
-(NSArray*)getLRUDBox:(SpriteBox*)box;

// 重新刷新箱子矩阵
-(void)reload:(NSArray*)newBoxs;

// 普通消除的十字消除
-(void)removeBoxChildForMxPoint:(SpriteBox*)box;
@end
