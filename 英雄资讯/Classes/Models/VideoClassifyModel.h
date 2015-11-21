//
//  VideoClassifyModel.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/27.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoItemModel.h"
@interface VideoClassifyModel : NSObject

@property (nonatomic, copy) NSString *group;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *subCategory;

@end
