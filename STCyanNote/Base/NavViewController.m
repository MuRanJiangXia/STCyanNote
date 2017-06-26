//
//  NavViewController.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.barTintColor = BlueColor;
    
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 //                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                                 NSFontAttributeName : [UIFont systemFontOfSize:18]
                                                 }];
    
    self.navigationBar.translucent = NO;
    
//    self.navigationController.navigationBar.tintColor = BlueColor;
    
    // 3.设置图片
    UIImage *barImage = [UIImage imageNamed:@"titlebar_bg"];
    // 使用CoreGraphics框架去改变图片原始的大小
    CGImageRef endImageRef = CGImageCreateWithImageInRect(barImage.CGImage, CGRectMake(160, 0, MainScreenWidth, 64));
    barImage = [UIImage imageWithCGImage:endImageRef];
    [self.navigationBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    
    // 释放图片
    CGImageRelease(endImageRef);
//    95 ,78 68
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineView.backgroundColor = CYRGBColor(95, 78, 68);
    [self.view addSubview:lineView];
    
    
    [self.navigationBar addSubview:lineView];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
    
}

@end
