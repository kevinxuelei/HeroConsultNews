//
//  VideoClassifyTableViewCell.m
//  英雄资讯
//
//  Created by lanou3g on 15/10/28.
//  Copyright (c) 2015年 lihaowei. All rights reserved.
//

#import "VideoClassifyTableViewCell.h"
#import "VideoDetailCollectionViewCell.h"
#import "VideoListViewController.h"
@interface VideoClassifyTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *array;


@end

@implementation VideoClassifyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.videoCollection.delegate = self;
    self.videoCollection.dataSource = self;
    self.videoCollection.backgroundColor = [UIColor whiteColor];
    [self.videoCollection registerNib:[UINib nibWithNibName:@"VideoDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    CGFloat itemX = (self.frame.size.width - 60) / 4;
    self.flowLayout.itemSize = CGSizeMake(itemX, itemX + 20);
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)setItemArray:(NSArray *)itemArray {
    if (_itemArray == itemArray) {
        return;
    }
    _itemArray = itemArray;
    [self.videoCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.dictionary = self.itemArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoListViewController *videoListVC = [[VideoListViewController alloc] init];
    videoListVC.videoMoodel = self.itemArray[indexPath.item];
    UINavigationController *videoListNC = [[UINavigationController alloc] initWithRootViewController:videoListVC];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    videoListNC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [window.rootViewController presentViewController:videoListNC animated:YES completion:^{
    }];
}

@end
