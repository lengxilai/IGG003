//
//  IGGameState.h
//  IGT003
//
//  Created by Ming Liu on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 箱子类型 苹果 橙子 柠檬 西瓜 菠萝 草莓 香蕉 葡萄
typedef enum{
    eGbt0 = 0,eGbt1 = 1,eGbt2 = 2,eGbt3 = 3,eGbt4 = 4,eGbt5 = 5,eGbt6 = 6,eGbt7 = 7,eGbt8 = 8,
} GameBoxType;

// 矩阵的状态
typedef enum{
    eGMoving,egNothing,
} GameMatrixType;

// 控制层的状态
typedef enum{
    eCNothing,eCSelected,
} GameControlType;

// 矩阵中的点
struct MxPoint{
    int R;
    int C;
};
typedef struct MxPoint MxPoint;
CG_INLINE MxPoint 
MxPointMake(int r, int c)
{
    MxPoint p; p.R = r; p.C = c; return p;
};

@interface IGGameState : NSObject
{
    NSArray *m;
}
@property(nonatomic,retain) NSArray *m;
+(IGGameState*)gameState;
-(id)init;
@end
