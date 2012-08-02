//
//  CL02.h
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  time control

#import "IGLayer.h"
#import "IGCommonDefine.h"
@interface CL02 : IGLayer
{
    NSDate *time;
    NSDate *iceNSDateTime;
    //剩余时间
    int times;
    //倒计时前一秒
    int persecond;
}

+(CL02*)getCL02;
@end
