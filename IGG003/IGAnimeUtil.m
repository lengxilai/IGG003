//
//  IGAnimeUtil.m
//  IGT003
//
//  Created by Ming Liu on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGAnimeUtil.h"

@implementation IGAnimeUtil

// 根据箱子类型修改粒子效果
+(ccColor4F)editParticleColorForType:(GameBoxType)bType forParticle:(CCParticleSystemQuad*)popParticle
{
    // 1苹果 2橙子 3柠檬 4西瓜 5菠萝 6草莓 7香蕉 8葡萄
    switch (bType) {
        case eGbt1:
            popParticle.startColor = (ccColor4F){1.0f, 1.0f, 1.0f, 1.0f};
            break;
        case eGbt2:
            popParticle.startColor = (ccColor4F){1.0f, 0.35f, 1.0f, 1.0f};
            break;
        case eGbt3:
            popParticle.startColor = (ccColor4F){1.0f, 0.96f, 0.0f, 1.0f};
            break;
        case eGbt4:
            popParticle.startColor = (ccColor4F){0.0f, 1.0f, 1.0f, 1.0f};
            break;
        case eGbt5:
            popParticle.startColor = (ccColor4F){1.0f, 0.7f, 1.0f, 1.0f};
            break;
        case eGbt6:
            popParticle.startColor = (ccColor4F){1.0f, 0.0f, 0.0f, 1.0f};
            break;
        case eGbt7:
            popParticle.startColor = (ccColor4F){1.0f, 0.96f, 0.0f, 1.0f};
            break;
        case eGbt8:
            popParticle.startColor = (ccColor4F){0.7f, 1.0f, 1.0f, 1.0f};
            break;
            
        default:
            break;
    }
}

// 显示消除箱子时的动画效果
+(void)showRemoveBoxAnime:(SpriteBox*)box forBoxBase:(IGBoxBase*)boxBase
{
    CGPoint position = box.position;
    GameBoxType bType = box.bType;
    
    // 粒子效果
    CCParticleSystemQuad *popParticle = [boxBase.particleManager particleOfType:@"pop"];
    popParticle.position = position;
    // 根据箱子类型修改粒子效果
    [IGAnimeUtil editParticleColorForType:bType forParticle:popParticle];
    [popParticle resetSystem];
    
    // 创建分裂之后的箱子
    IGSprite *lS = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dl.png",bType]];
    IGSprite *rS = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dr.png",bType]];
    lS.position = ccp(position.x,position.y);
    rS.position = ccp(position.x,position.y);
    
    // 跳跃时间和高度
    float jumpTime = 0.3*fTimeRate;
    float jumpHeight = kBoxSize;
    // 旋转时间和角度
    float roTime = 0.3*fTimeRate;
    float roAngle = 60;
    // 渐隐时间
    float fadeTime = 0.5*fTimeRate;
    // 缩放时间和比率
    float scaleTime = 0.3*fTimeRate;
    float scaleRate = 0.75;
    
    // 跳跃动作
    CCJumpTo* mL = [CCJumpTo actionWithDuration:jumpTime position:ccp(position.x - kBoxSize,position.y - kBoxSize/2) height:jumpHeight jumps:1]; 
    CCJumpTo* mR = [CCJumpTo actionWithDuration:jumpTime position:ccp(position.x + kBoxSize,position.y - kBoxSize/2) height:jumpHeight jumps:1];
    
    // 旋转
    CCRotateTo* roL = [CCRotateTo  actionWithDuration:roTime angle:360-roAngle];
    CCRotateTo* roR = [CCRotateTo actionWithDuration:roTime angle:roAngle];
    
    // 渐隐
    CCFadeOut* foL = [CCFadeOut actionWithDuration:fadeTime];
    CCFadeOut* foR = [CCFadeOut actionWithDuration:fadeTime];
    
    // 缩放
    CCScaleTo* scaleL = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    CCScaleTo* scaleR = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    
    // 同步执行所有动画
    CCSpawn *sL = [CCSpawn actions:mL,foL,roL,scaleL, nil];
    CCSpawn *sR = [CCSpawn actions:mR,foR,roR,scaleR, nil];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id callbackL = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    id callbackR = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    
    CCSequence *seqL = [CCSequence actions:sL,callbackL, nil];
    CCSequence *seqR = [CCSequence actions:sR,callbackR, nil];
    
    [boxBase.node addChild:rS];
    [boxBase.node addChild:lS];
    [lS runAction:seqL];
    [rS runAction:seqR];
}

// 准备消除时的晃动效果
+(void)showReadyRemoveBoxAnime:(SpriteBox*)box forBoxBase:(IGBoxBase*)boxBase
{
    // 晃动的动画
    float mobeStepTime = 0.05*fTimeRate;
    id mb1 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(5,0)];
    id mb2 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(-10,0)];
    id mb3 = [mb2 reverse];
    id mb4 = [mb3 reverse];
    id mb5 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(5,0)];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id delCallback = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    // 通过回调函数显示粒子效果
    id particleCallback = [CCCallFuncN actionWithTarget:boxBase selector:@selector(showPopParticle:)];
    
    // 显示动画、晃动->粒子效果->删除元素
    CCSequence *mb = [CCSequence actions:mb1,mb2,mb3,mb4,mb5,particleCallback,delCallback, nil];
    [box runAction:mb];
}

// 显示T01消除时的动画效果
+(void)showTools01BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase
{
    CGPoint position = box.position;
    GameBoxType bType = box.bType;
    if (box.isTarget) {
        // 粒子效果
        CCParticleSystemQuad *popParticle = [boxBase.particleManager particleOfType:@"tools01"];
        popParticle.position = position;
        // 根据箱子类型修改粒子效果
        //[IGAnimeUtil editParticleColorForType:bType forParticle:popParticle];
        [popParticle resetSystem];
        return;
    }
    
    // 粒子效果
    CCParticleSystemQuad *popParticle = [boxBase.particleManager particleOfType:@"pop"];
    popParticle.position = position;
    // 根据箱子类型修改粒子效果
    [IGAnimeUtil editParticleColorForType:bType forParticle:popParticle];
    [popParticle resetSystem];
    
    // 创建分裂之后的箱子
    IGSprite *lS = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dl.png",bType]];
    IGSprite *rS = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dr.png",bType]];
    lS.position = ccp(position.x,position.y);
    rS.position = ccp(position.x,position.y);
    
    // 跳跃时间和高度
    float jumpTime = 0.3*fTimeRate;
    float jumpHeight = kBoxSize;
    // 旋转时间和角度
    float roTime = 0.3*fTimeRate;
    float roAngle = 60;
    // 渐隐时间
    float fadeTime = 0.5*fTimeRate;
    // 缩放时间和比率
    float scaleTime = 0.1*fTimeRate;
    float scaleRate = 1.0;
    
    // 跳跃动作
    CCJumpTo* mL = [CCJumpTo actionWithDuration:jumpTime position:ccp(position.x - kBoxSize,position.y - kBoxSize/2) height:jumpHeight jumps:1]; 
    CCJumpTo* mR = [CCJumpTo actionWithDuration:jumpTime position:ccp(position.x + kBoxSize,position.y - kBoxSize/2) height:jumpHeight jumps:1];
    
    // 旋转
    CCRotateTo* roL = [CCRotateTo  actionWithDuration:roTime angle:360-roAngle];
    CCRotateTo* roR = [CCRotateTo actionWithDuration:roTime angle:roAngle];
    
    // 渐隐
    CCFadeOut* foL = [CCFadeOut actionWithDuration:fadeTime];
    CCFadeOut* foR = [CCFadeOut actionWithDuration:fadeTime];
    
    // 缩放
    CCScaleTo* scaleL = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    CCScaleTo* scaleR = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    
    // 同步执行所有动画
    CCSpawn *sL = [CCSpawn actions:mL,foL,roL,scaleL, nil];
    CCSpawn *sR = [CCSpawn actions:mR,foR,roR,scaleR, nil];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id callbackL = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    id callbackR = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    
    CCSequence *seqL = [CCSequence actions:sL,callbackL, nil];
    CCSequence *seqR = [CCSequence actions:sR,callbackR, nil];
    
    [boxBase.node addChild:rS];
    [boxBase.node addChild:lS];
    [lS runAction:seqL];
    [rS runAction:seqR];
}

// T01准备消除时的晃动效果
+(void)showReadyTools01BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase
{
    // 放大
    float scaleTime = 0.15*fTimeRate;
    float scaleRate = 1.8;
    CCScaleTo *st = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    
    // 晃动的动画
    float mobeStepTime = 0.03*fTimeRate;
    id mb1 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(5,0)];
    id mb2 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(-10,0)];
    id mb3 = [mb2 reverse];
    id mb4 = [mb3 reverse];
    id mb5 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(5,0)];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id delCallback = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    // 通过回调函数显示粒子效果
    id particleCallback = [CCCallFuncN actionWithTarget:boxBase selector:@selector(showPopParticleForTools01:)];
    
    if (!box.isTarget) {
        CCSequence *se = [CCSequence actions:[CCScaleTo actionWithDuration:scaleTime scale:1.0],delCallback,particleCallback, nil];
        [box runAction:se];
        return;
    }
    
    // 显示动画、晃动->粒子效果->删除元素
    CCSequence *mb = [CCSequence actions:mb1,mb2,mb3,mb4,mb5, nil];
    CCSpawn *sp = [CCSpawn actions:mb,st, nil];
    CCSequence *se = [CCSequence actions:sp,delCallback,particleCallback, nil];
    [box runAction:se];
}


// 显示T06消除时的动画效果
+(void)showTools06BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase
{
    CGPoint position = box.position;
    GameBoxType bType = box.bType;
    if (box.isTarget) {
        // 粒子效果
        CCParticleSystemQuad *popParticle = [boxBase.particleManager particleOfType:@"pop"];
        popParticle.position = position;
        // 根据箱子类型修改粒子效果
        //[IGAnimeUtil editParticleColorForType:bType forParticle:popParticle];
        popParticle.startColor = (ccColor4F){1.0f, 1.0f, 1.0f, 1.0f};
        popParticle.endColor = (ccColor4F){1.0f, 1.0f, 1.0f, 1.0f};
        [popParticle resetSystem];
        return;
    }
    
//    // 粒子效果
//    CCParticleSystemQuad *popParticle = [boxBase.particleManager particleOfType:@"pop"];
//    popParticle.position = position;
//    // 根据箱子类型修改粒子效果
//    [IGAnimeUtil editParticleColorForType:bType forParticle:popParticle];
//    [popParticle resetSystem];
    
    // 创建分裂之后的箱子
    IGSprite *lS = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dl.png",bType]];
    IGSprite *rS = [IGSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%dr.png",bType]];
    lS.position = ccp(position.x,position.y);
    rS.position = ccp(position.x,position.y);
    
    // 跳跃时间和高度
    float jumpTime = 0.3*fTimeRate;
    float jumpHeight = kBoxSize;
    // 旋转时间和角度
    float roTime = 0.3*fTimeRate;
    float roAngle = 60;
    // 渐隐时间
    float fadeTime = 0.5*fTimeRate;
    // 缩放时间和比率
    float scaleTime = 0.1*fTimeRate;
    float scaleRate = 1.0;
    
    // 跳跃动作
    CCJumpTo* mL = [CCJumpTo actionWithDuration:jumpTime position:ccp(position.x - kBoxSize,position.y - kBoxSize/2) height:jumpHeight jumps:1]; 
    CCJumpTo* mR = [CCJumpTo actionWithDuration:jumpTime position:ccp(position.x + kBoxSize,position.y - kBoxSize/2) height:jumpHeight jumps:1];
    
    // 旋转
    CCRotateTo* roL = [CCRotateTo  actionWithDuration:roTime angle:360-roAngle];
    CCRotateTo* roR = [CCRotateTo actionWithDuration:roTime angle:roAngle];
    
    // 渐隐
    CCFadeOut* foL = [CCFadeOut actionWithDuration:fadeTime];
    CCFadeOut* foR = [CCFadeOut actionWithDuration:fadeTime];
    
    // 缩放
    CCScaleTo* scaleL = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    CCScaleTo* scaleR = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    
    // 同步执行所有动画
    CCSpawn *sL = [CCSpawn actions:mL,foL,roL,scaleL, nil];
    CCSpawn *sR = [CCSpawn actions:mR,foR,roR,scaleR, nil];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id callbackL = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    id callbackR = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    
    CCSequence *seqL = [CCSequence actions:sL,callbackL, nil];
    CCSequence *seqR = [CCSequence actions:sR,callbackR, nil];
    
    [boxBase.node addChild:rS];
    [boxBase.node addChild:lS];
    [lS runAction:seqL];
    [rS runAction:seqR];
}

// T06准备消除时的晃动效果
+(void)showReadyTools06BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase
{
    // 放大
    float scaleTime = 0.15*fTimeRate;
    float scaleRate = 1.2;
    CCScaleTo *st = [CCScaleTo actionWithDuration:scaleTime scale:scaleRate];
    
    // 晃动的动画
    float mobeStepTime = 0.03*fTimeRate;
    id mb1 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(5,0)];
    id mb2 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(-10,0)];
    id mb3 = [mb2 reverse];
    id mb4 = [mb3 reverse];
    id mb5 = [CCMoveBy actionWithDuration:mobeStepTime position:ccp(5,0)];
    
    // 通过回调函数删除用于显示动画效果的Sprite
    id delCallback = [CCCallFuncN actionWithTarget:boxBase.node selector:@selector(actionEndCallback:)];
    // 通过回调函数显示粒子效果
    id particleCallback = [CCCallFuncN actionWithTarget:boxBase selector:@selector(showPopParticle:)];
    
    if (!box.isTarget) {
        CCSequence *se = [CCSequence actions:[CCScaleTo actionWithDuration:scaleTime scale:1.0],delCallback,particleCallback, nil];
        [box runAction:se];
        return;
    }
    
    // 显示动画、晃动->粒子效果->删除元素
    CCSequence *mb = [CCSequence actions:mb1,mb2,mb3,mb4,mb5, nil];
    CCSpawn *sp = [CCSpawn actions:st, nil];
    CCSequence *se = [CCSequence actions:sp,delCallback,particleCallback, nil];
    [box runAction:se];
}
@end
