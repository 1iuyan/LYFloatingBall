//
//  YDLDeviesTool.h
//  NewYDLUser
//
//  Created by liuyan on 2018/1/4.
//  Copyright © 2018年 com.yidianling.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDLDeviesTool : NSObject
/// 3.5吋
+ (BOOL)iPhone3_5inch;

/// 4吋
+ (BOOL)iPhone4inch;

/// 4.7吋
+ (BOOL)iPhone4_7inch;

/// 5.5吋
+ (BOOL)iPhone5_5inch;

+ (BOOL)iPhoneX;

+ (CGFloat)navgationHeight;

+ (CGFloat)tabBarHeight;
+ (CGFloat)bottomHeight;
+ (CGFloat)statusBarHeight;
/// 已知iPhone屏幕
+ (BOOL)iPhoneScreen;

/// 系统版本
+ (NSString *)systemVersion;

@end
