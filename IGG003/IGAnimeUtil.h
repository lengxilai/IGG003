//
//  IGAnimeUtil.h
//  IGT003
//
//  Created by Ming Liu on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpriteBox.h"
#import "IGParticleManager.h"

@class SpriteBox;
@class IGParticleManager;
@interface IGAnimeUtil : NSObject

// 根据箱子类型修改粒子效果
+(ccColor4F)editParticleColorForType:(GameBoxType)bType forParticle:(CCParticleSystemQuad*)popParticle;

// 显示消除箱子时的动画效果
+(void)showRemoveBoxAnime:(SpriteBox*)box forLayer:(CCNode*)sender forParticleManager:(IGParticleManager*)particleManager;
// 准备消除时的晃动效果
+(void)showReadyRemoveBoxAnime:(SpriteBox*)box forLayer:(CCNode*)sender;
+(void)showTools01BoxAnime:(SpriteBox*)box forLayer:(CCNode*)sender forParticleManager:(IGParticleManager*)particleManager;
+(void)showReadyTools01BoxAnime:(SpriteBox*)box forLayer:(CCNode*)sender;
@end
