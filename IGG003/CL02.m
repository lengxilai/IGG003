//
//  CL02.m
//  IGG003
//  
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  倒计时

#import "CL02.h"

@implementation CL02
//暂停时间

//加时间

//字体变化到倍数

//倒计时tag

static CL02 *staticCL02;

- (void) dealloc
{
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
        time = [[NSDate dateWithTimeIntervalSinceNow:(delaySeconds)] retain];
        //前一秒等于倒计时长
        persecond = delaySeconds;
        //调用倒计时方法
        [self schedule:@selector(updateTimeDisplay) interval:0.1];
        //暂停按钮
        CCMenuItem  *button3 = [CCMenuItemImage
                                itemFromNormalImage:@"pause-1.png" selectedImage:@"pause-1.png"
                                target:self selector:@selector(pauseGame)];
        button3.position =  ccp(35, 420);
        CCMenu *starMenu = [CCMenu menuWithItems:button3, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
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
    
    times = (int)[time timeIntervalSinceNow];
    CCLabelBMFont *clockLabel = (CCLabelBMFont *)[self getChildByTag:timeTag];
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
        if(times != persecond){
            persecond = times;
            id action0 = [CCScaleTo actionWithDuration:0.2 scale:fontSizeTo];
            id action1 = [CCScaleTo actionWithDuration:0.3 scale:1];
            [clockLabel runAction:[CCSequence actions:action0, action1, nil]]; 
        }
        
    }
    
    if(times <= 0){
        
        [self unschedule:@selector(updateTimeDisplay)];
    }
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
    iceNSDateTime = [[NSDate dateWithTimeIntervalSinceNow:(pauseTime)] retain];
    //停止倒计时
    [self unschedule:@selector(updateTimeDisplay)];
    [self unschedule:@selector(pauseScheduleByIce)];
    //冰冻计时开始
    [self schedule:@selector(pauseScheduleByIce) interval:1];
    
}
//冰冻暂停 记时
-(void)pauseScheduleByIce{
    int pauseTimes = (int)[iceNSDateTime timeIntervalSinceNow];
    
    if(pauseTimes <= 0){
        //冰冻效果结束
        //为了时间显示正常  这里加一处理
        //times = times + 1;
        //重新计算时间
        time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
        //删除冰冻层
        [self removeChildByTag:iceBgTag cleanup:true];
        //停止冰冻效果
        [self unschedule:@selector(pauseScheduleByIce)];
        //继续计时  
        [self schedule:@selector(updateTimeDisplay) interval:0.1];
        iceFlg = 0;
    }
}
#pragma mark -
#pragma mark 加时
//使用加时道具
-(void)clickAddTimeTool{
    times = times + addTime;
    time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
    [self unschedule:@selector(pauseScheduleByIce)];
    //冰冻计时开始
    [self schedule:@selector(pauseScheduleByIce) interval:1];
}

#pragma mark -
#pragma mark happytime
-(void)clickHappyTimeTool{
    happyTimeFlg = 1;
    happyTimeNSDateTime = [[NSDate dateWithTimeIntervalSinceNow:(happytime)] retain];
    [self unschedule:@selector(scheduleForHappyTime)];
    IGGameState *gameState = [IGGameState gameState];
    gameState.isHappyTime = YES;
    //冰冻计时开始
    [self schedule:@selector(scheduleForHappyTime) interval:1];
}
//happytime 记时
-(void)scheduleOfHappytime{
    int happyTimeDelay = (int)[happyTimeNSDateTime timeIntervalSinceNow];
    
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
    
    
    if(iceFlg == 1){
        iceDelayTime = (float)[iceNSDateTime timeIntervalSinceNow];
        
        [self unschedule:@selector(pauseScheduleByIce)];
    }
    if(happyTimeFlg == 1){
        happytimeDelayTime = (float)[happyTimeNSDateTime timeIntervalSinceNow];
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
    time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
    if(iceFlg == 1){
        iceNSDateTime = [[NSDate dateWithTimeIntervalSinceNow:(iceDelayTime)] retain];
        [self schedule:@selector(pauseScheduleByIce) interval:1];
    }
    
    if(happyTimeFlg == 1){
        happyTimeNSDateTime = [[NSDate dateWithTimeIntervalSinceNow:(happytimeDelayTime)] retain];
        [self schedule:@selector(scheduleForHappyTime) interval:1];
    }
    //继续计时  
    [self schedule:@selector(updateTimeDisplay) interval:0.1];
}
@end
