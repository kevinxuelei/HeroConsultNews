//
//  VideoClassifyTableViewCell.h
//  英雄资讯
//
//  Created by lanou3g on 15/10/28.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoClassifyTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *itemArray;
@property (strong, nonatomic) IBOutlet UICollectionView *videoCollection;

@end
