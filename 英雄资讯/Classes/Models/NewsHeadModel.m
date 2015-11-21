//
//  NewsHeadModel.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/25.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "NewsHeadModel.h"

@implementation NewsHeadModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"goto_param"]) {
        self.ID = value[@"itemid"];
    }
}

@end
