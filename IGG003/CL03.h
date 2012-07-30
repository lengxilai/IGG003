//
//  CL03.h
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  points control

#import "IGLayer.h"

@interface CL03 : IGLayer
{
    // 连击数
    int comboNum;
    // 总分数
    int totalPoints;
    int addedPoint;
    int addedTotalPoint;
    CCLabelBMFont *pointsSprit;
    CCLabelBMFont *comboSprit;
}
+(CL03*)getCL03;
-(void)getTotalPoint:(ccTime)dt;
-(id)addPointForBoxNum:(int)boxNum;
-(void)changePointWithPoint;
-(void)setPointPlace:(int)totalPoint comboNum: (int) comNum;
@end
