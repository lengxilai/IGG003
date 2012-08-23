//
//  IGGameCenterUtil.h
//  IGG003
//
//  Created by wang chong on 12-8-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<GameKit/GameKit.h>
@interface IGGameCenterUtil : NSObject{
    UIViewController *gameCenterView;
}
-(void)openGameCenter;
-(void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;
-(void) retrieveTopTenScores;
+(void) reportScore: (int64_t) score forCategory: (NSString*) category;
@end
