//
//  VideoDetailCollectionViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/28.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoDetailCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface VideoDetailCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *inageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (strong, nonatomic) IBOutlet UILabel *updateCountLabel;

@end

@implementation VideoDetailCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDictionary:(NSDictionary *)dictionary {
    [self.inageView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"icon"]] placeholderImage:nil];
    self.titleLabel.text = dictionary[@"name"];
    if ([dictionary[@"dailyUpdate"] isEqualToString:@"0"]) {
        [self.coverView setHidden:YES];
    }else {
        [self.coverView setHidden:NO];
        self.updateCountLabel.text = dictionary[@"dailyUpdate"];
    }
}

@end
