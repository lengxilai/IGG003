//
//  CL08.h
//  IGT003
//
//  Created by 鹏 李 on 12-6-22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "IGGameState.h"

typedef enum{
    AppID_TenYearsDiary = 508014699,
    AppID_TripChecker = 529403333,
    AppID_Pomodoro = 533655318,
    AppID_FruitBoBo = 533655318,
}AppID;


@interface CL08 : CCLayer<UIScrollViewDelegate>
{
	UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *views;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
}
// 初始化
- (id) init;

@end
