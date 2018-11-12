//
//  ViewController.m
//  LYFloatingBall
//
//  Created by liuyan on 2018/11/12.
//  Copyright © 2018 liuyan. All rights reserved.
//

#import "ViewController.h"
#import "LYFloatingBall/LYFloatingBall.h"

@interface ViewController ()<LYFloatingBallDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [LYFloatingBall shareInstance].delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonAction {
    [[LYFloatingBall shareInstance] show];
}

#pragma mark LYFloatingBallDelegate
// 播放、暂停处理
- (void)didPress:(BOOL)isSelected {

}

// 点击X关闭操作
- (void)didPressClose {
    
}

// 点击头像操作
- (void)didPressCoverAction {
    
}



@end
