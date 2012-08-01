//
//  CL03.m
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL03.h"

@implementation CL03
static CL03 *staticCL03;

-(id) init
{
	if( (self=[super init])) {
        // 初始化分数
        totalPoints = 0;
        comboNum = 0;
        // 设置分数显示位置
        [self setPointPlace:totalPoints comboNum:comboNum];
	}
    staticCL03 = self;
	return self;
}

+(CL03*)getCL03
{
    if (staticCL03 == nil) {
        staticCL03 = [CL03 node];
        return staticCL03;
    }else {
        return staticCL03;
    }
}

//初始化  加分前的分数   combo数
-(id)addPointForBoxNum:(int)boxNum{
    
    IGGameState *gameState = [IGGameState gameState];

    // 加分前的分数
    totalPoints = gameState.m_score;
    // 连击数
    comboNum = gameState.m_combo;
    // 得分计算
    addedPoint = boxNum * (comboNum==0?1:comboNum);
    // 合计总分
    addedTotalPoint = totalPoints + addedPoint;
    
    CGPoint *p;
    [self showPointAndCombo:*p];
    // 更新GameState最新分数
    gameState.m_score = addedTotalPoint;
    [self schedule:@selector(getTotalPoint:) interval:(0.01)];
    
}

-(void)getTotalPoint:(ccTime)dt{
    // 上一次分数基础上分步增加分数
    totalPoints = totalPoints + (comboNum == 0?1:comboNum);
    
    [self changePointWithPoint];
    if(addedTotalPoint == totalPoints){
        [self unschedule:@selector(getTotalPoint:)];
    }
}
-(void)changePointWithPoint{
    //计算位数
    NSString *pointStr = [NSString stringWithFormat:@"%d",totalPoints];
    NSString *comboStr = [NSString stringWithFormat:@"%d",comboNum];
    pointsSprit = (CCLabelBMFont *)[self getChildByTag:200001];
    comboSprit = (CCLabelBMFont *)[self getChildByTag:200002];
    
    [pointsSprit setString:pointStr];
    [comboSprit setString:comboStr];
    pointsSprit.position = ccp(310 - pointStr.length * 10,450);
    comboSprit.position = ccp(310 - comboStr.length * 10, 430);
}

// 设置分数显示位置
-(void)setPointPlace:(int) totalPoint comboNum:(int) comNum {
    // 分数
    NSString *numStr = [[NSString alloc] initWithFormat:@"%d", totalPoint];
    // combo数
    NSString *comStr = [[NSString alloc] initWithFormat:@"%d", comNum];
    // 分数字体
    pointsSprit = [CCLabelBMFont labelWithString:numStr fntFile:@"bitmapFont.fnt"];
    // combo字体
    CCLabelBMFont *comboName = [CCLabelBMFont labelWithString:@"combo:" fntFile:@"bitmapFont.fnt"];
    comboSprit = [CCLabelBMFont labelWithString:comStr fntFile:@"bitmapFont.fnt"];
    // 分数显示坐标
    pointsSprit.position = ccp(300,450);
    // combo显示坐标
    comboName.position = ccp(260, 430);
    comboSprit.position = ccp(300,430);
    // 分数tag
    pointsSprit.tag = 200001;
    // combo tag
    comboSprit.tag = 200002;
    
    
    
    [self addChild:pointsSprit];
    [self addChild:comboName];
    [self addChild:comboSprit];
}

// 被消除的水果的上边显示分数和combo
-(void)showPointAndCombo:(CGPoint) position{
    CGFloat position_x = position.x;
    CGFloat position_y = position.y;
    
    // 增加的分数
    NSString *addPointStr = [[NSString alloc] initWithFormat:@"%d", addedPoint];
    // 增加的combo
    NSString *addComboStr = [[NSString alloc] initWithFormat:@"%d", comboNum];
    // 增加分数显示的字体
    addPointSprite = [CCLabelBMFont labelWithString:addPointStr fntFile:@"bitmapFont.fnt"];
    // 增加combo显示的字体
    addComboSprite = [CCLabelBMFont labelWithString:addComboStr fntFile:@"bitmapFont.fnt"];
    // 增加分数的起始位置
    addPointSprite.position = ccp(0, 0);
    // 增加combo的起始位置
    addComboSprite.position = ccp(0, 0);
    
    // 增加分数的动态效果
    CCMoveTo *moTP = [CCMoveTo actionWithDuration:1 position:ccp(300,450)];
    CCFadeOut* foLP = [CCFadeOut actionWithDuration:1.7];
    CCSpawn *sP = [CCSpawn actions:moTP, nil];
    id callbackP = [CCCallFuncN actionWithTarget:self selector:@selector(actionEndCallback:)];
    CCSequence *seqP = [CCSequence actions:sP,callbackP, nil];

    // 增加combo的动态效果
    CCMoveTo *moTC = [CCMoveTo actionWithDuration:1 position:ccp(300,420)];
    CCFadeOut* foLC = [CCFadeOut actionWithDuration:1.7];
    CCSpawn *sC = [CCSpawn actions:moTC, nil];
    id callbackC = [CCCallFuncN actionWithTarget:self selector:@selector(actionEndCallbackC:)];
    CCSequence *seqC = [CCSequence actions:sC,callbackC, nil];
    
    [self addChild:addPointSprite];
    [self addChild:addComboSprite];
    [addPointSprite runAction:seqP];
    if (comboNum != 0) {
        [addComboSprite runAction:seqC];
    }


}

// 动画之后删除精灵
-(void)actionEndCallback:(id) sender
{
    [addPointSprite removeFromParentAndCleanup:YES];
}
-(void)actionEndCallbackC:(id) sender
{
    [addComboSprite removeFromParentAndCleanup:YES];
}

@end
