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


@interface CL08 : CCLayer<UITableViewDataSource, UITableViewDelegate>
{
	UITableView*			m_tableView;
    // 数据状态
    IGGameState *m_gameState;
    // 数据显示区分
    int showScoresFlag;
    // 列表数据源
    NSArray* scoreList;
}
// 初始化
- (id) init;

@end
