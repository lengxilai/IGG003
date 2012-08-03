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
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"delete3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"delete4.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"zhizhu.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"point.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"refresh.caf"];
//    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"piaochong.caf"];
//    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"piaochong2.caf"];
//    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"piaochong5.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"piaochong6.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"zhandan.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"zhandan2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"badpoint.caf"];
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
    [[SimpleAudioEngine sharedEngine] playEffect:@"delete4.caf"];
}

// 水果下落时的音效(重新刷新矩阵)
+(void)showRefreshMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"refresh.caf"];
}

// 蜘蛛消除
+(void)showDeleteOfZhizhuMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"zhizhu.caf"];
}
// 瓢虫消除
+(void)showDeleteOfPiaochongMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"piaochong6.caf"];
}
// 炸弹消除
+(void)showDeleteOfZhadanMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"zhadan2.caf"];
}
// 减分音效
+(void)showDeletePointMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"badpoint.caf"];
}
// 加分音效
+(void)showAddPointMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"point.caf"];
}
@end
