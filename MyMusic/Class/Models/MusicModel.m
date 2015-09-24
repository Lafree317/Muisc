//
//  MusicModel.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        self.timeLyric = [value componentsSeparatedByString:@"\n"];
    }
}
@end
