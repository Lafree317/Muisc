//
//  GetDataManager.h
//  MyMusic
//
//  Created by huchunyuan on 15/9/22.
//  Copyright © 2015年 Lafree. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;
typedef void(^myBlock)();


@interface GetDataManager : NSObject
/** 记录数组个数 给外界返回row的时候使用 */
@property (nonatomic,assign) NSInteger count;
/** 返回model */
- (MusicModel *)getModalWithIndex:(NSInteger)index;


/** 单例对象 */
+ (GetDataManager *)shardManager;

/** 请求数据 */
- (void)getDataWithUrlStr:(NSString *)urlStr AndBlock:(myBlock)block;


@end
