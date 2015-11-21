//
//  LoadingFailedView.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lihaowei. All rights reserved.
//

#import "LoadingFailedView.h"

@interface LoadingFailedView ()

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation LoadingFailedView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    [self.target performSelector:self.action withObject:self];
}

+(instancetype)instanceTextView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoadingFailedView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)ReloadTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

@end
