//
//  CL03.m
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL03.h"

@implementation CL03
static int perFruitPoint = 5;
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
    NSString *numStr = [[NSString alloc] initWithFormat:@"%d", totalPoint];
    NSString *comStr = [[NSString alloc] initWithFormat:@"%d", comNum];
    pointsSprit = [CCLabelBMFont labelWithString:numStr fntFile:@"bitmapFont.fnt"];
    CCLabelBMFont *comboName = [CCLabelBMFont labelWithString:@"combo:" fntFile:@"bitmapFont.fnt"];
    comboSprit = [CCLabelBMFont labelWithString:comStr fntFile:@"bitmapFont.fnt"];
    pointsSprit.position = ccp(300,450);
    comboName.position = ccp(260, 430);
    comboSprit.position = ccp(300,430);
    pointsSprit.tag = 200001;
    comboSprit.tag = 200002;
    [self addChild:pointsSprit];
    [self addChild:comboName];
    [self addChild:comboSprit];
}

@end
