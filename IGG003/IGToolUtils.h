//
//  IGToolUtils.h
//  IGG003
//
//  Created by 鹏 李 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGLayer.h"
#import "IGGameState.h"
#import "SpriteBox.h"
#import "IGParticleManager.h"
#import "IGAnimeUtil.h"
#import "SL01.h"

@interface IGToolUtils : NSObject{
    // 消除界面
    SL01*	m_SL01;
}
@property (nonatomic, retain)	SL01* m_SL01;

// 地雷
-(void)removeBoxForTools01:(MxPoint)mp;

// 欢乐时光
+(void)removeBoxForTools02:(MxPoint)mp;

// 十字斩
+(void)removeBoxForTools03:(MxPoint)mp;

// 增加时间
+(void)removeBoxForTools04:(MxPoint)mp;

// 炸弹
+(void)removeBoxForTools04:(MxPoint)mp;

// 闪电
+(void)removeBoxForTools04:(MxPoint)mp;

// 冰冻
+(void)removeBoxForTools04:(MxPoint)mp;

@end
