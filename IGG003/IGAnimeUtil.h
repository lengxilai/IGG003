//
//  IGAnimeUtil.h
//  IGT003
//
//  Created by Ming Liu on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGBoxTools01.h"

@class SpriteBox;
@class IGParticleManager;
@class IGBoxBase;
@class IGBoxTools01;
@interface IGAnimeUtil : NSObject


// 根据箱子类型修改粒子效果
+(ccColor4F)editParticleColorForType:(GameBoxType)bType forParticle:(CCParticleSystemQuad*)popParticle;

// 显示消除箱子时的动画效果
+(void)showRemoveBoxAnime:(SpriteBox*)box forBoxBase:(IGBoxBase*)boxBase;
// 准备消除时的晃动效果
+(void)showReadyRemoveBoxAnime:(SpriteBox*)box forBoxBase:(IGBoxBase*)boxBase;


+(void)showReadyTools01BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase;
+(void)showTools01BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase;

+(void)showTools06BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase;
+(void)showReadyTools06BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase;

+(void)showTools05BoxAnime:(SpriteBox*)box forBoxBase:(IGBoxTools01*)boxBase;
@end
