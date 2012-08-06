//
//  SpriteBox.h
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGSprite.h"

@interface SpriteBox : IGSprite
{
    GameBoxType bType;
    BOOL isTarget;
    BOOL isDel;
    int beforeTag;
    BOOL isBefore;
    // 是否是道具
    BOOL isTool;
    // 道具类型
    GameToolType tType;
    
}
@property(nonatomic)GameBoxType bType;
@property(nonatomic)BOOL isTarget;
@property(nonatomic)BOOL isDel;
@property(nonatomic)int beforeTag;
@property(nonatomic)BOOL isBefore;
@property(nonatomic)BOOL isTool;
@property(nonatomic)GameToolType tType;

+(id)spriteBoxWithType:(GameBoxType)type;
+(id)spriteBoxWithRandomType;

-(MxPoint)getMxPointByTag;
-(MxPoint)setToolByType:(GameToolType)type;
-(void)removeTool;

// 运行一个动画
-(void)runAnime;
// 在自己身上运行道具的动画
-(void)runToolAnime;
@end
