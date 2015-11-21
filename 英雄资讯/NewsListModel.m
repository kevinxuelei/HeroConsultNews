//
//  NewsListModel.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/22.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
