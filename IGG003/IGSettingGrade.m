//
//  IGSettingGrade.m
//  IGG003
//
//  Created by 鹏 李 on 12-8-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGSettingGrade.h"


@implementation IGSettingGrade


- (int) selectedIndex
{
	return m_menuItemToggle.selectedIndex;
}

- (void) setSelectedIndex:(int)idx
{
	m_menuItemToggle.selectedIndex = idx;
}

- (id) initWithLabelName:(NSString*) labelName toggle0:(NSString*)t0 toggle1:(NSString*)t1
				delegate:(id<IGSettingGradeDelegate>) delegate
{
	[super init];
	
	m_delegate = delegate;
    
    CCLabelBMFont *levelLabel= [CCLabelBMFont labelWithString:labelName fntFile:@"bitmapFont2.fnt"];
	levelLabel.position = ccp(110, 61);
    [self addChild:levelLabel];

    CCSprite* t0Sprite=[CCSprite spriteWithSpriteFrameName:t0];
    CCSprite* t1Sprite=[CCSprite spriteWithSpriteFrameName:t1];
    CCMenuItemSprite *on = [CCMenuItemSprite itemFromNormalSprite:t0Sprite selectedSprite:nil];
    CCMenuItemSprite *off = [CCMenuItemSprite itemFromNormalSprite:t1Sprite selectedSprite:nil];
	m_menuItemToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(startSelected:) items:
                        on,
                        off,
                        nil];
	CCMenu* menu = [CCMenu menuWithItems:m_menuItemToggle, nil];
	[self addChild:menu];
	menu.color = ccc3(255, 255, 0);
	menu.position = ccp(220, 61);
	
	return self;
}

- (void) startSelected:(id)sender
{
	CCMenuItemToggle* menuItem = (CCMenuItemToggle*)sender;
	if (m_delegate)
	{
		[m_delegate changeLayer:self selectIdx:menuItem.selectedIndex];
	}
}

@end
