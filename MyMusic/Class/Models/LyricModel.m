//
//  LyricModel.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/24.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel
/** 重写init方法 */
- (instancetype)initWithLyricTime:(NSString *)LyricTime
                         LyricStr:(NSString *)LyricStr
{
    self = [super init];
    if (self) {
        _lyricStr = LyricStr;
        _lyricTime = LyricTime;
    }
    return self;
}
@end
