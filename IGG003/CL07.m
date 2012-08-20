//
//  CL07.m
//  IGG003
//
//  Created by 鹏 李 on 12-8-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CL07.h"


@implementation CL07

-(id)init
{
    if (self=[super init]) {
        
        // 背景图片
        IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
        
        // 提示字
        CCLabelBMFont *levelLabel= [CCLabelBMFont labelWithString:@"Settings" fntFile:@"bitmapFont2.fnt"];
        levelLabel.position = ccp(kWindowW/2, 460);
        [self addChild:levelLabel];
        
        // 取得全局数据
        m_gameState = [IGGameState gameState];
        CGSize contentSize = self.contentSize;
        // 音效	
        m_soundLayer = [[IGSettingGrade alloc] initWithLabelName:@"SOUND:" 
                                                           toggle0:@"btn8-1.png"
                                                           toggle1:@"btn8-2.png"
                                                          delegate:self];
        m_soundLayer.anchorPoint = ccp(0.5, 0.5);
        m_soundLayer.position = ccp(0, contentSize.height - 200);
        m_soundLayer.selectedIndex = m_gameState.isSoundOn == YES? 0 : 1;
        [self addChild:m_soundLayer];
       
        
        // 背景音乐
        m_musicLayer = [[IGSettingGrade alloc] initWithLabelName:@"MUSIC:" 
                                                           toggle0:@"btn9-1.png"
                                                           toggle1:@"btn9-2.png"
                                                          delegate:self];
        m_musicLayer.anchorPoint = ccp(0.5, 0.5);
        m_musicLayer.position = ccp(0, contentSize.height - 325);
        [self addChild:m_musicLayer];
        
        m_musicLayer.selectedIndex = m_gameState.isMusicOn == YES? 0 : 1;
        
         //添加一个返回游戏按钮；
        CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
        CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
        
        CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
        CCMenu* menu=[CCMenu menuWithItems:menuSprite,nil];
        menu.position=ccp(kWindowW/2, 100);
        [self addChild:menu];
    }
    return self;
}

// 音效和音乐开关
- (void) changeLayer:(IGSettingGrade*)layer selectIdx:(int)idx
{
	if (layer == m_soundLayer)
	{
		m_gameState.isSoundOn = (idx == 0?YES:NO);
        [m_gameState soundContorl];
	}
	else if (layer == m_musicLayer)
	{
		m_gameState.isMusicOn = (idx == 0?YES:NO);
        [m_gameState musicContorl];
	}
}

-(void)gobackMenu
{
    // 保存设置数据
    [m_gameState save];
    [[CCDirector sharedDirector] replaceScene:[S00 scene]];
}

- (void) dealloc
{
	[m_soundLayer release];
	[m_musicLayer release];
	[super dealloc];
}

@end
