//
//  LyricModel.h
//  MyMusic
//
//  Created by huchunyuan on 15/9/24.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
/** 歌词时间 */
@property (nonatomic,strong) NSString *lyricTime;
/** 歌词 */
@property (nonatomic,strong) NSString *lyricStr;
/** 重写init方法 */
- (instancetype)initWithLyricTime:(NSString *)LyricTime
                         LyricStr:(NSString *)LyricStr;
@end
