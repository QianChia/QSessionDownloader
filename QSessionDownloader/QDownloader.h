//
//  QDownloader.h
//  QSessionDownloader
//
//  Created by JHQ0228 on 16/7/15.
//  Copyright © 2016年 QianQian-Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDownloader : NSObject

/**
 *  创建下载
 *
 *  @param url          下载地址
 *  @param progress     下载进度回调，子线程回调
 *  @param successed    下载成功回调，主线程回调
 *  @param failed       下载失败回调，子线程回调
 *
 *  @return 文件下载
 */
+ (instancetype)q_downloadWithURL:(NSURL *)url
                         progress:(void (^)(float progress))progress
                        successed:(void (^)(NSString *targetPath))successed
                           failed:(void (^)(NSError *error))failed;

/**
 *  暂停下载
 *
 *  停止下载
 *
 *  @param url  下载地址
 */
- (void)q_pauseDownload;

/**
 *  取消下载
 *
 *  停止下载，并删除已经下载的文件
 *
 *  @param url  下载地址
 */
- (void)q_cancelDownload;

@end
