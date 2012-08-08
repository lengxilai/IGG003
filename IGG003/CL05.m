//
//  CL05.m
//  IGG003
//
//  Created by wang chong on 12-8-7.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CL05.h"

@implementation CL05
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
        [menu alignItemsVerticallyWithPadding:30];
        [self addChild:menu];
        //[self writePlist];
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
-(void)readPlist{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [ doc objectAtIndex:0 ]; // 字典集合。  
    
    NSDictionary *dic = [ NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:@"Score.plist"] ]; // 解析数据
    
    NSString *content = [ dic objectForKey:@"Score" ];
    //array是将content里的数据按“,”拆分，仅将两个“,”之间的数据保存。
    NSArray *array = [ content componentsSeparatedByString:@","];
}
//写入plist
-(void)writePlist{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [ doc objectAtIndex:0 ];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:@"Score.plist"] ]==NO ) {
        
        //　用来覆盖原始数据的新dic
        NSMutableDictionary *newDic = [ [ NSMutableDictionary alloc ] init ];
        // 新数据
        NSString *newScore = @"100,200,300";
        // 将新的dic里的“Score”项里的数据写为“newScore”
        [ newDic setValue:newScore forKey:@"Score" ];
        // 将　newDic　保存至 docPath＋“Score.plist”文件里，也就是覆盖原来的文件
        NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [ doc objectAtIndex:0 ];
        [newDic writeToFile:[docPath stringByAppendingPathComponent:@"Score.plist"] atomically:YES ];
    }
}
@end
