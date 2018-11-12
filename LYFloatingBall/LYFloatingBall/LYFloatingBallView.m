//
//  LYFloatingBallView.m
//  LYFloatingBall
//
//  Created by liuyan on 2018/11/12.
//  Copyright © 2018 liuyan. All rights reserved.
//

#import "LYFloatingBallView.h"
#import "LYFloatingBallButton.h"

@implementation LYFloatingBallView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self uiconfig];
    }
    return self;
}

- (void)uiconfig {
    _coverImageButton = [LYFloatingBallButton buttonWithType:UIButtonTypeCustom];
    _coverImageButton.frame = CGRectMake(4, 4, 28, 28);
    _coverImageButton.layer.cornerRadius = 14;
    _coverImageButton.layer.masksToBounds = YES;
    [_coverImageButton setImage:[UIImage imageNamed:@"dynamic_float_cover"] forState:UIControlStateNormal];
    [_coverImageButton addTarget:self action:@selector(coverAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_coverImageButton];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_coverImageButton.right + 10, 9, 1, 18)];
    line1.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:line1];
    
    _playButton = [LYFloatingBallButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(line1.right + 15, 12, 12, 12);
    [_playButton setImage:[UIImage imageNamed:@"dynamic_home_play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"dynamic_home_stop"] forState:UIControlStateSelected];
    _playButton.selected = NO;
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_playButton.right + 15, 9, 1, 18)];
    line2.backgroundColor = UIColorFromRGB(0xf0f0f0);
    line2.hidden = NO;
    [self addSubview:line2];
    
    _closeButton = [LYFloatingBallButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(line2.right + 12, 10, 16, 16);
    [_closeButton setImage:[UIImage imageNamed:@"dynamic_home_close"] forState:UIControlStateNormal];
    _closeButton.selected = NO;
    _closeButton.hidden = NO;
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_closeButton];
}

- (void)playAction:(UIButton *)button {
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(didPressPlayButton:)]) {
        [_delegate didPressPlayButton:button.selected];
    }
}

- (void)closeAction {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressCloseButton)]) {
        [_delegate didPressCloseButton];
    }
}

- (void)coverAction {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressTapAction)]) {
        [_delegate didPressTapAction];
    }
}

@end
