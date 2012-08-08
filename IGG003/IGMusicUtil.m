//
//  IGMusicUtil.m
//  IGG003
//
//  Created by wu jiabin on 12-7-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGMusicUtil.h"

@implementation IGMusicUtil

-(id) init
{
	return self;
}

//加载音乐
+(void)loadMusic{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shake1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shake2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"delete3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"delete4.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"zhizhu7.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"point.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"refresh.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sawang.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shouwang.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo4.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo5.caf"];
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
   [[SimpleAudioEngine sharedEngine] playEffect:@"zhizhu5.caf"];
}
// 瓢虫消除
+(void)showDeleteOfPiaochongMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"piaochong6.caf"];
}
// 炸弹消除
+(void)showDeleteOfZhadanMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"zhadan4.caf"];
}
// 减分音效
+(void)showDeletePointMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"badpoint.caf"];
}
// 加分音效
+(void)showAddPointMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"point.caf"];
}
// combo音效
+(void)showComboMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"combo1.caf"];
}
+(void)showDeleteMusicWithNumberLoops:(NSString *) musicName ofType:(NSString *) musicType numberOfLoops:(NSInteger) numberOfLoops {
    //在资源库中的路径找指定的caf文件
    NSString *path = [[NSBundle mainBundle] pathForResource:musicName ofType:musicType];
    //在这里判断以下是否能找到这个音乐文件  
    if (path) {  
        //从path路径中 加载播放器  
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:path]error:nil];
        //设置播放循环次数，如果numberOfLoops为负数 音频文件就会一直循环播放下去
        player.numberOfLoops = numberOfLoops;
        //初始化播放器
        [player prepareToPlay];

        [player play];

    }
}

@end
