//
//  AudioPlayerManager.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/23.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "LyricModel.h"
@import AVFoundation;// 等同于下一步 只能引用系统的库
//#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerManager ()

/** 播放对象 */
@property (nonatomic,strong) AVPlayer *player;
/** 计时器时间 */
@property (nonatomic,strong) NSTimer *timer;
/** 歌词数组 */
@property (nonatomic,strong) NSMutableArray *lyricArray;
@end


@implementation AudioPlayerManager
/** 单例类 */
+ (AudioPlayerManager *)shardManager{
    static AudioPlayerManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[AudioPlayerManager alloc] init];
    });
    return audioManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = [AVPlayer new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusicEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
    
}

- (void)playMusicEnd{
    if (_delegate && [_delegate respondsToSelector:@selector(autoPlayToEnd)]) {
        [self.delegate autoPlayToEnd];
    }
}


/** 准备播放 */
- (void)prepareMusic{
    // 如果已经有了观察者,需要移除观察者
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 初始化item 
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.mudicModel.mp3Url]];
    /** 添加观察者 观察音乐当前状态的改变值 */
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self.player replaceCurrentItemWithPlayerItem:item];
}



/** 观察者方法 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        // 通过key拿到对象 然后用status接收
        AVPlayerItemStatus status= [[change valueForKey:@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知");
                break;
            }
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"可以播放 play");
                [self playMusic];
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"错误");
                break;
            }
            default:
            break;
        }
    }
}

/** 播放音乐 */
- (void)playMusic{
    
    self.isPlaying = YES;
    
    if (self.timer) {
        return;
    }
    
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)timeAction{
    if (_delegate && [_delegate respondsToSelector:@selector(getCurrentTime:totalTime:progress:)]) {
        [_delegate getCurrentTime:[self transformWith:[self currentTimeValue]] totalTime:[self transformWith:[self totalTimeValue]] progress:[self progress]];
    }
}
// NStimer的方法.. 主要用来调用代理方法
- (NSInteger)currentTimeValue{
    return self.player.currentTime.value / self.player.currentTime.timescale;
}
// 总时间
- (NSInteger)totalTimeValue{
    CMTime time = [self.player.currentItem duration];
    if (time.timescale == 0) {
        return 1;
    }else{
        return time.value/time.timescale;
    }
}
/** 转化字符串 */
- (NSString *)transformWith:(NSInteger)time{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",time/60,time%60];
}


- (CGFloat)progress{
    return (CGFloat)[self currentTimeValue]/(CGFloat)[self totalTimeValue];
}
/** 暂停 */
- (void)pauseMusic{
    [self.timer invalidate];
    self.timer = nil;
    self.isPlaying = NO;
    [self.player pause];
}

/** 自定义播放 */
- (void)seekToTime:(CGFloat)time{
    [self pauseMusic];
    [self.player seekToTime:CMTimeMake(time*[self totalTimeValue], 1) completionHandler:^(BOOL finished) {
        if (finished) {
            [self playMusic];
        }
    }];
}

/** 获取歌词数组 */
- (NSArray *)getLyricArray{
    self.lyricArray = [NSMutableArray array];
    for (NSString *str in self.mudicModel.timeLyric) {
        NSArray *arr = [str componentsSeparatedByString:@"]"];
        if ([arr.firstObject length]<1) {
            continue;
        }
        NSString *lyricTime = [arr.firstObject substringWithRange:NSMakeRange(1, 5)];
        LyricModel *lyricModel = [[LyricModel alloc] initWithLyricTime:lyricTime LyricStr:arr.lastObject];
        [_lyricArray addObject:lyricModel];
    }
    return _lyricArray;
}
/** 通过当前播放时间返回对应下标 */
- (NSInteger)getIndexWithCurrentTime:(NSString *)time{
    NSInteger index = -1;
    for (int i = 0; i < self.lyricArray.count; i++) {
        if ([[self.lyricArray[i] lyricTime] isEqualToString:time]) {
            index = i;
        }
    }
    return index;
}

@end
