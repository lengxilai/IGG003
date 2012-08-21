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
    
    // 消除的石头数量
    int sNum = gameState.m_broken_count;
    
    // 计算分数时，连击数最多为16,也就是基数最大为256
    int scoreCombo = comboNum > 16?16:comboNum;
    
    // GameMode1消除4个以下减分，GameMode2消除3个以下减分
    int scoreLimit = (gameState.gameMode == IGGameMode1 ? 4 : 3);
    if (boxNum<scoreLimit) {
        addedPoint = (0-pointPerBox) * gameState.m_box_level * (scoreLimit-boxNum) * (comboNum==0?1:pow(2, (int)scoreCombo/2));
        [IGMusicUtil showDeletePointMusic];
    } else {
        addedPoint = pointPerBox * boxNum * (comboNum==0?1:pow(2, (int)scoreCombo/2));
        [IGMusicUtil showAddPointMusic];
    }
    
    // 消除石头个数＊当前等级和初始等级差+1＊石头分数的基数
    addedPoint = addedPoint + kPointPerS * sNum * (gameState.m_box_level - kInitBoxTypeCount + 1);

    // 合计总分 = 上一次总分＋本次增加分数
    addedTotalPoint = (totalPoints + addedPoint)<0?0:(totalPoints + addedPoint);
    
    [self showPointAndCombo:position];
    // 更新GameState最新分数
    [gameState setScore:addedTotalPoint];
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
        totalPoints = totalPoints + addedPoint/pointPerBox;
    } else if ((totalPoints>0 && (totalPoints + addedPoint)<0) || addPointFlag2==TRUE) {
        addPointFlag2 = TRUE;
        // 上一次分数基础上分步增加分数
        totalPoints = totalPoints + addedPoint/pointPerBox;
    }
    
    [self changePointWithPoint];
    if(addedTotalPoint == totalPoints){
        addPointFlag = false;
        addPointFlag2 = false;
        [self unschedule:@selector(getTotalPoint:)];
    }else if (addedTotalPoint <= 0) {
        totalPoints = 0;
        [self changePointWithPoint];
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
        [comboSprit setString:@"0"];
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
    NSString *numStr = [NSString stringWithFormat:@"%d", totalPoint];
    // combo数
    NSString *comStr = [NSString stringWithFormat:@"%d", comNum];
    comStr = [@"x" stringByAppendingString:comStr];
    // 分数字体
    pointsSprit = [CCLabelBMFont labelWithString:numStr fntFile:@"pointFont.fnt"];
    // combo字体
//    CCLabelBMFont *comboName = [CCLabelBMFont labelWithString:@"combo:" fntFile:@"pointFont.fnt"];
    comboSprit = [CCLabelBMFont labelWithString:comStr fntFile:@"comboFont5.fnt"];
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
    NSString *addPointStr = [NSString stringWithFormat:@"%d", addedPoint];
    // 增加分数显示的字体
    CCLabelBMFont *addPointSprite = [CCLabelBMFont labelWithString:addPointStr fntFile:@"pointFont2.fnt"];
    addPointSprite.tag = 200003;
    addPointSprite.scale = 1.6;
    // 增加分数的起始位置
    addPointSprite.position = ccp(position_x, position_y);    
    // 增加分数的动态效果
    CCMoveTo *moTP = [CCMoveTo actionWithDuration:0.1 position:ccp(position_x,position_y+85)];
//    CCFadeOut* foLP = [CCFadeOut actionWithDuration:1.7];
    CCScaleTo *scalePointTo = [CCScaleTo actionWithDuration:1.3 scale: 1.1];
    CCSpawn *sP = [CCSpawn actions:moTP, scalePointTo, nil];
    id callbackP = [CCCallFuncN actionWithTarget:self selector:@selector(actionEndCallback:)];
    CCSequence *seqP = [CCSequence actions:sP,callbackP, nil];
    [self addChild:addPointSprite];
    [addPointSprite runAction:seqP];
    
    // 增加的combo
    if (comboNum > 0) {
        NSString *addComboStr = [NSString stringWithFormat:@"%d", comboNum];
        addComboStr = [@"x" stringByAppendingString:addComboStr];
        // 增加combo显示的字体
        CCLabelBMFont *addComboSprite = [CCLabelBMFont labelWithString:addComboStr fntFile:@"comboFont5.fnt"];
        addComboSprite.scale = 2.5;
        // 增加combo的起始位置
        addComboSprite.position = ccp(290, 425);
        // 增加combo的动态效果
        CCScaleTo *scaleComboTo = [CCScaleTo actionWithDuration:0.5 scale:1];
        CCSpawn *sC = [CCSpawn actions:scaleComboTo, nil];
        id callbackC = [CCCallFuncN actionWithTarget:self selector:@selector(actionEndCallbackC:)];

        if ([self isComboChanged]) {
            if (comboNum <= 5) {
                [IGMusicUtil showComboMusic:comboNum];
            } else {
                [IGMusicUtil showComboMusic:0];
            }

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
