//
//  TabBarViewController.m
//  STCyanNote
//
//  Created by cyan on 2017/6/12.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "NavViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  creatVC];
    
   
}

-(void)creatVC{
    
    
    NSLog(@"childViewControllers : %@",self.childViewControllers);
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x333333, 1.0),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x01A9EF, 1.0),
                                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                        
                                                        } forState:UIControlStateSelected];
    
    self.automaticallyAdjustsScrollViewInsets=NO;


    
    
    
    HomeViewController *mineVC = [[HomeViewController alloc] init];
    NavViewController *navc=[[NavViewController alloc] initWithRootViewController:mineVC];
    navc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                     image:[UIImage imageWithOriginalName:@"mine_normal"]
                                             selectedImage:[UIImage imageWithOriginalName:@"mine_selected"]];
    
    
    
    [self setViewControllers:@[navc ] animated:NO];
    


}

@end
