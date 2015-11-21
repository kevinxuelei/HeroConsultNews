//
//  showPictureViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/24.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "showPictureViewController.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>
@interface showPictureViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation showPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self loadImageView];
}

- (void)loadImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageNameUrl] placeholderImage:nil];
    self.imageView.centerX = self.view.centerX;
    self.imageView.centerY = self.view.centerY;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
