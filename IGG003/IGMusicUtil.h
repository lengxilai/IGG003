//
//  IGMusicUtil.h
//  IGG003
//
//  Created by wu jiabin on 12-7-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface IGMusicUtil : NSObject

// 加载全部音效
+(void)loadMusic;
// 游戏界面的背景音乐
+(void)showBackgroundMusic;
// 水果晃动时的音效
+(void)showShakingMusic;
// 水果消除时的音效
+(void)showDeletingMusic;
// 水果下落时的音效(重新刷新矩阵)
+(void)showRefreshMusic;

@end
