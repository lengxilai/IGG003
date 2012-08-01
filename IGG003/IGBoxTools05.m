//
//  IGBoxTools05.m
//  IGG003
//
//  Created by Ming Liu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools05.h"

@implementation IGBoxTools05

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
            if (box.bType == b.bType) {
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
}

-(void)showPopParticleForSprite:(SpriteBox*)sprite data:(SpriteBox*)box
{   
    // 显示消除箱子时的动画效果
    [IGAnimeUtil showTools05BoxAnime:box forBoxBase:self];
    [box removeFromParentAndCleanup:YES];
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
        
        if (!box.isTarget) {
            NSMutableArray *frames = [NSMutableArray arrayWithCapacity:10];
            // 构造每一个帧的实际图像数据
            for (int i = 1; i <= 5; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"t5-%d.png", i]];
                
                [frames addObject:frame];
            }
            {
                // 使用CCAnimation和CCRepeatForever构造一个一直重复的动画
                CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"t5-1.png"];
                
                double len_y = box.position.y - targetBox.position.y;
                double len_x = box.position.x - targetBox.position.x;
                
                double tan_yx = 0;
                if (len_x != 0) {
                    tan_yx = abs(len_y)/abs(len_x);
                }
                float angle = 0;
                if(len_y > 0 && len_x < 0) {
                    angle = atan(tan_yx)*180/M_PI - 90;
                } else if (len_y > 0 && len_x > 0) {
                    angle = 90 - atan(tan_yx)*180/M_PI;
                } else if(len_y < 0 && len_x < 0) {
                    angle = -atan(tan_yx)*180/M_PI - 90;
                } else if(len_y < 0 && len_x > 0) {
                    angle = atan(tan_yx)*180/M_PI + 90;
                } else if(len_x == 0 && len_y > 0){
                    angle = 0;
                } else if(len_x == 0 && len_y < 0){
                    angle = 180;
                } else if(len_y == 0 && len_x > 0){
                    angle = 90;
                } else if(len_y == 0 && len_x < 0){
                    angle = 270;
                }
                [sprite setRotation:angle];
                sprite.position = targetBox.position;
                [node addChild:sprite];
                
                float moveTime = sqrt((boxMP.R-targetBoxMP.R)*(boxMP.R-targetBoxMP.R)+(boxMP.C-targetBoxMP.C)*(boxMP.C-targetBoxMP.C))*0.08*fTimeRate;
                if (moveTime > maxTime) {
                    maxTime = moveTime;
                }
                
                CCAnimate *animation = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frames delay:0.02*fTimeRate]];
                [sprite runAction:[CCRepeatForever actionWithAction:animation]];
                CCMoveTo *mt = [CCMoveTo actionWithDuration:moveTime position:box.position];
                
                // 通过回调函数删除用于显示动画效果的Sprite
                id delCallback = [CCCallFuncN actionWithTarget:node selector:@selector(actionEndCallback:)];
                // 消除箱子
                id removeCallback =  [CCCallFuncND actionWithTarget:self selector:@selector(showPopParticleForSprite:data:) data:box];;
                
                [sprite runAction:[CCSequence actions:mt,delCallback,removeCallback, nil]];
            }
        }else {
            [self showPopParticle:box];
            [box removeFromParentAndCleanup:YES];
        }
    }
}
@end
