//
//  S00.m
//  IGG003
//
//  Created by Ming Liu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "S00.h"
#import "IGMusicUtil.h"

@implementation S00
@synthesize gameCenterView;
+(IGScene *) scene:(BOOL) needChangeMusic {
	// 'scene' is an autorelease object.
	IGScene *scene = [S00 node];

    // 游戏状态初始化
    [IGGameState gameState];
    // 从分数画面和设定画面不换背景音乐
    
    if (needChangeMusic) {
        // 菜单背景音乐
        [IGMusicUtil showBackgroundMusic:@"bg_menu.caf"];
    }
	
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
    [scene addChild:bak z:0];
    
    
    // 云彩
    CCSprite *cloud1 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    cloud1.tag = 9801;
    [scene addChild:cloud1 z:10];
    cloud1.position = ccp(160,400);
    
    CCSprite *cloud2 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    cloud2.tag = 9802;
    [scene addChild:cloud2 z:11];
    cloud2.position = ccp(480,400);
    
    CCRepeatForever *cloud1RF = [CCRepeatForever actionWithAction:[CCMoveBy actionWithDuration:1.0 position:ccp(-15,0)]];
    CCRepeatForever *cloud2RF = [CCRepeatForever actionWithAction:[CCMoveBy actionWithDuration:1.0 position:ccp(-15,0)]];
    [cloud1 runAction:cloud1RF];
    [cloud2 runAction:cloud2RF];
    [scene schedule:@selector(cloudMoveCheck) interval:1];
    
    
    // 标题
    CCSprite *bobo = [CCSprite spriteWithSpriteFrameName:@"BOBO.png"];
    [scene addChild:bobo z:20];
    bobo.position = ccp(100,400);
    
    // 太阳
    CCSprite* sunin=[CCSprite spriteWithSpriteFrameName:@"sunin.png"];
    CCSprite* sunout=[CCSprite spriteWithSpriteFrameName:@"sunout.png"];
    [scene addChild:sunin z:5];
    [scene addChild:sunout z:6];
    sunin.position = ccp(260,410);
    sunout.position = ccp(260,410);
    CCRepeatForever *rf = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1.0 angle:20]];
    [sunout runAction:rf];

    
    CCSprite* playNormal=[CCSprite spriteWithSpriteFrameName:@"btn1-1.png"];
    CCSprite* playSecelt=[CCSprite spriteWithSpriteFrameName:@"btn1-2.png"];
    playSecelt.scale=0.95f;
    
    CCSprite* brokenNormal=[CCSprite spriteWithSpriteFrameName:@"btn11-1.png"];
    CCSprite* brokenSecelt=[CCSprite spriteWithSpriteFrameName:@"btn11-2.png"];
    brokenSecelt.scale=0.95f;
    
    CCSprite* scoreNormal=[CCSprite spriteWithSpriteFrameName:@"btn2-1.png"];
    CCSprite* scoreSecelt=[CCSprite spriteWithSpriteFrameName:@"btn2-2.png"];
    scoreSecelt.scale=0.95f;
    
    CCSprite* settingNormal=[CCSprite spriteWithSpriteFrameName:@"btn3-1.png"];
    CCSprite* settingSecelt=[CCSprite spriteWithSpriteFrameName:@"btn3-2.png"];
    settingSecelt.scale=0.95f;
    
    CCSprite* aboutNormal=[CCSprite spriteWithSpriteFrameName:@"btn4-1.png"];
    CCSprite* aboutSecelt=[CCSprite spriteWithSpriteFrameName:@"btn4-2.png"];
    aboutSecelt.scale=0.95f;
    
    CCSprite* gameCenterNormal=[CCSprite spriteWithSpriteFrameName:@"btn4-1.png"];
    CCSprite* gameCenterSecelt=[CCSprite spriteWithSpriteFrameName:@"btn4-2.png"];
    aboutSecelt.scale=0.95f;
    
    CCMenuItemSprite* startSprite=[CCMenuItemSprite itemFromNormalSprite:playNormal selectedSprite:playSecelt target:scene selector:@selector(startGame)];
    CCMenuItemSprite* brokenSprite=[CCMenuItemSprite itemFromNormalSprite:brokenNormal selectedSprite:brokenSecelt target:scene selector:@selector(startGameForBroken)];
    CCMenuItemSprite* scoreSprite=[CCMenuItemSprite itemFromNormalSprite:scoreNormal selectedSprite:scoreSecelt target:scene selector:@selector(showScores)];
    CCMenuItemSprite* settingSprite=[CCMenuItemSprite itemFromNormalSprite:settingNormal selectedSprite:settingSecelt target:scene selector:@selector(showSettings)];
    CCMenuItemSprite* aboutSprite=[CCMenuItemSprite itemFromNormalSprite:aboutNormal selectedSprite:aboutSecelt target:scene selector:@selector(showAbout)];
    CCMenuItemSprite* gameCenterSprite=[CCMenuItemSprite itemFromNormalSprite:gameCenterNormal selectedSprite:gameCenterSecelt target:scene selector:@selector(openGameCenter)];
    
    // 开始游戏按钮
    CCMenu* menu1=[CCMenu menuWithItems:startSprite,brokenSprite,nil];
    menu1.position=ccp(100, 280);    
    [scene addChild:menu1 z:40];
    [menu1 alignItemsVerticallyWithPadding:15];
    
    // 下面的其他按钮
    CCMenu* menu2=[CCMenu menuWithItems:scoreSprite,settingSprite,aboutSprite,gameCenterSprite,nil];
    menu2.position=ccp(75, 140);    
    [scene addChild:menu2 z:41];
    [menu2 alignItemsVerticallyWithPadding:15];    
	return scene;
}

-(void)startGame
{
    //停止菜单音乐
    [IGMusicUtil stopBackGroundMusic];
    [[CCDirector sharedDirector] replaceScene:[S01 scene]];
}

-(void)startGameForBroken
{
    //停止菜单音乐
    [IGMusicUtil stopBackGroundMusic];    
    [[CCDirector sharedDirector] replaceScene:[S01 sceneForBroken]];
}
-(void)showScores{
    [[CCDirector sharedDirector] replaceScene:[S02 showScores]];
}
// 设定页面
-(void)showSettings{
    [[CCDirector sharedDirector] replaceScene:[S02 showSettings]];
}

// 关于页面
-(void)showAbout{
    [[CCDirector sharedDirector] replaceScene:[S02 showAbout]];
}

-(void)cloudMoveCheck{
    CCSprite *cloud1 = [self getChildByTag:9801];
    CCSprite *cloud2 = [self getChildByTag:9802];
    if (cloud1.position.x < -160) {
        [cloud1 removeFromParentAndCleanup:YES];
        cloud2.tag = 9801;
        
        CCSprite *cloud = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
        cloud.tag = 9802;
        [self addChild:cloud z:11];
        cloud.position = ccp(480,400);
        
        CCRepeatForever *cloudRF = [CCRepeatForever actionWithAction:[CCMoveBy actionWithDuration:1.0 position:ccp(-15,0)]];
        [cloud runAction:cloudRF];
    }
}
-(void)openGameCenter{
    
    gameCenterView = [[UIViewController alloc] init];
    
    gameCenterView.view = [[CCDirector sharedDirector] openGLView];
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    
    if (leaderboardController != NULL) 
        
    {
        
        leaderboardController.category = @"arcade";
        
        leaderboardController.leaderboardDelegate = self; 
        
        [gameCenterView presentModalViewController: leaderboardController animated: YES];
        
    }
    
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController 

{
    
    [gameCenterView dismissModalViewControllerAnimated:YES];
    [gameCenterView removeFromParentViewController];
    [gameCenterView release];
    
}
@end
