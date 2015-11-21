//
//  NewsHeadModel.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/25.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsHeadModel : NSObject

@property (nonatomic, copy) NSString *title; // cell的主标题
@property (nonatomic, copy) NSString *desc; // cell的子标题
@property (nonatomic, copy) NSString *pic_ad_url; // 图片网址
@property (nonatomic, copy) NSString *ID; // id
@property (nonatomic, copy) NSString *goto_target;
@property (nonatomic, copy) NSString *platform;

@end
