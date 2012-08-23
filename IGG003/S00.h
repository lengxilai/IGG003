//
//  S00.h
//  IGG003
//
//  Created by Ming Liu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGScene.h"
#import "S01.h"
#import "S02.h"
@interface S00 : IGScene{
    UIViewController *gameCenterView;
}
@property(nonatomic,retain) UIViewController *gameCenterView;
+(IGScene *) scene:(BOOL) needChangeMusic;
-(void)startGame;
@end
