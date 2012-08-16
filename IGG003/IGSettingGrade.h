//
//  IGSettingGrade.h
//  IGG003
//
//  Created by 鹏 李 on 12-8-14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class IGSettingGrade;
// 更新协议
@protocol IGSettingGradeDelegate
- (void) changeLayer:(IGSettingGrade*)layer selectIdx:(int)idx;
@end

@class	IGSettingGradeSubLayer;
@interface IGSettingGrade : IGLayer {
	id<IGSettingGradeDelegate>	m_delegate;
	CCMenuItemToggle*			m_menuItemToggle;
}

@property (nonatomic, assign)	int selectedIndex;

- (id) initWithLabelName:(NSString*) labelName toggle0:(NSString*)t0 toggle1:(NSString*)t1 delegate:(id<IGSettingGradeDelegate>) delegate;
- (void) startSelected:(id)sender;

@end
