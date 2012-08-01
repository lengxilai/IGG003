//
//  IGBoxTools03.m
//  IGG003
//
//  Created by Ming Liu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools03.h"

@implementation IGBoxTools03

#pragma mark -
#pragma mark 外部接口

// 运行道具
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *delBoxs = [self delAllBox:mp];
    NSArray *newBoxs = [super processRun:mp];
    [self removeBoxChildForDelBoxs:delBoxs forMP:mp];
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:0.8*fTimeRate];
}

#pragma mark -
#pragma mark 内部实现

// 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
-(NSArray*)delAllBox:(MxPoint)mp
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:5];
    int r = mp.R;
    int c = mp.C;
    
    // 取得目标箱子
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *b = (SpriteBox *)[node getChildByTag:targetBoxTag];
    b.isTarget = YES;
    
    assert([b isKindOfClass:[SpriteBox class]]);
    
    for (int i = 0; i < kGameSizeRows; i++) {
        for (int j = 0; j < kGameSizeCols; j++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[node getChildByTag:boxTag];
            // 如果类型一致
            if (i == r || j == c) {
                box.isDel = YES;
                [result addObject:box];
            }
        }
    }
    
    return result;
}


// 显示消除箱子时的动画效果，在IGAnimeUtil showReadyRemoveBoxAnime中使用回调调用
-(void)showPopParticle:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showTools05BoxAnime:box forBoxBase:self];
    [box removeFromParentAndCleanup:YES];
}

-(void)showPopParticleForSprite:(SpriteBox*)sprite data:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showTools05BoxAnime:box forBoxBase:self];
}

// 从Layer中删除箱子，在下面的removeTargetBoxForMxPoint中调用
-(void)removeBoxChildForDelBoxs:(NSArray*)delBoxs forMP:(MxPoint)mp
{
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    SpriteBox *targetBox = (SpriteBox *)[node getChildByTag:mp.R*kBoxTagR+mp.C];
    MxPoint targetBoxMP = [targetBox getMxPointByTag];
    
    float maxTime = 0;
    for (SpriteBox *box in delBoxs) {
        MxPoint boxMP = [box getMxPointByTag];
        // 先把box的tag设定为0,这句很重要，表明已经从矩阵中删除了箱子
        box.tag = 999;
        
        if (box.isTarget) {
            NSMutableArray *frames = [NSMutableArray arrayWithCapacity:10];
            // 构造每一个帧的实际图像数据
            for (int i = 2; i <= 3; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"t3-%d.png", i]];
                
                [frames addObject:frame];
            }
            // 向上爬行
            {
                // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
                CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"t3-2.png"];
                [sprite setRotation:0];
                sprite.position = box.position;
                [node addChild:sprite];
                
                float moveTime = (kGameSizeRows - boxMP.R)*0.1*fTimeRate;
                if (moveTime > maxTime) {
                    maxTime = moveTime;
                }
                
                CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.02*fTimeRate]];
                [sprite runAction:[CCRepeatForever actionWithAction:animation]];
                CCMoveTo *mt = [CCMoveTo actionWithDuration:moveTime position:ccp(box.position.x,kSL01StartY + kGameSizeRows*kSL01OffsetY)];
                
                // 通过回调函数删除用于显示动画效果的Sprite
                id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
                
                [sprite runAction:[CCSequence actions:mt,delCallback, nil]];
                [self showPopParticle:box];
            }
            
            // 向下爬行
            {
                // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
                CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"t3-2.png"];
                [sprite setRotation:0];
                sprite.position = box.position;
                [node addChild:sprite];
                
                float moveTime = (boxMP.R)*0.1*fTimeRate;
                if (moveTime > maxTime) {
                    maxTime = moveTime;
                }
                
                CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.02*fTimeRate]];
                [sprite runAction:[CCRepeatForever actionWithAction:animation]];
                CCMoveTo *mt = [CCMoveTo actionWithDuration:moveTime position:ccp(box.position.x,kSL01StartY)];
                
                // 通过回调函数删除用于显示动画效果的Sprite
                id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
                
                [sprite runAction:[CCSequence actions:mt,delCallback, nil]];
                [self showPopParticle:box];
            }
            // 向左爬行
            {
                // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
                CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"t3-2.png"];
                [sprite setRotation:0];
                sprite.position = box.position;
                [node addChild:sprite];
                
                float moveTime = boxMP.C*0.1*fTimeRate;
                if (moveTime > maxTime) {
                    maxTime = moveTime;
                }
                
                CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.02*fTimeRate]];
                [sprite runAction:[CCRepeatForever actionWithAction:animation]];
                CCMoveTo *mt = [CCMoveTo actionWithDuration:moveTime position:ccp(kSL01StartX,box.position.y)];
                
                // 通过回调函数删除用于显示动画效果的Sprite
                id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
                
                [sprite runAction:[CCSequence actions:mt,delCallback, nil]];
                [self showPopParticle:box];
            }
            
            // 向右爬行
            {
                // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
                CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"t3-2.png"];
                [sprite setRotation:0];
                sprite.position = box.position;
                [node addChild:sprite];
                
                float moveTime = (kGameSizeCols - boxMP.C)*0.1*fTimeRate;
                if (moveTime > maxTime) {
                    maxTime = moveTime;
                }
                
                CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.02*fTimeRate]];
                [sprite runAction:[CCRepeatForever actionWithAction:animation]];
                CCMoveTo *mt = [CCMoveTo actionWithDuration:moveTime position:ccp(kSL01StartX+kGameSizeCols*kSL01OffsetX,box.position.y)];
                
                // 通过回调函数删除用于显示动画效果的Sprite
                id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
                
                [sprite runAction:[CCSequence actions:mt,delCallback, nil]];
                [self showPopParticle:box];
            }
        }else {
            float afterTime = 0;
            if (boxMP.R == targetBoxMP.R) {
                afterTime = abs(boxMP.C - targetBoxMP.C)*0.1*fTimeRate;
            }
            if (boxMP.C == targetBoxMP.C) {
                afterTime = abs(boxMP.R - targetBoxMP.R)*0.1*fTimeRate;
            }
            [self performSelector:@selector(showPopParticle:) withObject:box afterDelay:afterTime];
        }
    }
}
@end
