//
//  VideoModel.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/27.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *vid; //id
@property (nonatomic, copy) NSString *cover_url; //图片
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *video_length; // 视频时长
@property (nonatomic, copy) NSString *upload_time; // 更新时间
@property (nonatomic, copy) NSString *amount_play; // 点击次数

@end
