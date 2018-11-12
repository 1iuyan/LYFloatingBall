//
//  LYFloatingBall.m
//  LYFloatingBall
//
//  Created by liuyan on 2018/11/12.
//  Copyright © 2018 liuyan. All rights reserved.
//

#import "LYFloatingBall.h"
#include <objc/runtime.h>
#import "LYFloatingBallView.h"

#pragma mark - LYFloatingBallWindow
@interface LYFloatingBallWindow : UIWindow

@end

@implementation LYFloatingBallWindow

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    __block LYFloatingBall *floatingBall = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LYFloatingBall class]]) {
            floatingBall = (LYFloatingBall *)obj;
            *stop = YES;
        }
    }];
    
    if (CGRectContainsPoint(floatingBall.bounds,
                            [floatingBall convertPoint:point fromView:self])) {
        return [super pointInside:point withEvent:event];
    }
    
    return NO;
}

@end

#pragma mark - LYFloatingBallManager

@interface LYFloatingBallManager : NSObject
@property (nonatomic, assign) BOOL canRuntime;
@property (nonatomic, weak) UIView *superView;
@end

@implementation LYFloatingBallManager

+ (instancetype)shareManager {
    static LYFloatingBallManager *ballMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ballMgr = [[LYFloatingBallManager alloc] init];
    });
    return ballMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canRuntime = NO;
    }
    return self;
}
@end

#pragma mark - UIView (YDLAddSubview)

@interface UIView (YDLAddSubview)

@end

@implementation UIView (YDLAddSubview)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(addSubview:)), class_getInstanceMethod(self, @selector(mis_addSubview:)));
    });
}

- (void)mis_addSubview:(UIView *)subview {
    [self mis_addSubview:subview];
    if ([LYFloatingBallManager shareManager].canRuntime) {
        if ([[LYFloatingBallManager shareManager].superView isEqual:self]) {
            [self.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[LYFloatingBall class]]) {
                    [self insertSubview:subview belowSubview:(LYFloatingBall *)obj];
                }
            }];
        }
    }
}

@end

@interface LYFloatingBall ()<LYFloatingViewDelegate>
@property (nonatomic, assign) CGPoint centerOffset;
@property (nonatomic, strong) UIView *parentView;
// content
@property (nonatomic, strong) UIView *ballCustomView;

@property (nonatomic, assign) UIEdgeInsets effectiveEdgeInsets;

@end

@implementation LYFloatingBall
#pragma mark - Life Cycle
+ (instancetype)shareInstance {
    static LYFloatingBall *floatBall = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatBall = [[LYFloatingBall alloc] initWithFrame:CGRectMake(0, kScreecHeight - kTabBarHeight - 50, 84, 36)];
    });
    
    return floatBall;
}

- (void)dealloc {
    [LYFloatingBallManager shareManager].canRuntime = NO;
    [LYFloatingBallManager shareManager].superView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame inSpecifiedView:nil effectiveEdgeInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithFrame:(CGRect)frame inSpecifiedView:(UIView *)specifiedView effectiveEdgeInsets:(UIEdgeInsets)effectiveEdgeInsets {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = self.frame.size.height / 2;
        self.clipsToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
        self.layer.shadowOpacity = 0.06;
        self.layer.shadowRadius = 3.5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
        _effectiveEdgeInsets = effectiveEdgeInsets;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        [self addGestureRecognizer:tapGesture];
        [self addGestureRecognizer:panGesture];
        [self configSpecifiedView:specifiedView];
        [self setContent:self.floatingView];
        [self autoCloseEdge];
    }
    return self;
}

- (void)configSpecifiedView:(UIView *)specifiedView {
    if (specifiedView) {
        _parentView = specifiedView;
    }
    else {
        UIWindow *window = [[LYFloatingBallWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = CGFLOAT_MAX; //UIWindowLevelStatusBar - 1;
        window.rootViewController = [UIViewController new];
        window.rootViewController.view.backgroundColor = [UIColor clearColor];
        window.rootViewController.view.userInteractionEnabled = NO;
        [window makeKeyAndVisible];
        
        _parentView = window;
    }
    _parentView.hidden = YES;
    _centerOffset = CGPointMake(_parentView.bounds.size.width * 0.6, _parentView.bounds.size.height * 0.6);
    // setup ball manager
    [LYFloatingBallManager shareManager].canRuntime = YES;
    [LYFloatingBallManager shareManager].superView = specifiedView;
}

#pragma mark - Private Methods
// 靠边
- (void)autoCloseEdge {
    [UIView animateWithDuration:0.5f animations:^{
        // center
        self.center = [self calculatePoisitionWithEndOffset:CGPointZero];//center;
    } completion:^(BOOL finished) {
        
    }];
}

- (CGPoint)calculatePoisitionWithEndOffset:(CGPoint)offset {
    CGFloat ballHalfW   = self.bounds.size.width * 0.5;
    CGFloat parentViewW = self.parentView.bounds.size.width;
    CGPoint center = self.center;
    // 左右
    center.x = (center.x < self.parentView.bounds.size.width * 0.5) ? (ballHalfW - offset.x + self.effectiveEdgeInsets.left) : (parentViewW + offset.x - ballHalfW + self.effectiveEdgeInsets.right);
    if (center.y > kScreecHeight - kTabBarHeight) {
        center.y = kScreecHeight - kTabBarHeight - self.height * 0.5;
    }
    if (center.y < kNavgationBarHeight) {
        center.y = kNavgationBarHeight + self.height * 0.5;
    }
    return center;
}

#pragma mark - Public Methods

- (void)show {
    self.parentView.hidden = NO;
    [self.parentView addSubview:self];
}

- (void)hide {
    self.parentView.hidden = YES;
    [self removeFromSuperview];
}

- (void)visible {
    [self show];
}

- (void)disVisible {
    [self hide];
}

- (void)setContent:(id)content {
    [self.ballCustomView removeFromSuperview];
    NSAssert([content isKindOfClass:[UIView class]], @"can't set ball content with a not uiview content for custom view type");
    [self.ballCustomView setHidden:NO];
    self.ballCustomView = (UIView *)content;
    CGRect frame = self.ballCustomView.frame;
    frame.origin.x = (self.bounds.size.width - self.ballCustomView.bounds.size.width) * 0.5;
    frame.origin.y = (self.bounds.size.height - self.ballCustomView.bounds.size.height) * 0.5;
    self.ballCustomView.frame = frame;
    
    self.ballCustomView.userInteractionEnabled = YES;
    [self addSubview:self.ballCustomView];
}

#pragma mark - GestureRecognizer
// 手势处理
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    if (UIGestureRecognizerStateBegan == panGesture.state) {
        [self setAlpha:1.0f];
    }
    else if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint translation = [panGesture translationInView:self];
        
        CGPoint center = self.center;
        center.x += translation.x;
        center.y += translation.y;
        self.center = center;
        
        CGFloat   leftMinX = 0.0f + self.effectiveEdgeInsets.left;
        CGFloat    topMinY = 0.0f + self.effectiveEdgeInsets.top;
        CGFloat  rightMaxX = self.parentView.bounds.size.width - self.bounds.size.width + self.effectiveEdgeInsets.right;
        CGFloat bottomMaxY = self.parentView.bounds.size.height - self.bounds.size.height + self.effectiveEdgeInsets.bottom;
        
        CGRect frame = self.frame;
        frame.origin.x = frame.origin.x > rightMaxX ? rightMaxX : frame.origin.x;
        frame.origin.x = frame.origin.x < leftMinX ? leftMinX : frame.origin.x;
        frame.origin.y = frame.origin.y > bottomMaxY ? bottomMaxY : frame.origin.y;
        frame.origin.y = frame.origin.y < topMinY ? topMinY : frame.origin.y;
        self.frame = frame;
        
        // zero
        [panGesture setTranslation:CGPointZero inView:self];
    }
    else if (UIGestureRecognizerStateEnded == panGesture.state) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 0.2s 之后靠边
            [self autoCloseEdge];
        });
    }
}

- (void)tapGestureRecognizer:(UIPanGestureRecognizer *)tapGesture {
    __weak __typeof(self) weakSelf = self;
    if (self.clickHandler) {
        self.clickHandler(weakSelf);
    }
    
    //    if ([_delegate respondsToSelector:@selector(didClickFloatingBall:)]) {
    //        [_delegate didClickFloatingBall:self];
    //    }
}

#pragma mark YDLFloatingViewDelegate
- (void)didPressPlayButton:(BOOL)isSelected {
    if (self.delegate && [_delegate respondsToSelector:@selector(didPress:)]) {
        [_delegate didPress:isSelected];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.width = isSelected ? 126 : 84;
        self.floatingView.width = self.width;
        [self autoCloseEdge];
    }];
}

- (void)changeFrame:(BOOL)isSelected {
    self.floatingView.playButton.selected = isSelected;
    [UIView animateWithDuration:0.3 animations:^{
        self.width = isSelected ? 126 : 84;
        self.floatingView.width = self.width;
        [self autoCloseEdge];
    }];
}

- (void)didPressCloseButton {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressClose)]) {
        [_delegate didPressClose];
    }
    [self hide];
}

- (void)didPressTapAction {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressCoverAction)]) {
        [_delegate didPressCoverAction];
    }
    [self hide];
}

- (LYFloatingBallView *)floatingView {
    if (!_floatingView) {
        _floatingView = [[LYFloatingBallView alloc] initWithFrame:CGRectMake(0, 0, 84, 36)];
        _floatingView.backgroundColor = [UIColor whiteColor];
        _floatingView.delegate = self;
    }
    return _floatingView;
}

@end
