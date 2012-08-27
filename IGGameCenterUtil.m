//
//  IGGameCenterUtil.m
//  IGG003
//
//  Created by wang chong on 12-8-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGGameCenterUtil.h"

@implementation IGGameCenterUtil
-(void)dealloc{
    [gameCenterView release];
}
-(void)openGameCenter{
    
    gameCenterView = [[UIViewController alloc] init];
    
    gameCenterView.view = [[CCDirector sharedDirector] openGLView];
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    
    if (leaderboardController != NULL) 
        
    {
        
        leaderboardController.category = @"arcade";
        
        leaderboardController.leaderboardDelegate = self; 
        
        [gameCenterView presentModalViewController: leaderboardController animated: YES];
        
    }
    
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [gameCenterView dismissModalViewControllerAnimated:YES];
    [gameCenterView removeFromParentViewController];
}
//上传到gamecenter
+(void) reportScore: (int64_t) score forCategory: (NSString*) category { 
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease]; 
    scoreReporter.value = score; 
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) { 
        if (error != nil) 
        { 
            // handle the reporting error 
            NSLog(@"上传分数出错."); 
            //If your application receives a network error, you should not discard the score. 
            //Instead, store the score object and attempt to report the player’s process at 
            //a later time. 
        }else { 
            NSLog(@"上传分数成功"); 
        } 
        
    }]; 
}
@end
