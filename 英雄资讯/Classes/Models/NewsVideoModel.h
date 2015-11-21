//
//  NewsVideoModel.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/24.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsVideoModel : NSObject

@property (nonatomic, copy) NSString *sd; // m3u8格式视频网址
@property (nonatomic, copy) NSString *hd;
@property (nonatomic, copy) NSString *shd;

@property (nonatomic, strong) NSArray *urls;


@end
