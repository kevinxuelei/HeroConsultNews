//
//  VideoListTableViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/26.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface VideoListTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *CliclCountLabel;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@end

@implementation VideoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setVideoModel:(VideoModel *)videoModel {
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.cover_url] placeholderImage:nil];
    if (!videoModel.amount_play) {
        [self.coverView removeFromSuperview];
    }else {
        self.CliclCountLabel.text = [videoModel.amount_play substringToIndex:4];        
    }
    self.titleLabel.text = videoModel.title;
    self.dateLabel.text = [videoModel.upload_time substringFromIndex:5];
    NSInteger minute = videoModel.video_length.intValue / 60;
    NSInteger second = videoModel.video_length.intValue % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%ld", (long)minute, (long)second];
}

@end
