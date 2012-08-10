//
//  S02.m
//  IGG003
//
//  Created by wang chong on 12-8-9.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "S02.h"
static S02 *staticS02;
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
    staticS02 = scene;
    
    CL06 *cl06 = [CL06 node];
    [scene addChild:cl06];
    [cl06 setTag:10016];
    //broken mode
    CCSprite* brokenNormal=[CCSprite spriteWithSpriteFrameName:@"btn11-1.png"];
    CCSprite* brokenSecelt=[CCSprite spriteWithSpriteFrameName:@"btn11-2.png"];
    brokenNormal.scale = 0.6f;
    brokenSecelt.scale=0.55f;
    //arcade mode 
    CCSprite* arcadeNormal=[CCSprite spriteWithSpriteFrameName:@"btn11-1.png"];
    CCSprite* arcadeSecelt=[CCSprite spriteWithSpriteFrameName:@"btn11-2.png"];
    arcadeNormal.scale = 0.6f;
    arcadeSecelt.scale=0.55f;
    
    CCMenuItemSprite* brokenSprite=[CCMenuItemSprite itemFromNormalSprite:brokenNormal selectedSprite:brokenSecelt target:scene selector:@selector(showBrokenModeScores)];
    CCMenuItemSprite* arcadeSprite=[CCMenuItemSprite itemFromNormalSprite:arcadeNormal selectedSprite:arcadeSecelt target:scene selector:@selector(showArcadeModeScores)];
    
    CCMenu* menu=[CCMenu menuWithItems:arcadeSprite,brokenSprite,nil];
    [menu alignItemsHorizontallyWithPadding:0];
    menu.position=ccp(150, 350);    
    [scene addChild:menu];
    return scene;
}
-(void)showArcadeModeScores{
    CL06 *cl06 = (CL06 *)[staticS02 getChildByTag:10016];
    [cl06 showArcadeModeScores];
}
-(void)showBrokenModeScores{
    CL06 *cl06 = (CL06 *)[staticS02 getChildByTag:10016];
    [cl06 showBrokenModeScores];
}
@end
