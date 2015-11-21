//
//  NewsListTableViewCell.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/22.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
@interface NewsListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITableView *NewsListTableView;
@property (nonatomic, strong) NewsListModel *newsListModel;

@end
