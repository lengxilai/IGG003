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
    GameBoxType type = CCRANDOM_0_1()*kInitBoxTypeCount + 1;
    return [SpriteBox spriteBoxWithType:type];
}

-(MxPoint)getMxPointByTag
{
    int r = self.tag / kBoxTagR;
    int c = self.tag % kBoxTagR;
    return MxPointMake(r, c);
}

-(MxPoint)setToolByType:(GameToolType)type
{
    IGSprite *toolSprite = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"t%d-1.png",type]];
    toolSprite.tag = kToolSpriteTag;
    toolSprite.position = ccp(kBoxSize/2 + (kBoxSize-kToolSize)/2,kBoxSize/2 - (kBoxSize-kToolSize)/2);
    [self addChild:toolSprite];
}

-(void)removeTool
{
    [self removeChildByTag:kToolSpriteTag cleanup:YES];
}
@end
