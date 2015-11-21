//
//  MainViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lihaowei. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
#import "HomeViewController.h"
#import "VideoViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 3.设置子控制器
    
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVC:home title:@"资讯" image:@"tab_infomation_normal" selectedImage:@"tab_infomation_selected"];
    VideoViewController *video = [[VideoViewController alloc] init];
    [self addChildVC:video title:@"视频" image:@"tab_video_normal" selectedImage:@"tab_video_selected"];
    
    
    
    
    // [self.setValue:tabBar forKeyPath:@"tabBar"];这行代码过后， tabBar的delegate就是TabBarViewController
    // 说明，不用再设置tabBar.delegate = self;
    
    // 如果tabBar 设置完delegate后，再执行这行代码修改delegate，就会报错
    // 如果再次修改tabBar的delegate属性，就会报下面的错误
    // 错误信息：Changeing the delegate of a tab bar managed by a tab bar controller is not allowed
    // 错误意思：不允许修改TabBar的delegate属性（这个TabBar是被TabBarViewController所管理的）
    
    
    // 很多重复代码 ----> 将重复代码抽取到一个方法中
    // 1.相同代码放到一个方法中
    // 2.不同的东西变成参数
    // 3.在使用到这段代码的这个地方调用方法，传递参数
}

// 添加一个子控制器
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器的文字
    childVC.navigationItem.title = title;
    
    childVC.tabBarItem.title = title;
    
    // 设置子控制器的图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    UIImage *homeSelectedImage = [UIImage imageNamed:selectedImage];
    // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    childVC.tabBarItem.selectedImage = [homeSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    NSMutableDictionary *textArrts = [NSMutableDictionary dictionary];
    textArrts[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childVC.tabBarItem setTitleTextAttributes:textArrts forState:UIControlStateNormal];
    NSMutableDictionary *selectTextArrts = [NSMutableDictionary dictionary];
    selectTextArrts[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:selectTextArrts forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    
    UIImage *hearImage = [[UIImage imageNamed:@"tab_heros_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:hearImage style:UIBarButtonItemStyleDone target:self action:@selector(showLeftMenu)];
    
    // 添加为子控制器
    [self addChildViewController:nav];
}

- (void)showLeftMenu {
    [self.sideMenuViewController presentLeftViewController];
}

@end
