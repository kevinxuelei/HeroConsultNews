//
//  HomeViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/21.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsListModel.h"
#import "NewsListTableViewCell.h"
#import "FDSlideBar.h"
#import "UIView+Extension.h"
#import "LoadingFailedView.h"
@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate ,UIScrollViewDelegate>

@property (strong, nonatomic) FDSlideBar *slideBar;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *itemsTitle;
@property (nonatomic, strong) LoadingFailedView *loadingFailedView;

@end

@implementation HomeViewController

- (FDSlideBar *)slideBar {
    if (!_slideBar) {
        _slideBar = [[FDSlideBar alloc] init];
    }
    return _slideBar;
}

- (NSMutableArray *)itemsTitle {
    if (!_itemsTitle) {
        _itemsTitle = [NSMutableArray array];
    }
    return _itemsTitle;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self setupSlideBar];
    [self setupTAbleView];
    [self addData];
}

- (void)setupSlideBar {
    FDSlideBar *sliderBar = [[FDSlideBar alloc] init];
    if (self.itemsTitle) {
        sliderBar.itemsTitle = self.itemsTitle;
    }else {
        sliderBar.itemsTitle = nil;
    }
    
    // Set some style to the slideBar
    sliderBar.itemColor = [UIColor grayColor];
    sliderBar.itemSelectedColor = [UIColor orangeColor];
    sliderBar.sliderColor = [UIColor orangeColor];
    
    // Add the callback with the action that any item be selected
    [sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
    [self.view addSubview:sliderBar];
    _slideBar = sliderBar;
}
- (void)addData {   
    
    NSString *string = @"http://lol.zhangyoubao.com/apis/rest/CatalogsService/all?cattype=news&i_=864587026266529&t_=1445598710164&p_=2837&v_=400603&a_=lol&pkg_=com.anzogame.lol&d_=ios&osv_=18&cha=oppoMartket&u_=&";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (!data) {
        if (self.loadingFailedView) {
            return;
        }
        self.loadingFailedView = [LoadingFailedView instanceTextView];
        self.loadingFailedView.frame = self.view.frame;
        [self.loadingFailedView ReloadTarget:self action:@selector(addData)];
        [self.view addSubview:self.loadingFailedView];
        return;
    }
    [self.loadingFailedView removeFromSuperview];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSDictionary *dic in dict[@"data"]) {
        NewsListModel *news = [[NewsListModel alloc] init];
        [news setValuesForKeysWithDictionary:dic];
        [self.itemArray addObject:news];
        [self.itemsTitle addObject:news.name];
    }
    [self setupSlideBar];
    [self.tableView reloadData];

}

- (void)setupTAbleView {
    CGRect frame = CGRectMake(0, 0, CGRectGetMaxY(self.view.frame) - 44, CGRectGetWidth(self.view.frame));
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.center = CGPointMake(CGRectGetWidth(self.view.frame) * 0.5, CGRectGetHeight(self.view.frame) * 0.5 + CGRectGetMaxY(self.slideBar.frame) * 0.5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark --- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UINib *nib = [UINib nibWithNibName:@"NewsListTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    NewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    cell.newsListModel = self.itemArray[indexPath.row];
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(self.view.frame);
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double page = scrollView.contentOffset.y / scrollView.width;
    
    // 四舍五入计算出页码
    [self.slideBar selectSlideBarItemAtIndex:(int)(page + 0.5)];
}


@end
