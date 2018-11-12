//
//  LYFloatingBallView.h
//  LYFloatingBall
//
//  Created by liuyan on 2018/11/12.
//  Copyright © 2018 liuyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYFloatingViewDelegate <NSObject>
- (void)didPressPlayButton:(BOOL)isSelected;
- (void)didPressCloseButton;
- (void)didPressTapAction;
@end

NS_ASSUME_NONNULL_BEGIN

@interface LYFloatingBallView : UIView
@property (nonatomic, strong) UIButton *coverImageButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, weak) id<LYFloatingViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
