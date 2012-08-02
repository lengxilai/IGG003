//
//  IGMusicUtil.m
//  IGG003
//
//  Created by wu jiabin on 12-7-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGMusicUtil.h"

@implementation IGMusicUtil

//加载音乐
+(void)loadMusic{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shake1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shake2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"refresh.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"orange2.caf"];
}

// 游戏界面的背景音乐
+(void)showBackgroundMusic {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg_music3.caf" loop:YES];
}

// 水果晃动时的音效
+(void)showShakingMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"shake1.caf"];
}

// 水果消除时的音效
+(void)showDeletingMusic {
    //    [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.7];
    [[SimpleAudioEngine sharedEngine] playEffect:@"orange2.caf"];
}

// 水果下落时的音效(重新刷新矩阵)
+(void)showRefreshMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"refresh.caf"];
}
@end
