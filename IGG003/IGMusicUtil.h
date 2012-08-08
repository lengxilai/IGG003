//
//  IGMusicUtil.h
//  IGG003
//
//  Created by wu jiabin on 12-7-24.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface IGMusicUtil : NSObject {
    NSInteger firstShow;
    NSInteger endShow;
}

// 加载全部音效
+(void)loadMusic;
// 游戏界面的背景音乐
+(void)showBackgroundMusic:(int) musicId;
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
// 瓢虫消除
+(void)showDeleteOfPiaochongMusic;
// 减分音效
+(void)showDeletePointMusic;
// 炸弹消除
+(void)showDeleteOfZhadanMusic;
// combo音效
+(void)showComboMusic:(NSInteger) comboNum;
//设置指定音效的播放次数
+(void)showDeleteMusicWithNumberLoops:(NSString *) musicName ofType:(NSString *) musicType numberOfLoops:(NSInteger) numberOfLoops;
@end
