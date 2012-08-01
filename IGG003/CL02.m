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
static int pauseTime = 5;
//加时间
static int addTime = 5;
- (void) dealloc
{
	[super dealloc];

}   
-(id) init{
    if( (self=[super init])) {
        CCLabelBMFont *pointsSprit = [CCLabelBMFont labelWithString:@"01:00" fntFile:@"bitmapFont2.fnt"];
		pointsSprit.position = ccp(40,450);
        pointsSprit.tag = 100001;
       
        [self addChild:pointsSprit z:1];
        time = [[NSDate dateWithTimeIntervalSinceNow:(60)] retain];
        [self schedule:@selector(updateTimeDisplay) interval:0.2];
        CCMenuItem  *button = [CCMenuItemImage
                              itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png"
                              target:self selector:@selector(clickAddTimeTool)];
        button.position =  ccp(40, 380);
        CCMenuItem  *button2 = [CCMenuItemImage
                               itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png"
                               target:self selector:@selector(clickIceTool)];
        button2.position =  ccp(80, 380);
        
        CCMenuItem  *button3 = [CCMenuItemImage
                                itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png"
                                target:self selector:@selector(pauseGame)];
        button3.position =  ccp(120, 380);
        CCMenuItem  *button4 = [CCMenuItemImage
                                itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png"
                                target:self selector:@selector(endPause)];
        button4.position =  ccp(160, 380);
        CCMenu *starMenu = [CCMenu menuWithItems:button,button2,button3,button4, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
    }
    return self;
}
- (void) updateTimeDisplay{
    
    times = (int)[time timeIntervalSinceNow];
    CCLabelBMFont *clockLabel = (CCLabelBMFont *)[self getChildByTag:100001];

    if(times ==10){
        [self removeChildByTag:100001 cleanup:true];
        clockLabel = [CCLabelBMFont labelWithString:[self stringForObjectValue:[NSNumber numberWithInt: times]] fntFile:@"bitmapFont.fnt"];
        clockLabel.tag = 100001;
        clockLabel.position = ccp(40,450);
        [self addChild:clockLabel];
    }
    [clockLabel setString:[self stringForObjectValue:[NSNumber numberWithInt: times]]];
    
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
    
    [NSString stringWithFormat:@"0%d", minutesPart] :
    
    [NSString stringWithFormat:@"%d", minutesPart];
    
    NSString *secondsString = (secondsPart < 10) ?
    
    [NSString stringWithFormat:@"0%d", secondsPart] :
    
    [NSString stringWithFormat:@"%d", secondsPart];
    
    return [NSString stringWithFormat:@"%@:%@", minutesString, secondsString];
    
}
//使用冰冻道具
-(void)clickIceTool{
    CCSprite *bg = (CCSprite *)[self getChildByTag:100010];
    if(!bg){
        bg = [CCSprite spriteWithFile:@"pop.png"];
        bg.position = ccp(100,340); //位置
        bg.tag = 100010;
    }
    iceNSDateTime = [[NSDate dateWithTimeIntervalSinceNow:(pauseTime)] retain];
    
    CCFiniteTimeAction *action0 = [CCFadeOut actionWithDuration:1.1];
    CCFiniteTimeAction *action1 = [CCFadeIn actionWithDuration:1.1];
    CCFiniteTimeAction *a3 = [CCSequence actions:action1,action0,action1,action0,nil];
    [bg runAction:a3];
    [self addChild:bg]; //将精灵加到layer上 
    [self unschedule:@selector(updateTimeDisplay)];
    [self schedule:@selector(pauseScheduleByIce) interval:1];
    
}
//冰冻暂停后调用
-(void)pauseScheduleByIce{
    int pauseTimes = (int)[iceNSDateTime timeIntervalSinceNow];
    
    if(pauseTimes <= 0){
        times = times + 1;
        time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
        [self removeChildByTag:100010 cleanup:true];
        [self unschedule:@selector(pauseSchedule)];
        [self schedule:@selector(updateTimeDisplay) interval:0.2];
    }
}
//使用加时道具
-(void)clickAddTimeTool{
    times = times + addTime;
    time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
}
//游戏暂停
-(void)pauseGame{
    [self onExit];
}

-(void)endPause{
    [self onEnter];
}
@end
