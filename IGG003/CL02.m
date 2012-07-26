//
//  CL02.m
//  IGG003
//  
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  倒计时

#import "CL02.h"

@implementation CL02

-(id) init{
    if( (self=[super init])) {
        CCLabelBMFont *pointsSprit = [CCLabelBMFont labelWithString:@"01:00" fntFile:@"bitmapFont.fnt"];
		pointsSprit.position = ccp(40,450);
        pointsSprit.tag = 100001;
       
        [self addChild:pointsSprit z:1 tag:3];
        time = [[NSDate dateWithTimeIntervalSinceNow:(60)] retain];
        [self schedule:@selector(updateTimeDisplay) interval:1];
    }
    return self;
}
- (void) updateTimeDisplay{
    
    int times = (int)[time timeIntervalSinceNow];
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
@end
