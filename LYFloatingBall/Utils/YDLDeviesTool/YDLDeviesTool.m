//
//  YDLDeviesTool.m
//  NewYDLUser
//
//  Created by liuyan on 2018/1/4.
//  Copyright © 2018年 com.yidianling.com. All rights reserved.
//

#import "YDLDeviesTool.h"

@implementation YDLDeviesTool
+ (CGSize)mainScreenSize{
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)isEqualToScreenSize:(CGSize)size{
    return CGSizeEqualToSize(size, [self mainScreenSize]);
}

+ (BOOL)iPhone3_5inch{
    return [self isEqualToScreenSize:CGSizeMake(320.0f, 480.0f)];
}

+ (BOOL)iPhone4inch{
    return [self isEqualToScreenSize:CGSizeMake(320.0f, 568.0f)];
}

+ (BOOL)iPhone4_7inch{
    return [self isEqualToScreenSize:CGSizeMake(375.0f, 667.0f)];
}

+ (BOOL)iPhone5_5inch{
    return [self isEqualToScreenSize:CGSizeMake(414.0f, 736.0f)];
}

+ (BOOL)iPhoneScreen{
    return [self iPhone3_5inch] && [self iPhone4inch] && [self iPhone4_7inch] && [self iPhone5_5inch];
}

+ (BOOL)iPhoneX{
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

+ (CGFloat)navgationHeight{
    return [self iPhoneX] ? 88 : 64;
}

+ (CGFloat)tabBarHeight{
    return [self iPhoneX] ? 83 : 49;
}

+ (CGFloat)bottomHeight{
    return [self iPhoneX] ? 34 : 0;
}

+ (CGFloat)statusBarHeight{
    return [self iPhoneX] ? 44 : 20;
}

+ (NSString *)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}

@end
