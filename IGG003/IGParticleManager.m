//
//  IGParticleManager.m
//  IGT003
//
//  Created by Ming Liu on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGParticleManager.h"

@implementation IGParticleManager
- (id)initWithScene:(CCNode *)sc {
    if (!(self = [super init])) return nil;
    
    emitters = [[NSMutableDictionary alloc] init];
    scene = sc;
    
    return self;
}

- (void)add:(int)n particleOfType:(NSString *)t atZ:(int)z {
    NSMutableArray *eot = [emitters objectForKey:t];
    if (!eot) {
        eot = [[NSMutableArray alloc] init];
        [emitters setObject:[eot autorelease] forKey:t];
    }
    
    for (int i = 0; i < n; i++) {
        CCParticleSystemQuad *em = [CCParticleSystemQuad particleWithFile:[t stringByAppendingString:@".plist"]];
        [eot addObject:em];
        em.positionType = kCCPositionTypeFree;
        [em stopSystem];
        [scene addChild:em z:z];
    }
}

- (CCParticleSystemQuad *)particleOfType:(NSString *)t {
    NSMutableArray *eot = [emitters objectForKey:t];
    if (!eot) return nil;
    
    NSEnumerator *en = [eot objectEnumerator];
    CCParticleSystemQuad *em;
    while ((em = [en nextObject])) {
        if (!em.active) return em;
    }
    NSLog(@"Not enough %s emitters.", [t UTF8String]);
    return nil;
}

- (void)dealloc {
    [emitters release];
    [super dealloc];
}
@end
