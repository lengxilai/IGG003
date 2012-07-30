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
-(id) init{
    if( (self=[super init])) {
        CCLabelBMFont *pointsSprit = [CCLabelBMFont labelWithString:@"01:00" fntFile:@"bitmapFont.fnt"];
		pointsSprit.position = ccp(40,450);
        pointsSprit.tag = 100001;
       
        [self addChild:pointsSprit z:1 tag:3];
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
        CCMenu *starMenu = [CCMenu menuWithItems:button,button2, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
    }
    return self;
}
- (void) updateTimeDisplay{
    
    times = (int)[time timeIntervalSinceNow];
    CCLabelBMFont *clockLabel = (CCLabelBMFont *)[self getChildByTag:3];
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
    [self unschedule:@selector(updateTimeDisplay)];
    [self schedule:@selector(pauseSchedule) interval:pauseTime];
}
//暂停后调用
-(void)pauseSchedule{
    times = times + 1;
    time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
    [self unschedule:@selector(pauseSchedule)];
    [self schedule:@selector(updateTimeDisplay) interval:0.2];
    
}
//使用加时道具
-(void)clickAddTimeTool{
    times = times + addTime;
    time = [[NSDate dateWithTimeIntervalSinceNow:(times)] retain];
}
@end
