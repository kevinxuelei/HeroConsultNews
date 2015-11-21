//
//  NewsModel.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/22.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *title; // cell的主标题
@property (nonatomic, copy) NSString *desc; // cell的子标题
@property (nonatomic, strong) NSNumber *published; // 更新的时间单位为秒
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *weight_new;
@property (nonatomic, copy) NSString *pic_url; // 图片网址
@property (nonatomic, copy) NSString *ID; // id
@property (nonatomic, copy) NSString *recommend;

@end
