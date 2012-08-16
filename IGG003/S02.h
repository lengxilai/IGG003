//
//  S02.h
//  IGG003
//
//  Created by wang chong on 12-8-9.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGScene.h"
#import "SL01.h"
#import "CL06.h"
#import "CL07.h"
@interface S02 : IGScene
+(IGScene *) showScores;
-(void)showArcadeModeScores;

// 显示设定页面
+(IGScene *) showSettings;
@end
