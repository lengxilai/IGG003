//
//  IGBoxToolUtil.h
//  IGG003
//
//  Created by 鹏 李 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpriteBox.h"
@class CL02;
@interface IGBoxToolUtil : CCNode

// 消除后生成带道具的新的箱子
// node 全部箱子
// box  点击的箱子
// 当前分数    应该在IGGameState取得
// 当前连击数   应该在IGGameState取得
+(NSArray*)getNewBoxBringTool:(CCNode*) node clickPoint:(MxPoint)mp;
// 生成不带道具的新箱子
+(NSArray*)getNewBoxNoTool:(CCNode*) node clickPoint:(MxPoint)mp;
// 概率出现
+(BOOL)probability:(int)num;
@end
