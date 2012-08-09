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
        IGSprite *bak = [IGSprite spriteWithFile:@"cover.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
        CCSprite* restartNormal=[CCSprite spriteWithSpriteFrameName:@"btn6-1.png"];
        CCSprite* restartSecelt=[CCSprite spriteWithSpriteFrameName:@"btn6-2.png"];
        restartSecelt.scale=0.95f;
        
        CCMenuItemSprite* restartSprite=[CCMenuItemSprite itemFromNormalSprite:restartNormal selectedSprite:restartSecelt target:self selector:@selector(restartGame)];
        
        CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
        CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
        restartSecelt.scale=0.95f;
        
        CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
        
        CCMenu* menu=[CCMenu menuWithItems:restartSprite,menuSprite,nil]; //添加一个返回游戏按钮；
        menu.position=ccp(kWindowW/2, 200);
        [menu alignItemsHorizontallyWithPadding:30];
        [self addChild:menu];
        
        CCLabelBMFont *yourScoreStr = [CCLabelBMFont labelWithString:@"Best Scores:" fntFile:@"bitmapFont.fnt"];
        yourScoreStr.position = ccp(120,350);
        [self addChild:yourScoreStr];
        NSArray *array  = [self readPlistWithGameMode:@"arcade"];
        for (int i = 0; i < [array count]; i++) {
            NSLog(@"%@",[array objectAtIndex:i]);
            
            CCLabelBMFont *scoreStr = [CCLabelBMFont labelWithString:[array objectAtIndex:i] fntFile:@"bitmapFont.fnt"];
            scoreStr.position = ccp(40,(300 - i *30));
            [self addChild:scoreStr];
        }
        
    }
    return self;
}
-(void)restartGame
{
    [[CCDirector sharedDirector] replaceScene:[S01 scene]];
}

-(void)gobackMenu
{
    [[CCDirector sharedDirector] replaceScene:[S00 scene]];
}

//读取plist
-(NSArray *)readPlistWithGameMode:(NSString *)gameMode{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [ doc objectAtIndex:0 ]; // 字典集合。  
    
    NSDictionary *dic = [ NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:@"Score.plist"] ]; // 解析数据
    
    NSString *content = [ dic objectForKey:gameMode ];
    //array是将content里的数据按“,”拆分，仅将两个“,”之间的数据保存。
    NSArray *array = [ content componentsSeparatedByString:@","];
    return array;
}
@end
