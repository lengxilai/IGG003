//
//  CL05.h
//  IGG003
//
//  Created by wang chong on 12-8-7.
//  Copyright (c) 2012年 ntt. All rights reserved.
//

#import "CCLayer.h"
#import "S01.h"
#import "IGGameCenterUtil.h"

@interface CL05 : CCLayer{
}
-(id)init;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
@end
