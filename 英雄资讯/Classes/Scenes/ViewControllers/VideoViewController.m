//
//  VideoViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/26.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoViewController.h"
#import "FDSlideBar.h"
#import "UIView+Extension.h"
#import "VideoTableViewCell.h"
#import "VideoCategoryTableViewCell.h"
@interface VideoViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) FDSlideBar *slideBar;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation VideoViewController

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
    
}

- (void)setupSlideBar {
    FDSlideBar *sliderBar = [[FDSlideBar alloc] init];
    
    // Init the titles of all the item
    
    sliderBar.itemsTitle = @[@"最新", @"分类", @"热门"];
    
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

- (void)setupTAbleView {
    CGRect frame = CGRectMake(0, 0, CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.slideBar.frame), CGRectGetWidth(self.view.frame));
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
    return self.slideBar.itemsTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UINib *nib = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    UINib *nib1 = [UINib nibWithNibName:@"VideoCategoryTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"cell"];
    if (indexPath.row == 1) {
        VideoCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        return cell;
    }else {
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        if (indexPath.row == 0) {
            cell.tagName = @"newest";
        }else if(indexPath.row == 2) {
            cell.tagName = @"topN";
        }
        return cell;
    }
    return nil;
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
