//
//  CL03.h
//  IGG003
//
//  Created by wang chong on 12-7-23.
//  Copyright (c) 2012年 ntt. All rights reserved.
//  points control

#import "IGLayer.h"

@interface CL03 : IGLayer
{
    // 连击数
    int comboNum;
    // 总分数
    int totalPoints;
    int addedPoint;
    int addedTotalPoint;
    BOOL addPointFlag;
    BOOL addPointFlag2;
    CCLabelBMFont *pointsSprit;
    CCLabelBMFont *comboSprit;
    CCLabelBMFont *addPointSprite;
    CCLabelBMFont *addComboSprite;
}
+(CL03*)getCL03;
-(void)getTotalPoint:(ccTime)dt;
<<<<<<< HEAD
-(id)addPointForBoxNum:(int)boxNum forPosition:(CGPoint) position;
=======
-(id)addPointForBoxNum:(int)boxNum forPoint:(CGPoint) position;
>>>>>>> 320267d25506a9971cba139dc85a671a0f8707c3
-(void)changePointWithPoint;
-(void)setPointPlace:(int)totalPoint comboNum: (int) comNum;
-(void)showPointAndCombo:(CGPoint) position;
@end
