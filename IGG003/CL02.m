//
//  CL02.m
//  IGG003
//  
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  倒计时

#import "CL02.h"
#import "IGMusicUtil.h"

@implementation CL02
@synthesize iceNSDateTime;
@synthesize happyTimeNSDateTime;
@synthesize time;
@synthesize dateClick;

static CL02 *staticCL02;

- (void) dealloc
{
    [iceNSDateTime release];
    [time release];
    [happyTimeNSDateTime release];
    [dateClick release];
	[super dealloc];

}   
-(id) init{
    if( (self=[super init])) {
        //倒计时显示  初始化1:00
        CCLabelBMFont *pointsSprit = [CCLabelBMFont labelWithString:@"1:00" fntFile:@"bitmapFont.fnt"];
		pointsSprit.position = ccp(timeFontX,timeFontY);
        pointsSprit.tag = timeTag;
        //没有冰冻效果
        iceFlg = 0;
        //没有happytime
        happyTimeFlg = 0;
        
        [self addChild:pointsSprit z:1];
        //计算倒计时长
        self.time = [NSDate dateWithTimeIntervalSinceNow:(delaySeconds)];
        //前一秒等于倒计时长
        persecond = delaySeconds;
        //调用倒计时方法
        [self schedule:@selector(updateTimeDisplay) interval:0.1];
        // 倒计时音效
        [self schedule:@selector(showDaojishiMusic) interval:1];
        CCSprite *iceImg = [CCSprite spriteWithFile:@"bing.png"];
        iceImg.tag = 200050;
        iceImg.position = ccp(timeFontX+5,timeFontY+5);
        iceImg.visible = NO;
        [self addChild:iceImg z:5];
        //暂停按钮
        //CCSprite* playNormal=[CCSprite spriteWithSpriteFrameName:@"btn10-2.png"];
        //CCSprite* playSecelt=[CCSprite spriteWithSpriteFrameName:@"btn10-2.png"];
        //CCMenuItem  *button3 = [CCMenuItemImage
        //itemFromNormalSprite:playNormal selectedSprite:playSecelt
        //target:self selector:@selector(pauseGame)];
        //button3.position =  ccp(35, 420);
        //CCMenu *starMenu = [CCMenu menuWithItems:button3, nil];
        //starMenu.position = CGPointZero;
        //[self addChild:starMenu];
    }
    staticCL02 = self;
    return self;
}

+(CL02*)getCL02
{
    if (staticCL02 == nil) {
        staticCL02 = [CL02 node];
        return staticCL02;
    }else {
        return staticCL02;
    }
}
#pragma mark -
#pragma mark 倒计时
//倒计时更新
- (void) updateTimeDisplay{
    
    times = (int)[self.time timeIntervalSinceNow];
    CCLabelBMFont *clockLabel = nil;
    
    //判断时间是否变化
    if(times != persecond){
        //改变引用的字体文件
        if(times <=10){
            [self removeChildByTag:timeTag cleanup:true];
            clockLabel = [CCLabelBMFont labelWithString:[self stringForObjectValue:[NSNumber numberWithInt: times]] fntFile:@"bitmapFont2.fnt"];
            clockLabel.tag = timeTag;
            clockLabel.position = ccp(timeFontX,timeFontY);
            [self addChild:clockLabel];
        }else{
            [self removeChildByTag:timeTag cleanup:true];
            clockLabel = [CCLabelBMFont labelWithString:[self stringForObjectValue:[NSNumber numberWithInt: times]] fntFile:@"bitmapFont.fnt"];
            clockLabel.tag = timeTag;
            clockLabel.position = ccp(timeFontX,timeFontY);
            [self addChild:clockLabel];
        }
        [clockLabel setString:[self stringForObjectValue:[NSNumber numberWithInt: times]]];
        
        //倒计时动画
        if(times <= 10){
            
                persecond = times;
                id action0 = [CCScaleTo actionWithDuration:0.2 scale:fontSizeTo];
                id action1 = [CCScaleTo actionWithDuration:0.3 scale:1];
                [clockLabel runAction:[CCSequence actions:action0, action1, nil]]; 
           
            
        }
        IGGameState *gameState = [IGGameState gameState];
        //游戏结束
        if(times <= 0){
            if (gameState.gameMode==1) {
                //结束音效
                [self performSelector:@selector(showGameOverMusic) withObject:nil afterDelay:0.1];
            }
            [self unschedule:@selector(updateTimeDisplay)];
            [self overGame];
        }
    }
}
#pragma mark 倒计时音效
-(void) showDaojishiMusic {
    IGGameState *gameState = [IGGameState gameState];
    // 倒计时音效
    if (times <= kDaojishiSoundTime && times>3 && gameState.gameMode==1) {
        [IGMusicUtil showMusciByName:@"daojishi.caf"];
    } else if (times <= 3 && times>0 && gameState.gameMode==1) {
        [IGMusicUtil showMusciByName:@"buguniao.caf"];
    }
}
#pragma mark 结束音效
-(void) showGameOverMusic {
    // 背景音乐停止
    [IGMusicUtil stopBackGroundMusic];
    // 时间到音效
    [IGMusicUtil showMusciByName:@"timeout.caf"];
}
//将时间转换为字符串11：11结构
- (NSString *)stringForObjectValue:(id)anObject{
    
    if (! [anObject isKindOfClass: [NSNumber class]]) {
        
        return nil;
        
    }
    
    NSNumber *secondsNumber = (NSNumber*) anObject;
    
    int seconds = [secondsNumber intValue];
    
    int minutesPart = seconds / 60;
    
    int secondsPart = seconds % 60;
    
    NSString *minutesString = (minutesPart < 10) ?
    
    [NSString stringWithFormat:@"%d", minutesPart] :
    
    [NSString stringWithFormat:@"%d", minutesPart];
    
    NSString *secondsString = (secondsPart < 10) ?
    
    [NSString stringWithFormat:@"0%d", secondsPart] :
    
    [NSString stringWithFormat:@"%d", secondsPart];
    
    return [NSString stringWithFormat:@"%@:%@", minutesString, secondsString];
    
}
#pragma mark -
#pragma mark 冰冻效果
//使用冰冻道具
-(void)clickIceTool{
    iceFlg = 1;
    CCSprite *iceImg = (CCSprite *)[self getChildByTag:200050];
    iceImg.visible = YES;
    self.iceNSDateTime = [NSDate dateWithTimeIntervalSinceNow:(pauseTime)];
    //停止倒计时
    [self unschedule:@selector(updateTimeDisplay)];
    [self unschedule:@selector(pauseScheduleByIce)];
    //冰冻计时开始
    [self schedule:@selector(pauseScheduleByIce) interval:1];
    
}
//冰冻暂停 记时
-(void)pauseScheduleByIce{
    int pauseTimes = (int)[self.iceNSDateTime timeIntervalSinceNow];
    
    if(pauseTimes <= 0){
        //冰冻效果结束
        //为了时间显示正常  这里加一处理
        //times = times + 1;
        //重新计算时间
        self.time = [NSDate dateWithTimeIntervalSinceNow:(times)];
        //删除冰冻层
        [self removeChildByTag:iceBgTag cleanup:true];
        //停止冰冻效果
        [self unschedule:@selector(pauseScheduleByIce)];
        //继续计时  
        [self schedule:@selector(updateTimeDisplay) interval:0.1];
        iceFlg = 0;
        CCSprite *iceImg = (CCSprite *)[self getChildByTag:200050];
        iceImg.visible = NO;
    }
}
#pragma mark -
#pragma mark 加时
//使用加时道具
-(void)clickAddTimeTool{
    times = times + addTime;
    self.time = [NSDate dateWithTimeIntervalSinceNow:(times)];
    [self unschedule:@selector(pauseScheduleByIce)];
    //冰冻计时开始
    [self schedule:@selector(pauseScheduleByIce) interval:1];
}

#pragma mark -
#pragma mark happytime
-(void)clickHappyTimeTool{
    happyTimeFlg = 1;
    self.happyTimeNSDateTime = [NSDate dateWithTimeIntervalSinceNow:(happytime)];
    [self unschedule:@selector(scheduleForHappyTime)];
    IGGameState *gameState = [IGGameState gameState];
    gameState.isHappyTime = YES;
    //冰冻计时开始
    [self schedule:@selector(scheduleForHappyTime) interval:1];
}
//happytime 记时
-(void)scheduleForHappyTime{
    int happyTimeDelay = (int)[self.happyTimeNSDateTime timeIntervalSinceNow];
    
    if(happyTimeDelay <= 0){
        //happy time 结束
        happyTimeFlg = 0;
        IGGameState *gameState = [IGGameState gameState];
        gameState.isHappyTime = NO;
        [self unschedule:@selector(scheduleForHappyTime)];
    }
}
#pragma mark -
#pragma mark 暂停再开始
//游戏暂停
-(void)pauseGame{
    [self unschedule:@selector(updateTimeDisplay)];
    IGGameState *gameState = [IGGameState gameState];
    gameState.isPaused = YES;
    
    if(iceFlg == 1){
        iceDelayTime = (float)[self.iceNSDateTime timeIntervalSinceNow];
        
        [self unschedule:@selector(pauseScheduleByIce)];
    }
    if(happyTimeFlg == 1){
        happytimeDelayTime = (float)[self.happyTimeNSDateTime timeIntervalSinceNow];
        [self unschedule:@selector(scheduleForHappyTime)];
    }
    
    S01 *s01 = [S01 getS01];
    [s01 pauseGame];
}
//游戏再开始
-(void)endPause{
    //为了时间显示正常  这里加一处理
    //times = times + 1;
    //重新计算时间
    self.time = [NSDate dateWithTimeIntervalSinceNow:(times)];
    if(iceFlg == 1){
        self.iceNSDateTime = [NSDate dateWithTimeIntervalSinceNow:(iceDelayTime)];
        [self schedule:@selector(pauseScheduleByIce) interval:1];
    }
    
    if(happyTimeFlg == 1){
        self.happyTimeNSDateTime = [NSDate dateWithTimeIntervalSinceNow:(happytimeDelayTime)];
        [self schedule:@selector(scheduleForHappyTime) interval:1];
    }
    //继续计时  
    [self schedule:@selector(updateTimeDisplay) interval:0.1];
}
#pragma mark -
#pragma mark 游戏结束
-(void)overGame{
    S01 *s01 = [S01 getS01];
    [s01 overGame];
}

-(void)getDateNow{
    self.dateClick = [NSDate date];
}
-(int)getSecondsBetweenDate{
    NSTimeInterval late=[self.dateClick timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    return cha;
}
@end
