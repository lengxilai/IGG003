//
//  CL05.h
//  IGG003
//
//  Created by wang chong on 12-8-7.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CCLayer.h"
#import "S01.h"
@interface CL05 : CCLayer{
    SL01* currentGameLayer;
}
-(id)init;

-(void)removePauseGameLayer;
-(void)enterGameOverGameLayer;
@end