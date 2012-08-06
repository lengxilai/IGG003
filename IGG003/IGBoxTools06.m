//
//  IGBoxTools06.m
//  IGG003
//
//  Created by Ming Liu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools06.h"
#import "SimpleAudioEngine.h"
#import "IGMusicUtil.h"

@implementation IGBoxTools06

#pragma mark -
#pragma mark 外部接口

// 运行道具
-(void)run:(MxPoint)mp
{
    // 给所有要删除的箱子打isDel标记，并且返回爆炸点的箱子
    NSArray *delBoxs = [self delAllBox:mp];
    NSArray *newBoxs = [super processRun:mp];
    NSNumber *time = [self removeBoxChildForDelBoxs:delBoxs forMP:mp];
    
    // 延时重新刷新箱子矩阵
    [self performSelector:@selector(reload:) withObject:newBoxs afterDelay:[time floatValue]];
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
    SpriteBox *box = (SpriteBox *)[node getChildByTag:targetBoxTag];
    box.isDel = YES;
    box.isTarget = YES;
    [result addObject:box];
    NSArray *LRUDBox = [self getLRUDBox:box];
    for (SpriteBox* b in LRUDBox) {
        b.isDel = YES;
        [result addObject:b];
    }
    return result;
}


// 显示消除箱子时的动画效果，在IGAnimeUtil showReadyRemoveBoxAnime中使用回调调用
-(void)showPopParticle:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showTools06BoxAnime:box forBoxBase:self];
}

// 从Layer中删除箱子，在下面的removeTargetBoxForMxPoint中调用
-(NSNumber*)removeBoxChildForDelBoxs:(NSArray*)delBoxs forMP:(MxPoint)mp
{
    float scaleTime = 0.3*fTimeRate;
    float moveStepTime = 0.15*fTimeRate;
    float scaleRate = 1.5;
    
    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    SpriteBox *targetBox = (SpriteBox *)[node getChildByTag:mp.R*kBoxTagR+mp.C];
    // 先删除中间的蜘蛛
    [targetBox removeTool];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
    // 通过回调函数显示粒子效果
    id particleCallback = [CCCallFuncN actionWithTarget:self selector:@selector(showPopParticle:)];
    
    NSMutableArray *mtArray = [NSMutableArray arrayWithCapacity:8];
    float maxTime = 0;

    CGPoint prePoint = targetBox.position;
    int i = 0;
    for (SpriteBox *box in delBoxs) {
        // 先把box的tag设定为999,这句很重要，表明已经从矩阵中删除了箱子
        box.tag = 999;
        
        // 如果是中间点
        if (!box.isTarget) {
            
            // 通过回调函数显示粒子效果
            id particleCallback = [CCCallFuncN actionWithTarget:self selector:@selector(showPopParticle:)];
            
            CCSequence *se = [CCSequence actions:delCallback,particleCallback, nil];
            
            if (scaleTime*3 > maxTime) {
                maxTime = scaleTime*3;
            }
            
            CCRotateTo *rt;
            // 如果在同一列
            if (box.position.x == prePoint.x) {
                // 向上
                if (box.position.y > prePoint.y) {
                    rt = [CCRotateTo actionWithDuration:0 angle:0];
                }else {
                    rt = [CCRotateTo actionWithDuration:0 angle:180];
                }
            }
            // 如果在同
            if (box.position.y == prePoint.y) {
                // 向右
                if (box.position.x > prePoint.x) {
                    rt = [CCRotateTo actionWithDuration:0 angle:90];
                }else {
                    rt = [CCRotateTo actionWithDuration:0 angle:270];
                }
            }
            prePoint = box.position;
            [mtArray addObject:[CCSequence actions:rt,[CCMoveTo actionWithDuration:moveStepTime position:box.position],nil]];
            [box performSelector:@selector(runAction:) withObject:se afterDelay:i*moveStepTime];
        }
        
        i++;
    }
    
    if (moveStepTime * [mtArray count] > maxTime) {
        maxTime = moveStepTime * [mtArray count];
    }
    
    [mtArray addObject:delCallback];
    
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:2];
    // 构造每一个帧的实际图像数据
    for (int i = 1; i <= 2; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"t6-%d.png", i]];
        [frames addObject:frame];
    }
    // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"t6-1.png"];
    [sprite setRotation:0];
    sprite.position = targetBox.position;
    [node addChild:sprite];
    
    // 撒网音效
    CCCallFuncN *sawang = [CCCallFuncN actionWithTarget:self selector:@selector(playSawang)];
    // 收网音效
    CCCallFuncN *shouwang = [CCCallFuncN actionWithTarget:self selector:@selector(playShouwang)];

    // 蜘蛛自身摇头的动画
    CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.1*fTimeRate]];
    [sprite runAction:[CCRepeatForever actionWithAction:animation]];
    CCSequence *seq = [CCSequence actionsWithArray:mtArray];
    [sprite runAction:seq];
    
    // 蜘蛛网，先放大到1.2再缩小到0.8
    IGSprite *zzw = [IGSprite spriteWithSpriteFrameName:@"t6-w.png"];
    [zzw setScale:0.3];
    zzw.position = targetBox.position;
    [node addChild:zzw];
    [zzw runAction:[CCSequence actions:sawang,[CCScaleTo actionWithDuration:maxTime/5 scale:1.0],[CCScaleTo actionWithDuration:maxTime*3/5 scale:1.0],shouwang,[CCScaleTo actionWithDuration:maxTime/5 scale:0.3],delCallback,nil]];
    
    // 取得蜘蛛吃水果的个数
    NSInteger cout = maxTime/0.15;
    // 吃水果音效
    [IGMusicUtil showDeleteMusicWithNumberLoops:@"zhizhu7" ofType:@"caf" numberOfLoops:cout];
    
    // 放大
    CCScaleTo *st = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    // 显示动画->删除元素
    CCSequence *se = [CCSequence actions:st,delCallback,particleCallback, nil];
    [targetBox runAction:se];

    return [NSNumber numberWithFloat:maxTime];
}

-(void)playSawang
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"sawang2.caf" pitch:-2.0f pan:0.0f gain:1.0f];
}

-(void)playShouwang
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"shouwang.caf" pitch:-2.0f pan:0.0f gain:1.0f];
}

@end
