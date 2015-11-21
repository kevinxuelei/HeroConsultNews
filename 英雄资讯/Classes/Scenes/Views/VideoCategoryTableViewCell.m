//
//  VideoCategoryTableViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/27.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoCategoryTableViewCell.h"
#import "VideoClassifyTableViewCell.h"
#import "VideoClassifyModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
@interface VideoCategoryTableViewCell ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *videoCategoryTableView;
@property (nonatomic, strong) NSMutableArray *headArray;
@property (nonatomic, assign) NSInteger width;

@end

@implementation VideoCategoryTableViewCell

- (NSMutableArray *)headArray {
    if (!_headArray) {
        _headArray = [NSMutableArray array];
    }
    return _headArray;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self addData];
    self.videoCategoryTableView.delegate = self;
    self.videoCategoryTableView.dataSource = self;
    [self.videoCategoryTableView registerNib:[UINib nibWithNibName:@"VideoClassifyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.videoCategoryTableView.tableFooterView = [[UIView alloc] init];
    
    [self setupRefresh];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.width = [[UIScreen mainScreen] bounds].size.width;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.videoCategoryTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加数据
    [self addData];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.videoCategoryTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.videoCategoryTableView.header endRefreshing];
    });
}

- (void)addData {
    NSString *urlStr = @"http://box.dwstatic.com/apiVideoesNormalDuowan.php?src=duowan&action=c&sk=&sn=%E7%BD%91%E9%80%9A%E4%B8%83&pn=%E8%AE%A9%E6%88%91%E6%89%93%E6%AD%BB%E4%BD%A0";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            self.headArray = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *dict in array) {
                VideoClassifyModel *videoModel = [VideoClassifyModel objectWithKeyValues:dict];
                [self.headArray addObject:videoModel];
            }
        }
        [self.videoCategoryTableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.itemArray = [self.headArray[indexPath.section] subCategory];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    headLabel.text = [self.headArray[section] name];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.opaque = NO;
    headLabel.textColor = [UIColor grayColor];
    headLabel.highlightedTextColor = [UIColor whiteColor];
    headLabel.font = [UIFont boldSystemFontOfSize:18];
    [customView addSubview:headLabel];
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemX = (self.width - 60) / 4 + 20;
    NSInteger count = [self.headArray[indexPath.section] subCategory].count;
    if (count % 4 > 0) {
        return (count / 4 + 1) * (itemX + 10) + 10;
    }
    return count / 4 * (itemX + 10) + 10;
}

@end
