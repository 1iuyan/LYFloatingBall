//
//  LYFloatingBall.h
//  LYFloatingBall
//
//  Created by liuyan on 2018/11/12.
//  Copyright © 2018 liuyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYFloatingBall, LYFloatingBallView;

typedef void(^LYFloatingBallClickHandler)(LYFloatingBall *floatingBall);

@protocol LYFloatingBallDelegate <NSObject>
- (void)didPress:(BOOL)isSelected;
- (void)didPressCoverAction;
- (void)didPressClose;
@end

@interface LYFloatingBall : UIView

+ (instancetype)shareInstance;

- (void)didPressPlayButton:(BOOL)isSelected;

- (void)changeFrame:(BOOL)isSelected;
/**
 初始化只会在当前指定的 view 范围内生效的悬浮球
 当 view 为 nil 的时候，和直接使用 initWithFrame 初始化效果一直，默认为全局生效的悬浮球
 
 @param frame 尺寸
 @param specifiedView 将要显示所在的view
 @param effectiveEdgeInsets 限制显示的范围，UIEdgeInsetsMake(50, 50, -50, -50)
 则表示显示范围周围上下左右各缩小了 50 范围
 @return 生成的悬浮球实例
 */
- (instancetype)initWithFrame:(CGRect)frame
              inSpecifiedView:(nullable UIView *)specifiedView
          effectiveEdgeInsets:(UIEdgeInsets)effectiveEdgeInsets;
/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

/**
 设置ball内部的内容
 
 @param content 内容
 */
- (void)setContent:(id)content;

- (void)autoCloseEdge;

@property (nonatomic,   copy) LYFloatingBallClickHandler clickHandler;

@property (nonatomic, strong) LYFloatingBallView *floatingView;

@property (nonatomic, weak) id<LYFloatingBallDelegate> delegate;
@end

