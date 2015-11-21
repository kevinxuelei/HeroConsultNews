//
//  LoadingFailedView.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/30.
//  Copyright © 2015年 lihaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BLOCK)();

@interface LoadingFailedView : UIView

@property (nonatomic, copy) BLOCK myBlock;

+ (instancetype)instanceTextView;
- (void)ReloadTarget:(id)target action:(SEL)action;

@end
