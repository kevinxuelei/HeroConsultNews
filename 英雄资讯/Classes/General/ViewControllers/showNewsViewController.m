//
//  showNewsViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/23.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "showNewsViewController.h"
#import "UIView+Extension.h"
#import "showPictureViewController.h"
#import "ZXVideoPlayerViewController.h"
#import "videoDetailModel.h"
#import "MJExtension.h"
#define BIG_IMG_WIDTH [[UIScreen mainScreen] bounds].size.width
#define BIG_IMG_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface showNewsViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation showNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationController];
    [self setupWebView];
}

- (void)setupNavigationController {
    self.navigationItem.title = @"英雄资讯";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.000 green:0.717 blue:0.082 alpha:1.000]];
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color, font] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"YBS_navigationBarBackButton_white"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupWebView {
    NSLog(@"%@", self.newsHeadDetailModel.ID);
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.height = self.view.frame.size.height - 64;
    self.webView.scrollView.bounces = NO;
    NSString *urlStr = nil;
    if (self.newsDetailModel) {
        urlStr = [NSString stringWithFormat:@"http://lol.zhangyoubao.com/mobiles/item/%@?v_=400603&size=middle&t=1445608051", self.newsDetailModel.ID];
    }else {
        urlStr = [NSString stringWithFormat:@"http://lol.zhangyoubao.com/mobiles/item/%@?v_=400603&size=small&t=1445765075", self.newsHeadDetailModel.ID];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:self.webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@", request);
    //将url转换为string
    NSString *picName = [[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([picName hasSuffix:@".jpg"]) {
        NSRange range = [picName rangeOfString:@"showRawImage"]; //匹配得到的下标
        NSString *imageUrlStr = [picName substringFromIndex:range.location + range.length];
        showPictureViewController *showPictureVC = [[showPictureViewController alloc] init];
        showPictureVC.imageNameUrl = imageUrlStr;
        showPictureVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:showPictureVC animated:YES completion:nil];
        return NO;
    }else if ([picName hasSuffix:@"playvideo"]) {
        NSString *string = [NSString stringWithFormat:@"http://lol.anzogame.com/apis/rest/VideoService/get?id=%@&cache=0&i_=864587026266529&t_=1445666182846&p_=10883&v_=400603&a_=lol&pkg_=com.anzogame.lol&d_=android&osv_=18&u_=&", self.newsDetailModel.ID];
        ZXVideoPlayerViewController *zxVideoPlayerVC = [[ZXVideoPlayerViewController alloc] init];
        zxVideoPlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:zxVideoPlayerVC animated:YES completion:^{
            videoDetailModel *videoModel = [self setData:string];
            if (![[videoModel.video_urls hd] isEqualToString:@""]) {
                zxVideoPlayerVC.videoUrl = videoModel.video_urls.hd;
            }else if (![videoModel.video_urls.sd isEqualToString:@""]) {
                zxVideoPlayerVC.videoUrl = videoModel.video_urls.sd;
            }else {
                zxVideoPlayerVC.videoUrl = videoModel.video_urls.shd;
            }
            zxVideoPlayerVC.name = videoModel.title;
        }];
        return NO;
    }else {
        return YES;
    }
}

- (videoDetailModel *)setData:(NSString *)urlStr {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dic = dict[@"data"];
    videoDetailModel *videoModel = [videoDetailModel objectWithKeyValues:dic];
    return videoModel;
}

@end
