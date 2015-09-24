//
//  AudioPlayerManager.h
//  MyMusic
//
//  Created by huchunyuan on 15/9/23.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@protocol AudioPlayerManagerDelegate <NSObject>

/** 代理传值方法 */
- (void)getCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime progress:(CGFloat)progress;
/** 播放结束 */
- (void)autoPlayToEnd;
@end

@interface AudioPlayerManager : NSObject

/** 代理 */
@property (nonatomic,weak)id<AudioPlayerManagerDelegate>delegate;

/** 音乐对象 */
@property (nonatomic,strong) MusicModel *mudicModel;

/** 布尔值暂停播放 */
@property (nonatomic,assign) BOOL isPlaying;

/** 单例类 */
+ (AudioPlayerManager *)shardManager;

/** 准备播放 */
- (void)prepareMusic;

/** 播放音乐 */
- (void)playMusic;

/** 暂停 */
- (void)pauseMusic;

/** 自定义播放 */
- (void)seekToTime:(CGFloat)time;

/** 获取歌词数组 */
- (NSArray *)getLyricArray;

/** 通过当前播放时间返回对应下标 */
- (NSInteger)getIndexWithCurrentTime:(NSString *)time;

@end
