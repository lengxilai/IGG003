//
//  IGCommonDefine.h
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWindowW 320
#define kWindowH 480
#define kGameSizeRows 8
#define kGameSizeCols 8

#define kSL01StartX 30
#define kSL01StartY 80
#define kSL01OffsetX 38
#define kSL01OffsetY 40
#define kBoxSize 37
#define kBarSize 37
#define kToolSize 30
#define kMxPointNone 99

#define fTimeMoveto 0.15

#define kBoxTagR 100

#define fTimeRate 1.0

#define kComboBoxLimit 6

#define kToolSpriteTag 998

// 初始化时水果个数
#define kInitBoxTypeCount 5

// 消除一个水果的分数
#define pointPerBox 9
#define kPointPerS 27

//冰冻暂停时间
#define pauseTime 5
// happytime
#define happytime 5
//加时间
#define addTime 5
//字体变化到倍数
#define fontSizeTo 1.2
//倒计时tag
#define timeTag 100001
//倒计时x坐标
#define timeFontX 40
//倒计时Y坐标
#define timeFontY 463
//倒计时时长秒数
#define delaySeconds 61
//冰冻效果图片tag
#define iceBgTag 100010

#define brokenMode @"broken"
#define arcadeMode @"arcade"
#define scoreWriteNum 5
#define scoreReadNum 3
#define scoreAllReadNum 5

@interface IGCommonDefine : NSObject

@end
