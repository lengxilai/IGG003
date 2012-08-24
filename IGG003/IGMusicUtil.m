//
//  IGMusicUtil.m
//  IGG003
//
//  Created by wu jiabin on 12-7-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGMusicUtil.h"

@implementation IGMusicUtil

static SimpleAudioEngine *backGroundMusicManager;
static BOOL breakFlag;

//加载音乐
+(void)loadMusic{
    backGroundMusicManager = [SimpleAudioEngine sharedEngine];

    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shake1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"zhizhu7.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"point.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music0.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"refresh.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sawang.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"shouwang.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo0.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo3.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo4.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"combo5.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"dilei5.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"dilei_end.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"heihei.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"badpoint.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"snowfly.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"addtime.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"timeout.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"highscore.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"newscore.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"daojishi.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"ready_go.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"failed.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"buguniao.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"drop.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"xuanzhuan.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"break1.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"break2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bg_music4.m4a"];
}

// 根据音效名字播放
+(void)showMusciByName:(NSString *) musicName {
    [[SimpleAudioEngine sharedEngine] playEffect:musicName];
}

// 游戏界面的背景音乐
+(void)showBackgroundMusic:(NSString *) musicName {
    [backGroundMusicManager playBackgroundMusic:musicName loop:YES];
}

// 暂停背景音乐
+(void)pauseBackGroundMusic {
    [backGroundMusicManager pauseBackgroundMusic];
}
// 继续播放背景音乐
+(void)resumeBackGroundMusic {
    [backGroundMusicManager resumeBackgroundMusic];
}
// 停止背景音乐
+(void)stopBackGroundMusic {
    [backGroundMusicManager stopBackgroundMusic];
}
// 水果晃动时的音效
+(void)showShakingMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"shake1.caf"];
}
// 水果消除时的音效
+(void)showDeletingMusic {
    //    [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.7];
    [[SimpleAudioEngine sharedEngine] playEffect:@"delete5.caf"];
}
// 水果下落时的音效(重新刷新矩阵)
+(void)showRefreshMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"refresh.caf"];
}
// 蜘蛛消除
+(void)showDeleteOfZhizhuMusic {
   [[SimpleAudioEngine sharedEngine] playEffect:@"zhizhu5.caf"];
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
+(void)showComboMusic:(NSInteger) comboNum {
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"combo%d.caf", comboNum]];
}
// 地雷微音音效
+(void)showDileEndMusic {
    [[SimpleAudioEngine sharedEngine] playEffect:@"dilei_end.caf"];
}
//设置指定音效的播放次数
+(void)showDeleteMusicWithNumberLoops:(NSString *) musicName ofType:(NSString *) musicType numberOfLoops:(NSInteger) numberOfLoops {
    
    // 音效关闭的状态下，不播放
    IGGameState *m_gameState = [IGGameState gameState];
    if(!m_gameState.isSoundOn){
        return;
    }
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
+(void)setBreakFlag:(BOOL)bgFlag {
    breakFlag = bgFlag;
}
+(BOOL)getBreakFlag {
    return breakFlag;
}

@end
