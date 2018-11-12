//
//  LYFloatingBallButton.m
//  LYFloatingBall
//
//  Created by liuyan on 2018/11/12.
//  Copyright © 2018 liuyan. All rights reserved.
//

#import "LYFloatingBallButton.h"

@implementation LYFloatingBallButton
// 扩大button点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -10, -10);
    return CGRectContainsPoint(bounds, point);
}

@end
