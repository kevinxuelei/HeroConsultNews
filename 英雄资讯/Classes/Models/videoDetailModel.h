//
//  videoDetailModel.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/25.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsVideoModel.h"
@interface videoDetailModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NewsVideoModel *video_urls;

@end
