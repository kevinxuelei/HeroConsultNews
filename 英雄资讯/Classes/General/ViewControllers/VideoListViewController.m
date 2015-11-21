//
//  VideoListViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/28.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoListTableViewCell.h"
#import "ZXVideoPlayerViewController.h"
#import "NewsVideoModel.h"
#import "MJRefresh.h"
@interface VideoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videoListArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation VideoListViewController

- (NSMutableArray *)videoListArray {
    if (!_videoListArray) {
        _videoListArray = [NSMutableArray array];
    }
    return _videoListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationController];
    [self setupTableView];
    [self setupRefresh];
    
    self.page = 2;
}

- (void)setupNavigationController {
    self.navigationItem.title = self.videoMoodel[@"name"];
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

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    UINib *nib = [UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UITableView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.videoModel = self.videoListArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = [NSString stringWithFormat:@"http://box.dwstatic.com/apiVideoesNormalDuowan.php?action=f&cf=android&check_code=null&format=json&payer_name=null&plat=android2.2&uu=&ver=2.0&vid=%@&vu=null&sign=signxxxxx", [self.videoListArray[indexPath.row] vid]];
    ZXVideoPlayerViewController *zxVideoPlayerVC = [[ZXVideoPlayerViewController alloc] init];
    zxVideoPlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:zxVideoPlayerVC animated:YES completion:^{
        NSArray *array = [self setData:string];
        if (![[array[1] urls][0] isEqualToString:@""]) {
            zxVideoPlayerVC.videoUrl = [array[1] urls][0];
        }else if (![[array[0] urls][0] isEqualToString:@""]) {
            zxVideoPlayerVC.videoUrl = [array[0] urls][0];
        }
        zxVideoPlayerVC.name = [self.videoListArray[indexPath.row] title];
    }];
}

- (NSArray *)setData:(NSString *)urlStr {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in [dict[@"result"][@"items"] allValues]) {
        NewsVideoModel *videoModel = [[NewsVideoModel alloc] init];
        videoModel.urls = dic[@"transcode"][@"urls"];
        [array addObject:videoModel];
    }
    return array;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加数据
    [self addData:1];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加数据
    [self addData:self.page];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
    });
    self.page++;
}

- (void)addData:(NSInteger)pageCount {
    NSString *urlStr = [NSString stringWithFormat:@"http://box.dwstatic.com/apiVideoesNormalDuowan.php?src=duowan&action=l&sk=&pageUrl=&heroEnName=&tag=%@&p=%ld", self.videoMoodel[@"tag"], (long)pageCount];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            self.tempArray = [NSMutableArray array];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in array) {
                VideoModel *video = [[VideoModel alloc] init];
                [video setValuesForKeysWithDictionary:dic];
                [self.tempArray addObject:video];
            }
            if (pageCount == 1) {
                self.videoListArray = self.tempArray;
            }else {
                [self.videoListArray addObjectsFromArray:self.tempArray];
            }
        }
        [self.tableView reloadData];
    }];
}

@end
