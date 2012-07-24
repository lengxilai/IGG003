//
//  SpriteBox.h
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IGSprite.h"

@interface SpriteBox : IGSprite
{
    GameBoxType bType;
    BOOL isTarget;
}
@property(nonatomic)GameBoxType bType;
@property(nonatomic)BOOL isTarget;
+(id)spriteBoxWithType:(GameBoxType)type;
+(id)spriteBoxWithRandomType;
@end
