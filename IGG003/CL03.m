//
//  CL03.m
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL03.h"
#import "IGMusicUtil.h"

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
-(id)addPointForBoxNum:(int)boxNum forPoint:(CGPoint) position {
    
    IGGameState *gameState = [IGGameState gameState];

    // 加分前的分数
    totalPoints = gameState.m_score;
    // 连击数
    comboNum = gameState.m_combo;
    // 得分计算,消除小于3个减分
    if (boxNum<3) {
        addedPoint = -10 * boxNum * (comboNum==0?1:pow(2, (int)comboNum/2));
        [IGMusicUtil showDeletePointMusic];
    } else {
        addedPoint = pointPerBox * boxNum * (comboNum==0?1:pow(2, (int)comboNum/2));
        [IGMusicUtil showAddPointMusic];
    }

    // 合计总分
    addedTotalPoint = (totalPoints + addedPoint)<0?0:(totalPoints + addedPoint);
    
    [self showPointAndCombo:position];
    // 更新GameState最新分数
    gameState.m_score = addedTotalPoint;
    [self schedule:@selector(getTotalPoint:) interval:(0.01)];
    [self changeCombo];
}

// 计算每次加分效果所加的分数
-(void)getTotalPoint:(ccTime)dt{
    // 如果加分后总和大于0,显示加分效果
    // 如果加分后总和小于0,但当前分数不为0,显示加分效果，直到分数为0
    if ((totalPoints + addedPoint)>=0 || addPointFlag==TRUE) {
        addPointFlag = TRUE;
        // 上一次分数基础上分步增加分数
        totalPoints = totalPoints + addedPoint/10;
    } else if ((totalPoints>0 && (totalPoints + addedPoint)<0) || addPointFlag2==TRUE) {
        addPointFlag2 = TRUE;
        // 上一次分数基础上分步增加分数
        totalPoints = totalPoints + addedPoint/10;
    }
    
    [self changePointWithPoint];
    if(addedTotalPoint == totalPoints){
        addPointFlag = false;
        addPointFlag2 = false;
        [self unschedule:@selector(getTotalPoint:)];
    }
}

// 显示加分效果
-(void)changePointWithPoint{
    //计算位数
    NSString *pointStr = [NSString stringWithFormat:@"%d",totalPoints];
    pointsSprit = (CCLabelBMFont *)[self getChildByTag:200001];
    [pointsSprit setString:pointStr];    
    pointsSprit.position = ccp(310 - pointStr.length * 10,463);

}

// 显示combo效果
-(void)changeCombo {
    if (comboNum > 0) {
        // 本次combo数
        NSString *comboStr = [NSString stringWithFormat:@"%d",comboNum];
        [comboSprit setVisible:YES];
        comboStr = [@"x" stringByAppendingString:comboStr];
        comboSprit = (CCLabelBMFont *)[self getChildByTag:200002];
        [comboSprit setString:comboStr];
        comboSprit.position = ccp(310 - comboStr.length * 10, 425);
    } else {
        [comboSprit setVisible:NO];
    }
}

// 判断combo数是否变化
-(BOOL)isComboChanged {
    // 本次combo数
    NSString *comboStr = [NSString stringWithFormat:@"%d",comboNum];
    // 本次combo数前加上"x"
    NSString *tempStr = [@"x" stringByAppendingString:comboStr];
    // 前一次combo数
    NSString *preComboNumStr = [comboSprit string];
    // 如果combo数没变不现实动画效果
    if ([tempStr isEqualToString:preComboNumStr]) {
        return NO;
    }
    return YES;
}

// 设置分数显示位置
-(void)setPointPlace:(int) totalPoint comboNum:(int) comNum {
    // 分数
    NSString *numStr = [[NSString alloc] initWithFormat:@"%d", totalPoint];
    // combo数
    NSString *comStr = [[NSString alloc] initWithFormat:@"%d", comNum];
    comStr = [@"x" stringByAppendingString:comStr];
    // 分数字体
    pointsSprit = [CCLabelBMFont labelWithString:numStr fntFile:@"pointFont.fnt"];
    // combo字体
//    CCLabelBMFont *comboName = [CCLabelBMFont labelWithString:@"combo:" fntFile:@"pointFont.fnt"];
    comboSprit = [CCLabelBMFont labelWithString:comStr fntFile:@"combofont4.fnt"];
    // 分数显示坐标
    pointsSprit.position = ccp(300,463);
    // combo显示坐标
//    comboName.position = ccp(230, 410);
    comboSprit.position = ccp(300,425);
    // 分数tag
    pointsSprit.tag = 200001;
    // combo tag
    comboSprit.tag = 200002;
    
    [self addChild:pointsSprit];
//    [self addChild:comboName];
    [comboSprit setVisible:NO];
    [self addChild:comboSprit];
    
}

// 被消除的水果的上边显示分数和combo
-(void)showPointAndCombo:(CGPoint) position {
    CGFloat position_x = position.x;
    CGFloat position_y = position.y;
    
    // 增加的分数
    NSString *addPointStr = [[NSString alloc] initWithFormat:@"%d", addedPoint];
    // 增加分数显示的字体
    CCLabelBMFont *addPointSprite = [CCLabelBMFont labelWithString:addPointStr fntFile:@"pointFont2.fnt"];
    addPointSprite.scale = 1.6;
    // 增加分数的起始位置
    addPointSprite.position = ccp(position_x, position_y);    
    // 增加分数的动态效果
    CCMoveTo *moTP = [CCMoveTo actionWithDuration:0.1 position:ccp(position_x,position_y+85)];
    CCFadeOut* foLP = [CCFadeOut actionWithDuration:1.7];
    CCScaleTo *scalePointTo = [CCScaleTo actionWithDuration:1.3 scale: 1.1];
    CCSpawn *sP = [CCSpawn actions:moTP, scalePointTo, nil];
    id callbackP = [CCCallFuncN actionWithTarget:self selector:@selector(actionEndCallback:)];
    CCSequence *seqP = [CCSequence actions:sP,callbackP, nil];
    [self addChild:addPointSprite];
    [addPointSprite runAction:seqP];
    
    // 增加的combo
    if (comboNum > 0) {
        NSString *addComboStr = [[NSString alloc] initWithFormat:@"%d", comboNum];
        addComboStr = [@"x" stringByAppendingString:addComboStr];
        // 增加combo显示的字体
        CCLabelBMFont *addComboSprite = [CCLabelBMFont labelWithString:addComboStr fntFile:@"combofont4.fnt"];
        addComboSprite.scale = 2.5;
        // 增加combo的起始位置
        addComboSprite.position = ccp(290, 425);
        // 增加combo的动态效果
        CCScaleTo *scaleComboTo = [CCScaleTo actionWithDuration:0.5 scale:1];
        CCSpawn *sC = [CCSpawn actions:scaleComboTo, nil];
        id callbackC = [CCCallFuncN actionWithTarget:self selector:@selector(actionEndCallbackC:)];

        if ([self isComboChanged]) {
            CCSequence *seqC = [CCSequence actions:sC,callbackC, nil];
            [self addChild:addComboSprite];
            [addComboSprite runAction:seqC];
        }

    }
}

// 动画之后删除精灵
-(void)actionEndCallback:(id) sender
{
    CCLabelBMFont *ccPoint = (CCLabelBMFont *)sender;
    [ccPoint removeFromParentAndCleanup:YES];
}
-(void)actionEndCallbackC:(id) sender
{
    CCLabelBMFont *ccCombo = (CCLabelBMFont *)sender;
    [ccCombo removeFromParentAndCleanup:YES];    
}

@end
