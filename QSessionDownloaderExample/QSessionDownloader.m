//
//  QSessionDownloader.m
//  QSessionDownloader
//
//  Created by JHQ0228 on 16/7/14.
//  Copyright © 2016年 QianQian-Studio. All rights reserved.
//

#import "QSessionDownloader.h"
#import "QDownloader.h"

@interface QSessionDownloader ()

/// 下载操作缓冲池
@property (nonatomic, strong) NSMutableDictionary *downloadCache;

@end

@implementation QSessionDownloader

/// 创建单例类对象

+ (instancetype)defaultDownloader {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 创建下载

- (void)q_downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress successed:(void (^)(NSString *targetPath))successed failed:(void (^)(NSError *error))failed {
    
    if (self.downloadCache[url.absoluteString] != nil) {    
        return;
    }
    
    QDownloader *downlader = [QDownloader q_downloadWithURL:url progress:progress successed:^(NSString *targetPath) {
        
        [self.downloadCache removeObjectForKey:url.absoluteString];
        
        if (successed) {
            successed(targetPath);
        }
        
    } failed:^(NSError *error) {
        
        [self.downloadCache removeObjectForKey:url.absoluteString];
        
        if (failed) {
            failed(error);
        }
    }];
    
    [self.downloadCache setObject:downlader forKey:url.absoluteString];
}

/// 暂停下载

- (void)q_pauseWithURL:(NSURL *)url {
    
    QDownloader *downloader = self.downloadCache[url.absoluteString];
    
    if (downloader != nil) {
        
        [downloader q_pauseDownload];
        
        [self.downloadCache removeObjectForKey:url.absoluteString];
    }
}

// 取消下载

- (void)q_cancelWithURL:(NSURL *)url {
    
    QDownloader *downloader = self.downloadCache[url.absoluteString];
    
    if (downloader != nil) {
        
        [downloader q_cancelDownload];
        
        [self.downloadCache removeObjectForKey:url.absoluteString];
    }
}

/// 懒加载

- (NSMutableDictionary *)downloadCache {
    if (_downloadCache == nil) {
        _downloadCache = [NSMutableDictionary dictionary];
    }
    return _downloadCache;
}

@end
