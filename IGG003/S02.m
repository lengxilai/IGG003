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
    CCSprite* brokenSelect=[CCSprite spriteWithSpriteFrameName:@"btn11-2.png"];

    brokenNormal.scale = 0.8f;
    brokenSelect.scale=0.75f;
    //arcade mode 
    CCSprite* arcadeNormal=[CCSprite spriteWithSpriteFrameName:@"btn1-1.png"];
    CCSprite* arcadeSelect=[CCSprite spriteWithSpriteFrameName:@"btn1-2.png"];
    arcadeNormal.scale = 0.8f;
    arcadeSelect.scale=0.75f;
    
    CCMenuItemSprite *brokenSpriteNormal = [CCMenuItemSprite itemFromNormalSprite:brokenNormal selectedSprite:nil];
    CCMenuItemSprite *brokenSpriteSelect = [CCMenuItemSprite itemFromNormalSprite:brokenSelect selectedSprite:nil];
    CCMenuItemToggle* brokenSprite = [CCMenuItemToggle itemWithTarget:staticS02 selector:@selector(showBrokenModeScores) items:brokenSpriteNormal,brokenSpriteSelect,nil];
    brokenSprite.tag = 600002;
    CCMenuItemSprite *arcadeSpriteNormal = [CCMenuItemSprite itemFromNormalSprite:arcadeNormal selectedSprite:nil];
    CCMenuItemSprite *arcadeSpriteSelect = [CCMenuItemSprite itemFromNormalSprite:arcadeSelect selectedSprite:nil];
    CCMenuItemToggle* arcadeSprite = [CCMenuItemToggle itemWithTarget:staticS02 selector:@selector(showArcadeModeScores) items:arcadeSpriteNormal,arcadeSpriteSelect,nil];
    arcadeSprite.selectedIndex = 1;
    arcadeSprite.tag = 600001;
    CCMenu* menu=[CCMenu menuWithItems:arcadeSprite,brokenSprite,nil];
    [menu alignItemsHorizontallyWithPadding:0];
    menu.tag = 600003;
    menu.position=ccp(kWindowW/2+10, 400);    
    [scene addChild:menu];
    return scene;
}
-(void)showArcadeModeScores{
    CCMenu* menu = (CCMenu*)[staticS02 getChildByTag:600003];
    CCMenuItemToggle* brokenSprite = (CCMenuItemToggle*)[menu getChildByTag:600002];
    brokenSprite.selectedIndex = 0;
    CCMenuItemToggle* arcadeSprite = (CCMenuItemToggle*)[menu getChildByTag:600001];
    arcadeSprite.selectedIndex = 1;
    CL06 *cl06 = (CL06 *)[staticS02 getChildByTag:10016];
    [cl06 showArcadeModeScores];
}
-(void)showBrokenModeScores{
    CCMenu* menu = (CCMenu*)[staticS02 getChildByTag:600003];
    CCMenuItemToggle* brokenSprite = (CCMenuItemToggle*)[menu getChildByTag:600002];
    brokenSprite.selectedIndex = 1;
    CCMenuItemToggle* arcadeSprite = (CCMenuItemToggle*)[menu getChildByTag:600001];
    arcadeSprite.selectedIndex = 0;
    CL06 *cl06 = (CL06 *)[staticS02 getChildByTag:10016];
    [cl06 showBrokenModeScores];
}

// 显示设定页面
+(IGScene *) showSettings{
    IGScene *scene = [S02 node];
    staticS02 = scene;
    CL07 *cL07 = [CL07 node];
    [scene addChild:cL07];
    [cL07 setTag:10017];
    return scene;
}

// 显示关于页面
+(IGScene *) showAbout{
    // 暂时显示分数统计页面
    IGScene *scene = [S02 node];
    staticS02 = scene;
    CL08 *cL08 = [CL08 node];
    [scene addChild:cL08];
    [cL08 setTag:10018];
    return scene;
}
@end
