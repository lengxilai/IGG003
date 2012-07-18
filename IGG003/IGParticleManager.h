//
//  IGParticleManager.h
//  IGT003
//
//  Created by Ming Liu on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "GameConfig.h"

@interface IGParticleManager : NSObject {
    CCNode *scene;
    NSMutableDictionary *emitters;
}

- (id)initWithScene:(CCNode *)sc;

- (void)add:(int)n particleOfType:(NSString *)t atZ:(int)z;

- (CCParticleSystemQuad *)particleOfType:(NSString *)t;

- (void)dealloc;

@end
