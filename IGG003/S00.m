//
//  S00.m
//  IGG003
//
//  Created by Ming Liu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "S00.h"

@implementation S00
+(IGScene *) scene{
	// 'scene' is an autorelease object.
	IGScene *scene = [S00 node];
	
    // 添加图片缓存
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"images_default.plist"];
        CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"images_default.png"];
        [scene addChild:batch];
    }
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"img_btn_default.plist"];
        CCSpriteBatchNode* batch = [CCSpriteBatchNode batchNodeWithFile:@"img_btn_default.png"];
        [scene addChild:batch];
    }
    
    IGSprite *bak = [IGSprite spriteWithFile:@"cover.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [scene addChild:bak];
    
    CCSprite* playNormal=[CCSprite spriteWithSpriteFrameName:@"btn1-1.png"];
    CCSprite* playSecelt=[CCSprite spriteWithSpriteFrameName:@"btn1-2.png"];
    playSecelt.scale=0.95f;
    
    CCSprite* scoreNormal=[CCSprite spriteWithSpriteFrameName:@"btn2-1.png"];
    CCSprite* scoreSecelt=[CCSprite spriteWithSpriteFrameName:@"btn2-2.png"];
    scoreSecelt.scale=0.95f;
    
    CCSprite* settingNormal=[CCSprite spriteWithSpriteFrameName:@"btn3-1.png"];
    CCSprite* settingSecelt=[CCSprite spriteWithSpriteFrameName:@"btn3-2.png"];
    settingSecelt.scale=0.95f;
    
    CCSprite* aboutNormal=[CCSprite spriteWithSpriteFrameName:@"btn4-1.png"];
    CCSprite* aboutSecelt=[CCSprite spriteWithSpriteFrameName:@"btn4-2.png"];
    aboutSecelt.scale=0.95f;
    
    CCMenuItemSprite* startSprite=[CCMenuItemSprite itemFromNormalSprite:playNormal selectedSprite:playSecelt target:scene selector:@selector(startGame)];
    CCMenuItemSprite* scoreSprite=[CCMenuItemSprite itemFromNormalSprite:scoreNormal selectedSprite:scoreSecelt target:scene selector:@selector(startGame)];
    CCMenuItemSprite* settingSprite=[CCMenuItemSprite itemFromNormalSprite:settingNormal selectedSprite:settingSecelt target:scene selector:@selector(startGame)];
    CCMenuItemSprite* aboutSprite=[CCMenuItemSprite itemFromNormalSprite:aboutNormal selectedSprite:aboutSecelt target:scene selector:@selector(startGame)];
    
    // 开始游戏按钮
    CCMenu* menu1=[CCMenu menuWithItems:startSprite,nil];
    menu1.position=ccp(100, 300);    
    [scene addChild:menu1];
    
    // 下面的其他按钮
    CCMenu* menu2=[CCMenu menuWithItems:scoreSprite,settingSprite,aboutSprite,nil];
    menu2.position=ccp(75, 160);    
    [scene addChild:menu2];
    [menu2 alignItemsVerticallyWithPadding:30];
    
    
	return scene;
}

-(void)startGame
{
    [[CCDirector sharedDirector] replaceScene:[S01 scene]];
}
@end
