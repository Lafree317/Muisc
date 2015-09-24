//
//  MusicCell.h
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView; // 音乐图片
@property (weak, nonatomic) IBOutlet UILabel *musicName; // 音乐名字
@property (weak, nonatomic) IBOutlet UILabel *singer; // 歌手

@property (nonatomic,strong) MusicModel *model;
@end
