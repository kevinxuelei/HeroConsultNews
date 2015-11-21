//
//  NewsDetailModel.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/23.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "NewsDetailModel.h"

@implementation NewsDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
