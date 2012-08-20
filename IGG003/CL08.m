//
//  CL08.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "CL08.h"
#import "AppDelegate.h"


@implementation CL08

- (id) init
{
	[super init];
    
    // 全局数据取得
    m_gameState = [IGGameState gameState];
    
    // 默认显示普通模式分数
    showScoresFlag = 0;
    scoreList = m_gameState.m_scoreListNormal;
    
    // 背景图片
    IGSprite *bak = [IGSprite spriteWithFile:@"sl01.png"];
    bak.position = ccp(kWindowW/2,kWindowH/2);
    [self addChild:bak];
    
    
    // 显示普通模式得分
    CCLabelBMFont *normal= [CCLabelBMFont labelWithString:@"NORMAL" fntFile:@"bitmapFont2.fnt"];
    CCMenuItemLabel *mi = [CCMenuItemLabel itemWithLabel:normal target:self selector:@selector(showNormalScores)];
    
    // 显示破除模式得分
    CCLabelBMFont *broken = [CCLabelBMFont labelWithString:@"BROKEN" fntFile:@"bitmapFont2.fnt"];
    CCMenuItemLabel *mi1 = [CCMenuItemLabel itemWithLabel:broken target:self selector:@selector(showBrokenScores)];
    
    CCMenu* change =[CCMenu menuWithItems:mi,mi1,nil];
    
    change.position=ccp(kWindowW/2, 420);
    [change alignItemsHorizontallyWithPadding:40];
    [self addChild:change];
    
    //添加一个返回游戏按钮；
    CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
    CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
    
    CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
    CCMenu* menu=[CCMenu menuWithItems:menuSprite,nil];
    menu.position=ccp(kWindowW/2, 100);
    [self addChild:menu];
    
	// 分数显示区域
	CGFloat ypos = (self.contentSize.height - 275) - 370 * 0.5;
	const int adjust = 70;
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, ypos + adjust, 300, 370 - adjust)];
	m_tableView.backgroundColor = [UIColor clearColor];
	m_tableView.delegate = self;
	m_tableView.dataSource = self;
	m_tableView.separatorColor = [UIColor clearColor];
    [[[CCDirector sharedDirector] openGLView] addSubview:m_tableView];
	
    
	return self;
}

// 返回菜单页面
-(void)gobackMenu
{
    [m_tableView removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[S00 scene:NO]];
}

// 显示普通模式分数
-(void)showNormalScores
{
    showScoresFlag = 0;
    scoreList = m_gameState.m_scoreListNormal;
    [m_tableView reloadData];
}

// 显示破除模式分数
-(void)showBrokenScores
{
    showScoresFlag = 1;
    scoreList = m_gameState.m_scoreListBroken;
    [m_tableView reloadData];
}


- (void)hideAnimateEnd:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	m_tableView.userInteractionEnabled = TRUE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return 35;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* identifier = @"GameScoresCellIdentifier";
	UITableViewCell* tableViewCell = (UITableViewCell*)[m_tableView dequeueReusableCellWithIdentifier:identifier];
	if (tableViewCell == nil)
	{ 
		tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	tableViewCell.userInteractionEnabled = NO;
	NSInteger idx = [indexPath row];
	NSNumber* scoreNum = [scoreList objectAtIndex:idx];
	NSString* score = [NSString stringWithFormat:@"%d", [scoreNum intValue]];
    tableViewCell.textLabel.text = score;
    tableViewCell.textLabel.textAlignment = UITextAlignmentCenter;
	
	return tableViewCell;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [scoreList count];
}

- (void) dealloc
{
	[m_tableView release];
	[super dealloc];
}

@end
