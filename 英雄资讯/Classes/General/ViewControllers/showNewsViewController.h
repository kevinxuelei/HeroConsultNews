//
//  showNewsViewController.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/23.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsDetailModel.h"
@interface showNewsViewController : UIViewController

@property (nonatomic, strong) NewsDetailModel *newsDetailModel;
@property (nonatomic, strong) NewsDetailModel *newsHeadDetailModel;
@end
