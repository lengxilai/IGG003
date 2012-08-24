//
//  IGMusicUtil.h
//  IGG003
//
//  Created by wu jiabin on 12-7-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "IGGameState.h"

@interface IGMusicUtil : NSObject {
}
// 设置碎石flag
+(void)setBreakFlag:(BOOL) bgFlag;
// 取得碎石flag
+(BOOL)getBreakFlag;
// 加载全部音效
+(void)loadMusic;
// 游戏界面的背景音乐
+(void)showBackgroundMusic:(NSString *) musicId;
// 暂停背景音乐
+(void)pauseBackGroundMusic;
// 停止背景音乐
+(void)stopBackGroundMusic;
// 继续播放背景音乐
+(void)resumeBackGroundMusic;
// 根据音效名字播放
+(void)showMusciByName:(NSString *) musicName;
// 水果晃动时的音效
+(void)showShakingMusic;
// 水果消除时的音效
+(void)showDeletingMusic;
// 水果下落时的音效(重新刷新矩阵)
+(void)showRefreshMusic;
// 蜘蛛消除
+(void)showDeleteOfZhizhuMusic;
// 加分音效
+(void)showAddPointMusic;
// 减分音效
+(void)showDeletePointMusic;
// 炸弹消除
+(void)showDeleteOfZhadanMusic;
// combo音效
+(void)showComboMusic:(NSInteger) comboNum;
// 地雷微音音效
+(void)showDileEndMusic;
//设置指定音效的播放次数
+(void)showDeleteMusicWithNumberLoops:(NSString *) musicName ofType:(NSString *) musicType numberOfLoops:(NSInteger) numberOfLoops;
@end
