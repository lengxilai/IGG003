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
    int comboNum;
    int totalPoints;
    NSArray *numArr;
    int addedPoint;
    int addedTotalPoint;
}
-(void)getTotalPoint:(ccTime)dt;
-(id)addPointForBoxNum:(int)boxNum;
@end
