//
//  showVideoViewController.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/24.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "showVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface showVideoViewController ()
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation showVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadAvPlayer:(NSString *)videoUrlStr {
    
}

- (void)loadData {
    NSString *urlStr = self.videoUrlStr;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *sd = dict[@"data"][@"video_urls"][@"sd"];
        [self loadAvPlayer:sd];
    }];
}

@end
