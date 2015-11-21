//
//  NewsListTableViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/22.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "NewsListTableViewCell.h"
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "showNewsViewController.h"
#import "AppDelegate.h"
#import "NewsDetailModel.h"
#import "NewsHeadModel.h"
#import "MJRefresh.h"
#import "SDCycleScrollView.h"
@interface NewsListTableViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger page;

@end

@implementation NewsListTableViewCell

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    // Initialization code
    [self.NewsListTableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.NewsListTableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self.NewsListTableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.NewsListTableView.delegate = self;
    self.NewsListTableView.dataSource = self;
    self.NewsListTableView.tableFooterView = [[UIView alloc] init];
    
    self.page = 2;
    // 集成刷新控件
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.NewsListTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.NewsListTableView.header beginRefreshing];
    
    self.NewsListTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加数据
    [self addHeadData];
    [self addData:1];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataArray = self.dataArr;
        // 刷新表格
        [self.NewsListTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.NewsListTableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加数据
    [self addData:self.page];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataArray addObjectsFromArray:self.dataArr];
        // 刷新表格
        [self.NewsListTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.NewsListTableView.footer endRefreshing];
    });
    self.page++;
}

- (void)addData:(NSInteger)page {
    NSString *string = [NSString stringWithFormat:@"http://lol.zhangyoubao.com/apis/rest/ItemsService/lists?catid=%@&cattype=news&page=%ld&i_=864587026266529&t_=1445598711372&p_=6461&v_=400603&a_=lol&pkg_=com.anzogame.lol&d_=ios&osv_=18&cha=oppoMartket&u_=&", self.newsListModel.ID ,(long)page];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            self.dataArr = [NSMutableArray array];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dic in dict[@"data"]) {
                NewsModel *news = [[NewsModel alloc] init];
                [news setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:news];
            }
        }
    }];
}

- (void)addHeadData {
    NSString *urlStr = @"http://lol.zhangyoubao.com/apis/rest/ItemsService/ads?i_=864587026266529&t_=1445755823637&p_=13256&v_=400603&a_=lol&pkg_=com.anzogame.lol&d_=ios&osv_=18&cha=oppoMartket&u_=&";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    self.headArray = [NSMutableArray array];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *dic in dict[@"data"]) {
        NewsHeadModel *headModel = [[NewsHeadModel alloc] init];
        [headModel setValuesForKeysWithDictionary:dic];
        [self.headArray addObject:headModel];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *news = self.dataArray[indexPath.row];
    NewsTableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.headArray = self.headArray;
    }else {
        if ([news.pic_url isEqualToString:@""]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        }
        cell.newsModel = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    showNewsViewController *showNewsVC = [[showNewsViewController alloc] init];
    UINavigationController *showNewsNC = [[UINavigationController alloc] initWithRootViewController:showNewsVC];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSString *urlStr = [NSString stringWithFormat:@"http://lol.zhangyoubao.com/apis/rest/ItemsService/userDegree?id=%@&i_=864587026266529&t_=1445611059412&p_=30581&v_=400603&a_=lol&pkg_=com.anzogame.lol&d_=ios&osv_=18&cha=oppoMartket&u_=&", [self.dataArray[indexPath.row] ID]];
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NewsDetailModel *newsDetailModel = [[NewsDetailModel alloc] init];
    [newsDetailModel setValuesForKeysWithDictionary:dict[@"data"]];
    showNewsVC.newsDetailModel = newsDetailModel;
    showNewsNC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [window.rootViewController presentViewController:showNewsNC animated:YES completion:^{
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ([UIScreen mainScreen].bounds.size.height - 152) / 5.7;
    if (indexPath.row == 0) {
        return 1.6 * height;
    }
    return height;
}

@end
