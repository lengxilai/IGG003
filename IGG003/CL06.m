//
//  CL06.m
//  IGG003
//
//  Created by wang chong on 12-8-9.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  分数统计

#import "CL06.h"

@implementation CL06
-(void)dealloc
{
    [super dealloc];
}
-(id)init
{
    if (self=[super init]) {
        
        //加载游戏终了背景图片
        IGSprite *bak = [IGSprite spriteWithFile:@"paused.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
        
        CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
        CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
        
        CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
        //添加一个返回游戏按钮；
        CCMenu* menu=[CCMenu menuWithItems:menuSprite,nil];
        menu.position=ccp(kWindowW/2, 40);
        [self addChild:menu];
            
        CCLabelBMFont *yourScoreStr = [CCLabelBMFont labelWithString:@"Best Scores:" fntFile:@"bitmapFont.fnt"];
        yourScoreStr.position = ccp(kWindowW/2,300);
        [self addChild:yourScoreStr];
        //取得arcade mode 分数  显示
        [self getArcadeModeScores];
        //取得broken mode分数 不显示
        [self getBrokenModeScores];
    }
    return self;
}
-(void)restartGame
{
    [[CCDirector sharedDirector] replaceScene:[S01 scene]];
}

-(void)gobackMenu
{
    [[CCDirector sharedDirector] replaceScene:[S00 scene:NO]];
}

//读取plist
-(NSArray *)readPlistWithGameMode:(NSString *)gameMode{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [ doc objectAtIndex:0 ]; // 字典集合。  
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",gameMode];
    NSDictionary *dic = [ NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:fileName] ]; // 解析数据
    
    NSString *content = [ dic objectForKey:gameMode ];
    //array是将content里的数据按“,”拆分，仅将两个“,”之间的数据保存。
    NSArray *array = [ content componentsSeparatedByString:@","];
    return array;
}
-(void)showBrokenModeScores{
    //隐藏arcade mode分数
    [self setArcadeModeScoresHidden];
    for(int i = 0; i < 3; i++){
        CCLabelBMFont *scoreStr = (CCLabelBMFont *)[self getChildByTag:600200 + i];
        if(scoreStr){
            [scoreStr setVisible:YES];
        }
    }
}
-(void)showArcadeModeScores{
    //隐藏broken mode 分数
    [self setBrokenModeScoresHidden];
    for(int i = 0; i < 3; i++){
        CCLabelBMFont *scoreStr = (CCLabelBMFont *)[self getChildByTag:600100 + i];
        if(scoreStr){
            [scoreStr setVisible:YES];
        }
    }
}
-(void)setBrokenModeScoresHidden{
    for(int i = 0; i < 3; i++){
        CCLabelBMFont *scoreStr = (CCLabelBMFont *)[self getChildByTag:600200 + i];
        if(scoreStr){
            [scoreStr setVisible:NO];
        }
    }
}
-(void)setArcadeModeScoresHidden{
    for(int i = 0; i < 3; i++){
        CCLabelBMFont *scoreStr = (CCLabelBMFont *)[self getChildByTag:600100 + i];
        if(scoreStr){
            [scoreStr setVisible:NO];
        }
    }
}
-(void)getArcadeModeScores{
    NSArray *array  = [self readPlistWithGameMode:@"arcade"];
    for (int i = 0; i < [array count]; i++) {
        NSLog(@"%@",[array objectAtIndex:i]);
        
        CCLabelBMFont *scoreStr = [CCLabelBMFont labelWithString:[array objectAtIndex:i] fntFile:@"bitmapFont.fnt"];
        scoreStr.position = ccp(kWindowW/2,(250 - i *30));
        scoreStr.tag = 600100 + i;
        [self addChild:scoreStr];
    }
}
-(void)getBrokenModeScores{
    NSArray *array  = [self readPlistWithGameMode:@"broken"];
    for (int i = 0; i < [array count]; i++) {
        NSLog(@"%@",[array objectAtIndex:i]);
        
        CCLabelBMFont *scoreStr = [CCLabelBMFont labelWithString:[array objectAtIndex:i] fntFile:@"bitmapFont.fnt"];
        scoreStr.position = ccp(kWindowW/2,(250 - i *30));
        scoreStr.tag = 600200 + i;
        [scoreStr setVisible:NO];
        [self addChild:scoreStr];
    }
}
@end
