//
//  SpriteBox.m
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpriteBox.h"

@implementation SpriteBox
@synthesize bType;
@synthesize isTarget;
@synthesize isDel;
@synthesize isBefore;
@synthesize beforeTag;
@synthesize isTool;
@synthesize tType;

+(id)spriteBoxWithType:(GameBoxType)type
{
    SpriteBox* box = [SpriteBox spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",type]];
    box.bType = type;
    box.isDel = NO;
    box.isTarget = NO;
    box.isBefore = NO;
    box.isTool = NO;
    box.tType = toolsNO;
    return box;
}
+(id)spriteBoxWithRandomType
{
    GameBoxType type = CCRANDOM_0_1()*7 + 1;
    return [SpriteBox spriteBoxWithType:type];
}

-(MxPoint)getMxPointByTag
{
    int r = self.tag / kBoxTagR;
    int c = self.tag % kBoxTagR;
    return MxPointMake(r, c);
}
@end
