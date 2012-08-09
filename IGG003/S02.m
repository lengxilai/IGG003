//
//  S02.m
//  IGG003
//
//  Created by wang chong on 12-8-9.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "S02.h"

@implementation S02
+(IGScene *) scene{
    IGScene *scene = [S02 node];
//    IGSprite *bak = [IGSprite spriteWithFile:@"cover.png"];
//    bak.position = ccp(kWindowW/2,kWindowH/2);
//    [scene addChild:bak];
    return scene;
}
+(IGScene *) showScores{
    
    IGScene *scene = [S02 node];
    CL06 *cl06 = [CL06 node];
    [scene addChild:cl06];
    [cl06 setTag:10016];
    return scene;
}
@end
