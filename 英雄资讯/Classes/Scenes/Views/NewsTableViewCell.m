//
//  NewsTableViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/23.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewsHeadModel.h"
#import "showNewsViewController.h"
#import "UIView+Extension.h"
#import "SDCycleScrollView.h"
@interface NewsTableViewCell () <SDCycleScrollViewDelegate>
@property (strong, nonatomic) UIImageView *myImageView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UILabel *time;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *heads;
@property (nonatomic, assign) int index;

@end

@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
        _title = [[UILabel alloc] init];
        [self.contentView addSubview:_title];
        _content = [[UILabel alloc] init];
        [self.contentView addSubview:_content];
        _time = [[UILabel alloc] init];
        [self.contentView addSubview:_time];
    }
    return self;
}

- (void)setNewsModel:(NewsModel *)newsModel {
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.pic_url] placeholderImage:nil];
    self.title.text = newsModel.title;
    self.content.text = newsModel.desc;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:newsModel.published.intValue];
    NSString *publishedStr = [NSString stringWithFormat:@"%@", date];
    self.time.text = [publishedStr substringToIndex:20];
    _newsModel = newsModel;
}

- (void)setHeadArray:(NSArray *)headArray {
    if (_headArray) {
        return;
    }
    _headArray = headArray;
    self.heads = [NSMutableArray array];
    for (NewsHeadModel *headModel in self.headArray) {
        [self.heads addObject:headModel.pic_ad_url];
    }
    [self setupScrollView];
}

/**
 *  集成轮播图
 *
 */
- (void)setupScrollView {
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageURLStringsGroup:nil]; // 模拟网络延时情景
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.infiniteLoop = YES;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.imageURLStringsGroup =self.heads;
    [self.contentView addSubview:self.cycleScrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (![_newsModel.pic_url isEqualToString:@""]) {
        self.myImageView.frame = CGRectMake(10, 10, 90, 70);
        
    }
    self.title.frame = CGRectMake(CGRectGetMaxX(self.myImageView.frame) +10, 15, self.frame.size.width - CGRectGetMaxX(self.myImageView.frame), 0);
    self.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.title.numberOfLines = 0;
    [self.title sizeToFit];
    self.content.frame = CGRectMake(CGRectGetMaxX(self.myImageView.frame) +10, CGRectGetMaxY(self.title.frame) + 3, self.frame.size.width - CGRectGetMaxX(self.myImageView.frame) - 15, 0);
    self.content.font = [UIFont systemFontOfSize:13];
    self.content.textColor = [UIColor grayColor];
    self.content.numberOfLines = 0;
    [self.content sizeToFit];
    self.time.frame = CGRectMake(CGRectGetMaxX(self.myImageView.frame), self.frame.size.height - 22, self.frame.size.width - CGRectGetMaxX(self.myImageView.frame) - 15, 20);
    self.time.font = [UIFont systemFontOfSize:13];
    self.time.textColor = [UIColor grayColor];
    self.time.textAlignment = NSTextAlignmentRight;
    
    self.cycleScrollView.frame = self.frame;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    showNewsViewController *showNewsVC = [[showNewsViewController alloc] init];
    UINavigationController *showNewsNC = [[UINavigationController alloc] initWithRootViewController:showNewsVC];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSString *urlStr = [NSString stringWithFormat:@"http://lol.zhangyoubao.com/apis/rest/ItemsService/userDegree?id=%@&i_=864587026266529&t_=1445766434138&p_=14759&v_=400603&a_=lol&pkg_=com.anzogame.lol&d_=ios&osv_=18&cha=oppoMartket&u_=&", [self.headArray[index] ID]];
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NewsDetailModel *newsDetailModel = [[NewsDetailModel alloc] init];
    [newsDetailModel setValuesForKeysWithDictionary:dict[@"data"]];
    showNewsVC.newsHeadDetailModel = newsDetailModel;
    showNewsNC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [window.rootViewController presentViewController:showNewsNC animated:YES completion:^{
    }];
}

@end
