//
//  VideoTableViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/26.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "VideoListTableViewCell.h"
#import "VideoCategoryTableViewCell.h"
#import "VideoModel.h"
#import "MJRefresh.h"
#import "ZXVideoPlayerViewController.h"
#import "videoDetailModel.h"
#import "MJExtension.h"
@interface VideoTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *VideotableView;
@property (nonatomic, strong) NSMutableArray *videoListArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation VideoTableViewCell

- (NSMutableArray *)videoListArray {
    if (!_videoListArray) {
        _videoListArray = [NSMutableArray array];
    }
    return _videoListArray;
}

- (void)awakeFromNib {
    // Initialization code
    
    UINib *nib = [UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil];
    [self.VideotableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.VideotableView.delegate = self;
    self.VideotableView.dataSource = self;
    self.VideotableView.tableFooterView = [[UIView alloc] init];
    
    self.page = 2;
    [self setupRefresh];
}

- (void)setTagName:(NSString *)tagName {
    if (_tagName == tagName) {
        return;
    }
    _tagName = tagName;
    [self addData:1];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.VideotableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    self.VideotableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
        [self.VideotableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.VideotableView.header endRefreshing];
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
        [self.VideotableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.VideotableView.footer endRefreshing];
    });
    self.page++;
}

- (void)addData:(NSInteger)pageCount {
    NSString *urlStr = [NSString stringWithFormat:@"http://box.dwstatic.com/apiVideoesNormalDuowan.php?src=duowan&action=l&sk=&pageUrl=&heroEnName=&tag=%@&p=%ld", self.tagName, (long)pageCount];
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
        [self.VideotableView reloadData];
    }];
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
    NSString *string = [NSString stringWithFormat:@"http://box.dwstatic.com/apiVideoesNormalDuowan.php?action=f&cf=ios&check_code=null&format=json&payer_name=null&plat=ios9.0&uu=&ver=2.0&vid=%@&vu=null&sign=signxxxxx", [self.videoListArray[indexPath.row] vid]];
    ZXVideoPlayerViewController *zxVideoPlayerVC = [[ZXVideoPlayerViewController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    zxVideoPlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [window.rootViewController presentViewController:zxVideoPlayerVC animated:YES completion:^{
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

@end
