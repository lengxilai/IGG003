//
//  CL05.m
//  IGG003
//
//  Created by wang chong on 12-8-7.
//  Copyright (c) 2012年 ntt. All rights reserved.
//gameCenterView

#import "CL05.h"

@implementation CL05
-(void)dealloc
{
    [super dealloc];
}
-(id)init
{
    if (self=[super init]) {
        
        IGGameState *gameState = [IGGameState gameState];
        //未破纪录
        gameState.isBreakBest = NO;
        //加载游戏终了背景图片
        IGSprite *bak = [IGSprite spriteWithFile:@"paused.png"];
        bak.position = ccp(kWindowW/2,kWindowH/2);
        [self addChild:bak];
        
        // GameOver的图片
        IGSprite *gameover = [IGSprite spriteWithSpriteFrameName:@"gameover.png"];
        gameover.position = ccp(kWindowW/2,390);
        [self addChild:gameover];
        
        //restart按钮
        CCSprite* restartNormal=[CCSprite spriteWithSpriteFrameName:@"btn6-1.png"];
        CCSprite* restartSecelt=[CCSprite spriteWithSpriteFrameName:@"btn6-2.png"];
        restartSecelt.scale=0.95f;
        
        CCMenuItemSprite* restartSprite=[CCMenuItemSprite itemFromNormalSprite:restartNormal selectedSprite:restartSecelt target:self selector:@selector(restartGame)];
        //menu按钮
        CCSprite* menuNormal=[CCSprite spriteWithSpriteFrameName:@"btn7-1.png"];
        CCSprite* menuSecelt=[CCSprite spriteWithSpriteFrameName:@"btn7-2.png"];
        restartSecelt.scale=0.95f;
        
        CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemFromNormalSprite:menuNormal selectedSprite:menuSecelt target:self selector:@selector(gobackMenu)];
        //添加菜单
        CCMenu* menu=[CCMenu menuWithItems:restartSprite,menuSprite,nil]; 
        menu.position=ccp(kWindowW/2, 100);
        [menu alignItemsHorizontallyWithPadding:30];
        [self addChild:menu];
        //取得得分
        int score = [self getGameScore];
        
        [self writePlistWithGameMode:[self getGameModeStr] withScore:score];
        
        //得分纪录
        CCLabelBMFont *bestScoreStr = [CCLabelBMFont labelWithString:@"high scores" fntFile:@"bitmapFont.fnt"];
        bestScoreStr.position = ccp(kWindowW/2,260);
        [self addChild:bestScoreStr];
        NSArray *array  = [self readPlistWithGameMode:[self getGameModeStr]];
        for (int i = 0; i < [array count] && i < scoreReadNum; i++) {
            NSLog(@"%@",[array objectAtIndex:i]);
            
            CCLabelBMFont *scoreStr = [CCLabelBMFont labelWithString:[array objectAtIndex:i] fntFile:@"bitmapFont.fnt"];
            scoreStr.position = ccp(kWindowW/2,(230 - i *30));
        
            [self addChild:scoreStr];
        }
        //得分字体
        CCLabelBMFont *yourScoreStr = [CCLabelBMFont labelWithString:@"your score" fntFile:@"bitmapFont.fnt"];
        yourScoreStr.position = ccp(kWindowW/2,330);
        [self addChild:yourScoreStr];

        NSString *scoreStrFile;
        if(!gameState.isBreakBest){
            // 未进排行榜音效
            [IGMusicUtil showMusciByName:@"newscore.caf"];
            //未进入前三名  黑色显示
            scoreStrFile = [NSString stringWithString:@"bitmapFont.fnt"];
        }else{
            // 进排行榜音效
            [IGMusicUtil showMusciByName:@"highscore.caf"];
            //进入前3名  红色显示
            scoreStrFile = [NSString stringWithString:@"bitmapFont2.fnt"];
        }
        CCLabelBMFont *scoreStr= [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",score] fntFile:scoreStrFile];
        scoreStr.position = ccp(kWindowW/2,300);
        [self addChild:scoreStr];
        [self reportScore:score];
    }
    return self;
}
-(void)restartGame
{
    IGGameState *gs = [IGGameState gameState];
    gs.isPaused = NO;
    if (gs.gameMode == IGGameMode1) {
        [[CCDirector sharedDirector] replaceScene:[S01 scene]];
    }else {
        [[CCDirector sharedDirector] replaceScene:[S01 sceneForBroken]];
    }
}

-(void)gobackMenu
{
    [[CCDirector sharedDirector] replaceScene:[S00 scene:YES]];
}

//读取plist
-(NSArray *)readPlistWithGameMode:(NSString *)gameMode{
    //NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //NSString *docPath = [ doc objectAtIndex:0 ]; // 字典集合。  
   // NSString *fileName = [NSString stringWithFormat:@"%@.plist",gameMode];
   // NSDictionary *dic = [ NSDictionary dictionaryWithContentsOfFile:[docPath stringByAppendingPathComponent:fileName] ]; // 解析数据
    
    //NSString *content = [ dic objectForKey:gameMode ];
    //array是将content里的数据按“,”拆分，仅将两个“,”之间的数据保存。
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  //取得

    NSString *content = [ud objectForKey:gameMode];
    NSArray *array = [content componentsSeparatedByString:@","];
    return array;
}
//写入plist
-(void)writePlistWithGameMode:(NSString *)gameMode withScore:(int)score{
    
    // 写入分数
    [[IGGameState gameState] insertScore:score];
    
    NSArray *scoreArr = [self readPlistWithGameMode:gameMode];
    NSMutableArray *newScoreArr = [NSMutableArray arrayWithCapacity:scoreWriteNum];
     IGGameState *gameState = [IGGameState gameState];
    if([scoreArr count] == 0){
        //只有一条纪录不论分数多少都算破纪录
        gameState.isBreakBest = YES;
        [newScoreArr addObject:[NSString stringWithFormat:@"%d",score]];
    }
    
    for(int i = 0 ; i < scoreWriteNum;i++){
        if(i < [scoreArr count]){
            //正常纪录
            int bestScore =[[scoreArr objectAtIndex:i] intValue];
            
            if(bestScore <= score && !gameState.isBreakBest){
                if(i < 3){
                    gameState.isBreakBest = YES;
                }
                [newScoreArr addObject:[NSString stringWithFormat:@"%d",score]];
                if([newScoreArr count] < scoreWriteNum){
                    
                    [newScoreArr addObject:[NSString stringWithFormat:@"%d",bestScore]]; 
                    //破纪录时 进入前3
                }else {
                    break;
                }
            }else {
                [newScoreArr addObject:[NSString stringWithFormat:@"%d",bestScore]];
            }
            //超过条数时
            if([newScoreArr count] >= scoreWriteNum){
                break;
            }
        }else if([scoreArr count] != 0 && !gameState.isBreakBest){
            //纪录中少于三条的时候的最后一条，并且属于破纪录
            if(i < scoreReadNum){
                gameState.isBreakBest = YES;
            }
            [newScoreArr addObject:[NSString stringWithFormat:@"%d",score]];
            break;
        }else{
            break;
        }
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[newScoreArr componentsJoinedByString:@","]  forKey:gameMode];  //保存
    [ud synchronize];
    //　用来覆盖原始数据的新dic
    //NSMutableDictionary *newDic = [[ [ NSMutableDictionary alloc ] init ] autorelease];
    // 将新的dic里的“Score”项里的数据写为“newScore”
    //[newDic setValue:[newScoreArr componentsJoinedByString:@","] forKey:gameMode ];
    // 将　newDic　保存至 docPath＋“Score.plist”文件里，也就是覆盖原来的文件
   // NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *docPath = [ doc objectAtIndex:0 ];
    //NSString *fileName = [NSString stringWithFormat:@"%@.plist",gameMode];
    //[newDic writeToFile:[docPath stringByAppendingPathComponent:fileName] atomically:YES ];

}
-(int)getGameScore{
    IGGameState *gameState = [IGGameState gameState];
    return gameState.m_score;
}
-(NSString*)getGameModeStr{
    IGGameState *gs = [IGGameState gameState];
    if (gs.gameMode == IGGameMode1) {
        return arcadeMode;
    }else {
        return brokenMode;
    }
}
//上传到gamecenter
- (void) reportScore: (int64_t) score{ 
    NSString *gameMode = [self getGameModeStr];
    [IGGameCenterUtil reportScore:score forCategory:gameMode];
}
@end
