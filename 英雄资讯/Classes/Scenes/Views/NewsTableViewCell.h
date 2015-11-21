//
//  NewsTableViewCell.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/23.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, strong) NewsModel *newsModel;
@property (nonatomic, strong) NSArray *headArray;

@end
