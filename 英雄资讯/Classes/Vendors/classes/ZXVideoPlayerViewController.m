//
//  ZXVideoPlayerViewController.m
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//-----------------播放器vc-----------------------

#import "ZXVideoPlayerViewController.h"
#import "ZXVideoView.h"
#import "ZXCustomControlView.h"
#import <AVFoundation/AVFoundation.h>
@interface ZXVideoPlayerViewController ()

@property (nonatomic,strong) AVPlayer *videoPlayer;                         //播放器
@property (nonatomic,strong) ZXVideoView *videoView;                        //播放器显示层
@property (strong) AVPlayerItem *item;

@property (nonatomic,strong) ZXCustomControlView *controlView;              //控件视图
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;


@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) BOOL isFullscreen;                             //是否横屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation;     //当前屏幕方向

@property (nonatomic,strong) id timeObserver;

@end

@implementation ZXVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setup];
    [self addView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)dealloc
{
    [self removeTimeObserver];
    [self.item removeObserver:self forKeyPath:@"status"];
    [_videoPlayer cancelPendingPrerolls];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)addView {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 40)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.titleLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(20, 0, 40, 40);
    self.backButton.center = CGPointMake(30, self.topView.center.y);
    [self.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    
    [self updataFrame];
}

- (void)updataFrame {
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    self.titleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width - 80, 40);
    self.titleLabel.center = self.topView.center;
}

-(void)setupNavigationController {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"YBS_navigationBarBackButton_white"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    //选择自己喜欢的颜色
    UIColor * color = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:17];
    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color, font] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
    //大功告成
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_controlView setHidden:YES];
    [self.topView setHidden:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_videoPlayer pause];
    [_controlView setIsPlaying:NO];

    [super viewWillDisappear:animated];
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
//}

-(BOOL)shouldAutorotate
{
    return YES;
}

//屏幕方向改变
-(void)deviceOrientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    if(interfaceOrientation != _currentOrientation)
    {
        _currentOrientation = interfaceOrientation;
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
            {
                [self turnToPortraint];
            }
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
            {
                [self turnToPortraint];
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:
            {
                [self turnToLeft];
            }
                break;
            case UIInterfaceOrientationLandscapeRight:
            {
                [self turnToRight];
            }
                break;
            default:
                break;
        }
    }
}

-(void)setVideoUrl:(NSString *)videoUrl
{
    if(_videoUrl != videoUrl)
    {
        _videoUrl = videoUrl;
        if(_videoUrl == nil)
        {
            return;
        }
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:_videoUrl] options:nil];
        NSArray *requestedKeys = @[@"playable"];
        
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
             dispatch_async(dispatch_get_main_queue(),^{
                [self prepareToPlayAsset:asset withKeys:requestedKeys];
            });
        }];
    }
}

- (void)setName:(NSString *)name {
    if(_name != name)
    {
        _name = name;
        if(_name == nil)
        {
            return;
        }
        self.titleLabel.text = _name;
    }
}

-(void)setup
{
    self.originFrame = self.view.frame;
    
    if(!_controlView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXCustomControlView class]) owner:nil options:nil];
        if(nibArray.count > 0)
        {
            ZXCustomControlView *view = nibArray[0];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            
            self.controlView = view;
            
            NSDictionary *paramDic = @{@"viewHeight":@(70.0f)};
            NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
            NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(viewHeight)]|" options:0 metrics:paramDic views:NSDictionaryOfVariableBindings(view)];
            [self.view addConstraints:view_H];
            [self.view addConstraints:view_V];
        }
        else
        {
            NSAssert(0, @"there was no xib named ...");
        }
        
        __weak ZXVideoPlayerViewController *weakSelf = self;
        [_controlView showWithClickHandle:^(NSInteger tag) {
            switch (tag) {
                case 1:
                {//播放或暂停
                    if(weakSelf.videoPlayer.rate > 0)
                    {
                        weakSelf.controlView.isPlaying = NO;
                        [weakSelf.videoPlayer pause];
                    }
                    else
                    {
                        weakSelf.controlView.isPlaying = YES;
                        [weakSelf.videoPlayer play];
                    }
                }
                    break;
                case 2:
                {//全屏
                    if(!weakSelf.isFullscreen)
                    {
                        [weakSelf turnToLeft];
                    }
                    else
                    {
                        [weakSelf turnToPortraint];
                    }
                }
                    break;
                default:
                    break;
            }
        } slideHandle:^(CGFloat interval,BOOL isFinished) {
            if(isFinished)
            {
                //滑块拖动停止
                CMTime time = CMTimeMakeWithSeconds(interval, weakSelf.videoPlayer.currentItem.duration.timescale);
                [weakSelf.videoPlayer seekToTime:time completionHandler:^(BOOL finished) {
                    [weakSelf.videoPlayer play];
                    weakSelf.controlView.isPlaying = YES;
                }];
            }
            else
            {
                if(weakSelf.videoPlayer.rate > 0)
                {
                    weakSelf.controlView.isPlaying = NO;
                    [weakSelf.videoPlayer pause];
                }
            }
        }];
    }
    
    //添加屏幕单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

/////////////////////////////////
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    
    if (!asset.playable)
    {
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    if (self.item)
    {
        [self.item removeObserver:self forKeyPath:@"status"];
    }
    
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.item addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:nil];
    
    if (!self.videoPlayer)
    {
        self.videoPlayer = [AVPlayer playerWithPlayerItem:self.item];
    }
    
    if (self.videoPlayer.currentItem != self.item)
    {
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    
    [self removeTimeObserver];
    
    __weak ZXVideoPlayerViewController *weakSelf = self;
    self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);

        [weakSelf.controlView setSlideValue:currentTime / weakSelf.controlView.videoDuration];
    }];
    
    if(!_videoView)
    {
        self.videoView = [[ZXVideoView alloc]initWithFrame:self.view.bounds];
        _videoView.translatesAutoresizingMaskIntoConstraints = NO;
        _videoView.player = _videoPlayer;
        [_videoView setFillMode:AVLayerVideoGravityResizeAspect];
        [self.view insertSubview:_videoView belowSubview:_controlView];
        
        NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)];
        NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)];
        [self.view addConstraints:view_H];
        [self.view addConstraints:view_V];
    }
    [self.view sendSubviewToBack:_videoView];
    
    [_videoPlayer play];
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.videoPlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.view];
    if(!CGRectContainsPoint(_controlView.frame, point))
    {
        [_controlView setHidden:!_controlView.isHidden];
        [self.topView setHidden:!self.topView.isHidden];
    }
}

-(void)turnToPortraint
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = _originFrame;
        [self updataFrame];
    }completion:^(BOOL finished) {
        self.isFullscreen = NO;
    }];
}

-(void)turnToLeft
{
    CGRect frect = [self getLandscapeFrame];
    
    //横屏旋转的时候 需要先置为初始状态，否则会出现位置偏移的情况
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        [self updataFrame];
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
}

-(void)turnToRight
{
    CGRect frect = [self getLandscapeFrame];
    
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        [self updataFrame];
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
}

-(CGRect)getLandscapeFrame
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect frect = CGRectZero;
    frect.origin.x = (screenSize.width - screenSize.height) / 2.0f;
    frect.origin.y = (screenSize.height - screenSize.width) / 2.0f;
    frect.size.width = screenSize.height;
    frect.size.height = screenSize.width;
    return frect;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerStatusReadyToPlay:
            {   
                [_controlView setIsPlaying:YES];
                [_controlView setIsControlEnable:YES];
                
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                _controlView.videoDuration = duration;
            }
                break;
            case AVPlayerStatusFailed:
            {
                [_controlView setIsPlaying:NO];
                
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
            case AVPlayerStatusUnknown:
            {
                [_controlView setIsPlaying:NO];
            }
                break;
            default:
                break;
        }
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
