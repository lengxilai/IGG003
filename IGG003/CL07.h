//
//  CL07.h
//  IGG003
//
//  Created by 鹏 李 on 12-8-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IGSettingGrade.h"
#import "S01.h"
#import "IGGameState.h"

@interface CL07 : CCLayer {
    // 音效区
	IGSettingGrade*	m_soundLayer;
	// 背景音乐区
    IGSettingGrade*	m_musicLayer;
    // 数据状态
    IGGameState *m_gameState;
    
}
-(id)init;

@end
