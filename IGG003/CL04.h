//
//  CL04.h
//  IGG003
//
//  Created by wang chong on 12-8-1.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "IGLayer.h"

@class CL01;
@interface CL04 : IGLayer{
    CL01* currentGameLayer;
}
+(id)initWithGamePause:(CL01 *)delegate;

-(void)removePauseGameLayer;
-(void)enterGamePauseGameLayer;

@end
