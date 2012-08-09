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
        
        int score = [self getGameScore];
        [self writePlistWithGameMode:@"arcade" withScore:score];
        
        
        
        CCLabelBMFont *yourScoreStr = [CCLabelBMFont labelWithString:@"yourScore:" fntFile:@"bitmapFont.fnt"];
        yourScoreStr.position = ccp(120,350);
        [self addChild:yourScoreStr];
        
            
        CCLabelBMFont *scoreStr = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",score] fntFile:@"bitmapFont.fnt"];
        scoreStr.position = ccp(40,300);
        [self addChild:scoreStr];
        
        
    }
    return self;
}
-(void)restartGame
{
    IGGameState *gs = [IGGameState gameState];
    if (gs.gameMode == IGGameMode1) {
        [[CCDirector sharedDirector] replaceScene:[S01 scene]];
    }else {
        [[CCDirector sharedDirector] replaceScene:[S01 sceneForBroken]];
    }
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
//写入plist
-(void)writePlistWithGameMode:(NSString *)gameMode withScore:(int)score{
    NSArray *scoreArr = [self readPlistWithGameMode:gameMode];
    NSMutableArray *newScoreArr = [[[NSMutableArray alloc] init] autorelease];
    
    if([scoreArr count] == 0){
        [newScoreArr addObject:[NSString stringWithFormat:@"%d",score]];
    }
    
    for(int i = 0 ; i < 3;i++){
        if(i < [scoreArr count]){
            //正常纪录
            int bestScore =[[scoreArr objectAtIndex:i] intValue];
            
            if(bestScore <= score){
                //破纪录时
                [newScoreArr addObject:[NSString stringWithFormat:@"%d",score]];
                if([newScoreArr count] < 3){
                   [newScoreArr addObject:[NSString stringWithFormat:@"%d",bestScore]]; 
                }else {
                    break;
                }
            }else {
                [newScoreArr addObject:[NSString stringWithFormat:@"%d",bestScore]];
            }
            //超过条数时
            if([newScoreArr count] >= 3){
                break;
            }
        }else{
            //纪录中少于三条的时候的最后一条
            [newScoreArr addObject:[NSString stringWithFormat:@"%d",score]];
        }
    }
    
    //　用来覆盖原始数据的新dic
    NSMutableDictionary *newDic = [ [ NSMutableDictionary alloc ] init ];
    // 将新的dic里的“Score”项里的数据写为“newScore”
    [ newDic setValue:[newScoreArr componentsJoinedByString:@","] forKey:@"arcade" ];
    // 将　newDic　保存至 docPath＋“Score.plist”文件里，也就是覆盖原来的文件
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    [newDic writeToFile:[docPath stringByAppendingPathComponent:@"Score.plist"] atomically:YES ];

}
-(int)getGameScore{
    IGGameState *gameState = [IGGameState gameState];
    return gameState.m_score;
}
@end
