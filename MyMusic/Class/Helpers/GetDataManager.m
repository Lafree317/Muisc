//
//  GetDataManager.m
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import "GetDataManager.h"
#import "MusicModel.h"
#import "AudioPlayerManager.h"
/** 延展 */
@interface GetDataManager ()
/** 用来存放对象数组 */
@property (nonatomic,strong)NSMutableArray *musicListArr;
@end
/** 单例对象 */
@implementation GetDataManager
+ (GetDataManager *)shardManager{
    static GetDataManager *audioManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManger = [[GetDataManager alloc] init];
    });
    return audioManger;
}

/** 请求数据 */
- (void)getDataWithUrlStr:(NSString *)urlStr AndBlock:(myBlock)block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:urlStr]];
        for (NSDictionary *dict in array) {
            MusicModel *musicModel = [MusicModel new];
            [musicModel setValuesForKeysWithDictionary:dict];
            [self.musicListArr addObject:musicModel];
        }
        // 当子线程执行完毕 回到主线程(也就是说当数据加载完成回到主线程调用block)
        // 相对于外界调用block 首先执行的是这一步,然后才会出去
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
        
    });
}
/** 通过下标返回model */
- (MusicModel *)getModalWithIndex:(NSInteger)index{
    return self.musicListArr[index];
}
/** 数组懒加载,用到这个数组的时候才去初始化 */
- (NSMutableArray *)musicListArr{
    if (!_musicListArr) {
        _musicListArr = [NSMutableArray array];
    }
    return _musicListArr;
}
/** 重写count的get方法返回数组长度 */
- (NSInteger)count{
    
    return self.musicListArr.count;
    
}

@end
