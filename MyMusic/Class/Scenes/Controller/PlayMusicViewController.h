//
//  PlayMusicViewController.h
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayMusicViewController : UIViewController
/** 单例类 */
+ (PlayMusicViewController *) sharManager;
/** 当前播放的下标 */
@property (nonatomic,assign) NSInteger index;


@end
