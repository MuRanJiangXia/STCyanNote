//
//  BaseViewController.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"bg_iphone6"];
    
    self.view.layer.contents = (id)image.CGImage;
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets =NO;
    //设置 btn 不支持多点触控
    [[UIButton appearance] setExclusiveTouch:YES];
    
    NSInteger count = self.navigationController.viewControllers.count;
    
    if (count > 1) {
        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalName:@"back_n.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 1. 返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    // 2. 导航控制器代理
    self.navigationController.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    if (self.navigationController.delegate == self){
    //        self.navigationController.delegate = nil;
    //    }
    
}
#pragma mark - Private Methods
#pragma mark -
#pragma mark Whether need Navigation Bar Hidden
- (BOOL) needHiddenBarInViewController:(UIViewController *)viewController {
    
    BOOL needHideNaivgaionBar = NO;
//    if ([viewController isKindOfClass: [StaffHomeViewController class]] ||
//        [viewController isKindOfClass: [ShopHomeViewController class]]) {
//        needHideNaivgaionBar = YES;
//    }
    
    return needHideNaivgaionBar;
}

#pragma mark - UINaivgationController Delegate
#pragma mark -
#pragma mark Will Show ViewController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden: [self needHiddenBarInViewController: viewController]
                                             animated: animated];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
