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

-(id) init
{
	if( (self=[super init])) {
        //初始化分数
        totalPoints = 0;
        numArr = [[NSArray alloc] init];
        NSString *numStr = [[NSString alloc] initWithFormat:@"%d",totalPoints]; 
		CCLabelBMFont *pointsSprit = [CCLabelBMFont labelWithString:numStr fntFile:@"bitmapFont.fnt"];
		pointsSprit.position = ccp(300,450);
        pointsSprit.tag = 100001;
        [pointsSprit setString:@"0"];
        
		[self addChild:pointsSprit];
        addedPoint = 64*1024;
        
        addedTotalPoint = totalPoints + addedPoint;
        comboNum = 1024;
        [self schedule:@selector(getTotalPoint:) interval:(0.01)];
        //[self getTotalPoint];

	}
	return self;
}
//初始化  加分前的分数   combo数
-(id)initWithTotalPoint:(int)perTotalPoint withSeries:(int)comboNumber withFruitNum:(int)fruitNumber{
    //加分前的分数
    totalPoints = perTotalPoint;
    //连击数
    comboNum = comboNumber;
    //得分计算
    addedPoint = fruitNumber * comboNum;
    addedTotalPoint = totalPoints + addedPoint;
    [self schedule:@selector(getTotalPoint:) interval:(0.01)];
    
}
-(void)getTotalPoint:(ccTime)dt{
    //水果消除后的得分
    totalPoints = totalPoints + comboNum;

    [self changePointWithPoint];
    if(addedTotalPoint == totalPoints){
        [self unschedule:@selector(getTotalPoint:)];
    }
}
-(void)changePointWithPoint{
    //计算位数
    NSString *pointStr = [NSString stringWithFormat:@"%d",totalPoints] ;
    CCLabelBMFont *pointsSprit = (CCLabelBMFont *)[self getChildByTag:100001];
    
    [pointsSprit setString:pointStr];
    pointsSprit.position = ccp(310 - pointStr.length * 10,450);
//    id a1 = [CCScaleTo  actionWithDuration:0.01f scaleX:1.5f scaleY:0.8f];
//    id a2 = [CCScaleTo actionWithDuration:0.01f scaleX:1.0f scaleY:1.0f];
//    id a3 = [CCSequence actions:a1,a2,nil];
//    [pointsSprit runAction:a3];
}
@end
