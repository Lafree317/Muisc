//
//  MusicCell.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "MusicCell.h"
#import "MusicModel.h"
#import <UIImageView+WebCache.h>
@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// 重写setModel方法
- (void)setModel:(MusicModel *)model{
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.musicName.text = model.name;
    self.singer.text = model.singer;
}

@end
