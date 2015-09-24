//
//  PlayMusicViewController.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "AudioPlayerManager.h"
#import "GetDataManager.h"
#import "ProjectHandle.h"
#import "UIImageView+WebCache.h"
#import "LyricModel.h"
@interface PlayMusicViewController ()<AudioPlayerManagerDelegate,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;// 图片
@property (weak, nonatomic) IBOutlet UILabel *currentTime;// 当前时间
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UITableView *playMusicTableView;// 歌词
@property (weak, nonatomic) IBOutlet UIImageView *PlayMuiscView;

@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@property (nonatomic,assign) NSInteger temp;// 暂存
@property (nonatomic,assign) CGPoint imageCenter;
@end

@implementation PlayMusicViewController
/** 单例类 */
+ (PlayMusicViewController *)sharManager{
    static PlayMusicViewController *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kPlayMuiscStoryBoaedID];

    });
    return audioManager;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.temp == self.index) {
        return;
    }else{
        [self play];
    }

}
- (void)statusBarOrientationChange:(NSNotification *)notification

{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation ==UIInterfaceOrientationLandscapeLeft)
        // home键靠左右
        
    {
        
        //
        NSLog(@"yyyyy");
        _visualEffectView.frame = self.view.bounds;
        self.musicImageView.center = self.view.center;
        
    }
    if (orientation == UIInterfaceOrientationPortrait)
        
    {
        
        // home下
        NSLog(@"nnnnn");
        _visualEffectView.frame = self.view.bounds;
        self.musicImageView.center = _imageCenter;
        
    }
}
/** 播放 给AudioPlayerManager的Model赋值,并且调用准备播放方法 */
- (void)play{
    
    
    // 为了让tem 记录index的值用来做判断
    self.temp = self.index;
    // 给AudioPlayerManager的mudicModel赋值
    [AudioPlayerManager shardManager].mudicModel = [[GetDataManager shardManager] getModalWithIndex:_index];
    // 准备播放
    [[AudioPlayerManager shardManager] prepareMusic];

    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:[AudioPlayerManager shardManager].mudicModel.picUrl]];
    [self.PlayMuiscView sd_setImageWithURL:[NSURL URLWithString:[AudioPlayerManager shardManager].mudicModel.picUrl]];
    [self.playMusicTableView reloadData];
    self.navigationItem.title = [AudioPlayerManager shardManager].mudicModel.name;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 因为上一个页面下标0是传不过来的.
    // 判断第一首不相等
    self.temp = -1;
    [AudioPlayerManager shardManager].delegate = self;
//    self.navigationController.navigationBar.translucent = NO;
    // 关闭scrollView的偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 强制走stroyBoard 走加载视图
    [self.musicImageView layoutIfNeeded];

//    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:[AudioPlayerManager shardManager].mudicModel.picUrl]];
    self.imageCenter = self.musicImageView.center;
    /** 切圆 */
    self.musicImageView.layer.masksToBounds = YES;
    self.musicImageView.layer.cornerRadius = self.musicImageView.frame.size.height / 2;
    /** 注册通知检测旋转 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    // 模糊
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _visualEffectView.frame = self.view.bounds;
    _visualEffectView.alpha = 0.8;
    [self.PlayMuiscView addSubview:_visualEffectView];
    [self.musicImageView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
}
#pragma mark - AudioPlayerManagerDelegate 的方法
- (void)getCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progress:(CGFloat)progress{
    
    
    self.currentTime.text = currentTime;
    self.totalTime.text = totalTime;
    self.progressSlider.value = progress;
    
    [UIView animateWithDuration:0.1 animations:^{
        // 改变musicImageView的transform
        self.musicImageView.transform = CGAffineTransformRotate(self.musicImageView.transform, M_PI / 180);
    }];
    
    
    // 接受对应的下标
    NSInteger index = [[AudioPlayerManager shardManager] getIndexWithCurrentTime:currentTime];
    
    
    if (index == -1) {
        return;
    }
    
    [self.playMusicTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    
    

}



/** 进度条方法 */
- (IBAction)prgressSlider:(UISlider *)sender {
    [[AudioPlayerManager shardManager] seekToTime:sender.value];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
/** 上一首方法 */
- (IBAction)lastMusic:(id)sender {

    
    if (self.index > 0) {
        self.index --;
    }else{
        self.index = [GetDataManager shardManager].count - 1;
    }
    [self play];
}
// 暂停开始
- (IBAction)pauseOrplayMusic:(id)sender {
    if ([AudioPlayerManager shardManager].isPlaying) {
        [[AudioPlayerManager shardManager] pauseMusic];
        
    }else{
        [[AudioPlayerManager shardManager] playMusic];
    }
}
/** 下一首 */
- (IBAction)nextMusic:(id)sender {

    
    if (self.index < [GetDataManager shardManager].count -1) {
        self.index++;
    }else{
        self.index = 0;
    }
    [self play];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[AudioPlayerManager shardManager] getLyricArray].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kplayMuiscCell forIndexPath:indexPath];
    LyricModel *lyricModel = [[AudioPlayerManager shardManager] getLyricArray][indexPath.row];
    cell.textLabel.text = lyricModel.lyricStr;
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    // 语法糖写法,意思就是在selectedBackgroundView上添加一个View
    cell.selectedBackgroundView= ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor redColor];
        view;
    });
    cell.backgroundColor= [UIColor clearColor] ;
    return cell;
}
- (void)autoPlayToEnd{
    
}

@end
