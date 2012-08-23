//
//  IGBoxToolUtil.m
//  IGG003
//
//  Created by 鹏 李 on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxToolUtil.h"

@implementation IGBoxToolUtil

// 取得要新建点的箱子，不新建但是要移动位置的箱子会记录beforeTag
+(NSArray*)getNewBoxBringTool:(CCNode*) node clickPoint:(MxPoint)mp
{
    IGGameState *gameState = [IGGameState gameState];
    
    // 取得目标箱子   TODO 这个东西是不是能写个珙桐方法，或者直接传箱子，不传MxPoint
    int r = mp.R;
    int c = mp.C;
    int targetBoxTag = r*kBoxTagR+c;
    SpriteBox *box = (SpriteBox *)[node getChildByTag:targetBoxTag];
    
    NSMutableArray *result = [self getNewBoxNoTool:node clickPoint:mp];
    // 如果当前点击的是道具，则不产生新道具
    if(box.isTool&&!gameState.isHappyTime){
        return result;
    }
    // 生成随机道具
    GameToolType tooltype = toolsNO;
    
    int deleteNo = 0;
    // 取得元素
    CCArray* array = [node children];
    // 取得消除元素个数
    for( CCNode *child in array ) {
        // 如果不是箱子则跳过
        if (![child isKindOfClass:[SpriteBox class]]){
            continue;
        }
        if(((SpriteBox*)child).isDel){
            deleteNo ++;
        }
    }
    
//    // 如果在欢乐时间，道具固定
//    if(gameState.isHappyTime){
//        tooltype = tools05;
//    }
    
    if(tooltype== toolsNO && (deleteNo >=1 || gameState.m_combo >= 1)){
        if([self probability:90]){
            // 地雷
            if([self probability:40]){
                tooltype = tools01;
            }
//            else {
//                tooltype = tools02;
//                // 欢乐时光
//                CL02 *cl02 = [CL02 getCL02];
//                [cl02 clickHappyTimeTool];
//            }
        }
    }
    
    // 十字斩
    if(tooltype== toolsNO &&(deleteNo >=10 || gameState.m_combo >= 5)){
        if([self probability:80]){
            tooltype = tools03;
        }
    }
    // 增加时间,Broken模式不出
    if(gameState.gameMode == IGGameMode1 && tooltype== toolsNO &&(deleteNo >=9 || gameState.m_combo >= 4)){
        if([self probability:70]){
            tooltype = tools04;
        }
    }
    // 炸弹
    if(tooltype== toolsNO &&(deleteNo >=9 || gameState.m_combo >= 3)){
        if([self probability:40]){
            tooltype = tools05;
        }
    }
    // 闪电
    if(tooltype== toolsNO &&(deleteNo >=6 || gameState.m_combo >= 3)){
        if([self probability:60]){
            tooltype = tools06;
        }
    }
    // 冰冻,Broken模式不出
    if(gameState.gameMode == IGGameMode1 &&tooltype== toolsNO &&deleteNo >=6){
        if([self probability:50]){
            tooltype = tools07;
        }
    }
    
    // 分数太少时候给个惊喜
    if(tooltype== toolsNO && gameState.m_score < 10000 && gameState.m_time < 20){
        tooltype = tools01;
    }
    // 时间小于5秒时候，一定几率给予15秒时间奖励
    if(tooltype== toolsNO && gameState.m_time < 5){
        if([self probability:80]){
            tooltype = tools04;
        }
    }
    
    if(tooltype != toolsNO){
//        // 如果欢乐时光的话，全部作为炸弹返回
//        if(gameState.isHappyTime){
//            for (int i=0; i<[result count]; i++) {
//                SpriteBox *tempBox = [result objectAtIndex:i];
//                // 如果当前不是道具并且不是石头
//                if(!tempBox.isTool && tempBox.bType != eGbt99){
//                    tempBox.isTool = YES;
//                    tempBox.tType = tools05;
//                    [tempBox setToolByType:tools05];
//                }
//            }                 
//        }else {
            // 将道具添加到随机新箱子上
            SpriteBox *tempBox = [result objectAtIndex:CCRANDOM_0_1()*deleteNo+[result count]-deleteNo];
            // 道具不能加在石头上
            if (tempBox.bType != eGbt99) {
                tempBox.isTool = YES;
                tempBox.tType = tooltype;
                [tempBox setToolByType:tooltype];
            }
//        }

    }
    return result;
}

// 取新箱子的算法，从IGboxbase移动过来 
+(NSArray*)getNewBoxNoTool:(CCNode*) node clickPoint:(MxPoint)mp
{
    // 取得目标箱子   TODO 这个东西是不是能写个珙桐方法，或者直接传箱子，不传MxPoint
//    int r = mp.R;
//    int c = mp.C;
//    int targetBoxTag = r*kBoxTagR+c;
//    SpriteBox *box = (SpriteBox *)[node getChildByTag:targetBoxTag];

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *newBoxs = [NSMutableArray arrayWithCapacity:10];
    // 所有列
    for (int j = 0; j < kGameSizeCols; j++) {
        // 需要相减的行数
        int subRCount = 0;
        // 所有行
        for (int i = 0; i < kGameSizeRows; i++) {
            int boxTag = i*kBoxTagR+j;
            // 取得相应位置的箱子
            SpriteBox *box = (SpriteBox *)[node getChildByTag:boxTag];
            // 如果在目标箱子周围1的范围内
            if (box.isDel) {
                // 相减行数加一
                subRCount++;
                // 继续下一次循环
                continue;
            }
            // 根据相减行数重新计算箱子位置（tag就代表位置）
            // 这里不能直接改tag，需要先用beforeTag和isBefore备份一下
            box.beforeTag = box.tag - kBoxTagR*subRCount;
            box.isBefore = YES;
            [result addObject:box];
        }
        // 根据相减行数，在最上面追加新的箱子
        for (int i = 0; i < subRCount; i++) {
            SpriteBox *s = [SpriteBox spriteBoxWithRandomType];
            // 添加到区域外
            s.position = ccp(kSL01StartX + j*kSL01OffsetX,kSL01StartY + (kGameSizeRows + i)*kSL01OffsetY);
            // 设定tag：总行数－消去行数＋i
            s.tag = (kGameSizeRows-subRCount+i)*kBoxTagR+j;
            // 添加之后先不显示
            s.visible = NO;
            [newBoxs addObject:s];
        }
    }
    // 新追加的箱子放在最后
    [result addObjectsFromArray:newBoxs];
    return result;
}

+(BOOL)probability:(int)num{
    int r = CCRANDOM_0_1()*100 + 1;
    if(r<num){
        return YES;
    }
    return NO;
}
@end
