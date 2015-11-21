//
//  LeftViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/29.
//  Copyright © 2015年 lihaowei. All rights reserved.
//

#import "LeftViewController.h"
#import "UIView+Extension.h"
#import "AppDelegate.h"
@interface LeftViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hearNameLabel;
@property (nonatomic, strong) UILabel *serverNameLabel;
@property (nonatomic, strong) UITextField *hearNameTextField;
@property (nonatomic, strong) UIButton *serverNameButton;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LeftViewController
//http://lolbox.duowan.com/phone/apiServers.php
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.view.frame.size.width - 20, 30)];
    self.titleLabel.text = @"战绩查询";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:24];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];

//    self.hearNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 30, self.view.frame.size.width - 20, 30)];
//    self.hearNameLabel.text = @"召唤师名称";
//    self.hearNameLabel.textColor = [UIColor whiteColor];
//    self.hearNameLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
//    [self.view addSubview:self.hearNameLabel];
//    
//    self.hearNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.hearNameLabel.frame) + 30, self.view.frame.size.width - 20, 40)];
//    self.hearNameTextField.placeholder = @"请输入召唤师姓名";
//    self.hearNameTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.hearNameTextField];
//    
//    self.serverNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.hearNameTextField.frame) + 30, self.view.frame.size.width - 20, 30)];
//    self.serverNameLabel.text = @"服务器名称";
//    self.serverNameLabel.textColor = [UIColor whiteColor];
//    self.serverNameLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
//    [self.view addSubview:self.serverNameLabel];
//    
//    self.serverNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.serverNameButton.frame = CGRectMake(10, CGRectGetMaxY(self.serverNameLabel.frame) + 30, self.view.frame.size.width - 20, 40);
//    self.serverNameButton.titleLabel.text = @"请选择服务器";
//    self.serverNameButton.backgroundColor = [UIColor redColor];
//    self.serverNameButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:20];
//    self.serverNameButton.titleLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.serverNameButton];
//    
//    self.queryButton = [[UIButton alloc] init];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.height = self.view.frame.size.height - 64;
    self.webView.y = 74;
    self.webView.backgroundColor = [UIColor clearColor];

    [self.webView setOpaque:NO];
    self.webView.scrollView.bounces = NO;
    NSString *urlStr = @"http://lolbox.duowan.com/phone/playerSearchNew.php?lolboxAction=toInternalWebView";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *picName = [[request URL] absoluteString];
    if([picName hasSuffix:@"RANKED"] || [picName hasSuffix:@"NORMAL"] || [picName hasPrefix:@"http://zdl"]) {
        return NO;
    }
    return YES;
}

@end
