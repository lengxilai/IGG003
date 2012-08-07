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
@synthesize toolAnime;

-(void)dealloc
{
    [super dealloc];
    if (toolAnime != nil) {
        [toolAnime release];
    }
}
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
    IGGameState *gameState = [IGGameState gameState];
    
    GameBoxType type = CCRANDOM_0_1()*gameState.m_box_level + 1;
//    if (gameState.m_del_count < 3) {
//        type = eGbt8;
//    }
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
    [self runToolAnime];
}

-(void)removeTool
{
    [self removeChildByTag:kToolSpriteTag cleanup:YES];
}

-(void)runAnime
{
    float time = 0.15*fTimeRate;
    CCRotateBy *rb1 = [CCRotateBy actionWithDuration:time angle:8];
    CCRotateBy *rb2 = [CCRotateBy actionWithDuration:time angle:-16];
    CCRotateBy *rb3 = [CCRotateBy actionWithDuration:time angle:16];
    CCRotateBy *rb4 = [CCRotateBy actionWithDuration:time angle:-16];
    CCRotateBy *rb5 = [CCRotateBy actionWithDuration:time angle:16];
    CCRotateBy *rb6 = [CCRotateBy actionWithDuration:time angle:-16];
    CCRotateBy *rb7 = [CCRotateBy actionWithDuration:time angle:8];
    [self runAction:[CCSequence actions:rb1,rb2,rb3,rb4,rb5,rb6,rb7,nil]];
}

-(void)runAnimeForever
{
    float time = 0.08*fTimeRate;
    CCRotateBy *rb1 = [CCRotateBy actionWithDuration:time angle:8];
    CCRotateBy *rb2 = [CCRotateBy actionWithDuration:time angle:-16];
    CCRotateBy *rb3 = [CCRotateBy actionWithDuration:time angle:16];
    CCRotateBy *rb4 = [CCRotateBy actionWithDuration:time angle:-16];
    CCRotateBy *rb5 = [CCRotateBy actionWithDuration:time angle:16];
    CCRotateBy *rb6 = [CCRotateBy actionWithDuration:time angle:-16];
    CCRotateBy *rb7 = [CCRotateBy actionWithDuration:time angle:8];
    CCRepeatForever *rf = [CCRepeatForever actionWithAction:[CCSequence actions:rb1,rb2,rb3,rb4,rb5,rb6,rb7,nil]];
    rf.tag = kAnimeTag;
    animeRunning = YES;
    [self runAction:rf];
}

-(void)stopAnimeForever
{
    if (animeRunning) {
        [self stopActionByTag:kAnimeTag];
        animeRunning = NO;
    }
}

-(void)runToolAnime
{
    int minNum = 1;
    int maxNum = 1;
    switch (self.tType) {
        case tools01:
            maxNum = 2;
            break;
        case tools02:
            maxNum = 1;
            break;
        case tools03:
            minNum = 2;
            maxNum = 3;
            break;
        case tools04:
            maxNum = 1;
            break;
        case tools05:
            maxNum = 5;
            break;
        case tools06:
            maxNum = 3;
            break;
        case tools07:
            maxNum = 1;
            break;
        default:
            break;
    }
    
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:maxNum];
    // 构造每一个帧的实际图像数据
    for (int i = minNum; i <= maxNum; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"t%d-%d.png", self.tType, i]];
        [frames addObject:frame];
    }
    
    IGSprite *tool = [self getChildByTag:kToolSpriteTag];
    
    // 冰冻效果
    if (tType == tools07) {
        CCRotateTo *rt = [CCRotateBy actionWithDuration:0.1*fTimeRate angle:10];
        CCRepeatForever *rf = [CCRepeatForever actionWithAction:rt];
        [tool runAction:rf];
    }
    // 闪电效果
    if (tType == tools06) {
        // 构造动画
        CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.1*fTimeRate]];
        CCRepeat *rt = [CCRepeat actionWithAction:animation times:3];
        
        rt.tag = kToolAnimeTag;
        [tool runAction:rt];
        
        self.toolAnime = rt;
        
        [self schedule:@selector(runToolAnimeForRandom) interval:3];
    }
    // 炸弹效果
    if (tType == tools05) {
        // 构造动画
        CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.1*fTimeRate]];
        CCRepeatForever *rt = [CCRepeatForever actionWithAction:animation];
        
        rt.tag = kToolAnimeTag;
        [tool runAction:rt];
    }
    // 增加时间 04
    
    // 十字斩效果 03
    if (tType == tools03) {
        // 构造动画
        CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.1*fTimeRate]];
        CCRepeat *rt = [CCRepeat actionWithAction:animation times:3];
        
        rt.tag = kToolAnimeTag;
        [tool runAction:rt];
        self.toolAnime = rt;
        [self schedule:@selector(runToolAnimeForRandom) interval:3];
    }
    // 欢乐时光 02
    // 地雷 01
    // 炸弹效果
    if (tType == tools05) {
        // 构造动画
        CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.1*fTimeRate]];
        CCRepeatForever *rt = [CCRepeatForever actionWithAction:animation];
        
        rt.tag = kToolAnimeTag;
        [tool runAction:rt];
    }
}

-(void)runToolAnimeForRandom
{
    [self unschedule:_cmd];
    IGSprite *tool = [self getChildByTag:kToolSpriteTag];

    CCAction *action = self.toolAnime;
    [tool runAction:action];
    [self schedule:@selector(runToolAnimeForRandom) interval:3];
}
@end
