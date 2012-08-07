//
//  CL04.h
//  IGG003
//
//  Created by wang chong on 12-8-1.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGLayer.h"
#import "S01.h"
#import "S00.h"

@class SL01;
@interface CL04 : IGLayer{
    SL01* currentGameLayer;
}
-(id)init;

-(void)removePauseGameLayer;
-(void)enterGamePauseGameLayer;

@end
