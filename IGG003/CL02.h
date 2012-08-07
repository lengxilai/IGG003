//
//  CL02.h
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  time control

#import "IGLayer.h"
#import "IGCommonDefine.h"
#import "S01.h"

@interface CL02 : IGLayer
{
    NSDate *time;
    NSDate *iceNSDateTime;
    NSDate *happyTimeNSDateTime;
    //剩余时间
    int times;
    //倒计时前一秒
    int persecond;
    int iceFlg;
    int happyTimeFlg;
    float iceDelayTime;
    float happytimeDelayTime;
}
@property(nonatomic,retain) NSDate *iceNSDateTime;
@property(nonatomic,retain) NSDate *happyTimeNSDateTime;
@property(nonatomic,retain) NSDate *time;
+(CL02*)getCL02;
-(void)endPause;
@end
