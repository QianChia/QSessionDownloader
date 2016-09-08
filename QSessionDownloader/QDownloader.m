//
//  QDownloader.m
//  QSessionDownloader
//
//  Created by JHQ0228 on 16/7/15.
//  Copyright © 2016年 QianQian-Studio. All rights reserved.
//

#import "QDownloader.h"
#import "NSString+BundlePath.h"

@interface QDownloader () <NSURLSessionDownloadDelegate>

/// 下载目标目录
@property (nonatomic, copy) NSString *targetPath;

/// 下载文件缓存数据
@property (nonatomic, strong) NSData *resumeData;

/// block 属性
@property (nonatomic, copy) void (^progressBlock)(float);
@property (nonatomic, copy) void (^successedBlock)(NSString *);
@property (nonatomic, copy) void (^failedBlock)(NSError *);

/// 网络连接属性
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *downloadSession;
@property (nonatomic, strong) NSURL *downloadURL;

/// 是否暂停下载
@property (nonatomic, assign) BOOL isPausedDownload;

/// 是否取消下载
@property (nonatomic, assign) BOOL isCancelDownload;

@end

@implementation QDownloader

/// 创建下载

+ (instancetype)q_downloadWithURL:(NSURL *)url progress:(void (^)(float progress))progress successed:(void (^)(NSString *targetPath))successed failed:(void (^)(NSError *error))failed {
    
    QDownloader *downloader = [[self alloc] init];
    
    downloader.progressBlock = progress;
    downloader.successedBlock = successed;
    downloader.failedBlock = failed;
    
    downloader.downloadURL = url;
    
    [downloader q_startDownload];
    
    return downloader;
}

/// 开始下载

- (void)q_startDownload {
    
    self.isPausedDownload = NO;
    self.isCancelDownload = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.downloadURL.absoluteString q_appendMD5CachePath]] == NO) {
        
        self.downloadTask = [self.downloadSession downloadTaskWithURL:self.downloadURL];
        [self.downloadTask resume];
        
    } else {
        self.resumeData = [NSData dataWithContentsOfFile:[self.downloadURL.absoluteString q_appendMD5CachePath]];
        
        self.downloadTask = [self.downloadSession downloadTaskWithResumeData:self.resumeData];
        [self.downloadTask resume];
    }
}

/// 暂停下载

- (void)q_pauseDownload {
    
    self.isPausedDownload = YES;
    
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
        if (resumeData) {
            self.resumeData = resumeData;
            [self.resumeData writeToFile:[self.downloadURL.absoluteString q_appendMD5CachePath] atomically:YES];
        }
        self.downloadTask = nil;
    }];
}

/// 取消下载

- (void)q_cancelDownload {
    
    self.isCancelDownload = YES;
    
    [self.downloadTask cancel];
    self.downloadTask = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:[self.downloadURL.absoluteString q_appendMD5CachePath] error:NULL];
}

/// 协议方法

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    self.targetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:self.targetPath error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[self.downloadURL.absoluteString q_appendMD5CachePath] error:NULL];
    
    if (self.successedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successedBlock(self.targetPath);
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    float progress = 1.0 * fileOffset / expectedTotalBytes;
    
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error && ![error.localizedFailureReason isEqualToString:@"No such file or directory"]) {
        
        NSError *hError = nil;
        
        if (self.isPausedDownload) {
            hError = [NSError errorWithDomain:@"UserOperation" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"pauseDownload"}];
        } else if (self.isCancelDownload) {
            hError = [NSError errorWithDomain:@"UserOperation" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"cancelDownload"}];
        } else {
            hError = error;
            
            self.resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        }
        
        if (self.failedBlock) {
            self.failedBlock(hError);
        }
        
    } else if ([error.localizedFailureReason isEqualToString:@"No such file or directory"]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:[self.downloadURL.absoluteString q_appendMD5CachePath] error:nil];
        
        [self q_startDownload];
    }
}

/// 懒加载

- (NSURLSession *)downloadSession {
    if (_downloadSession == nil) {
        _downloadSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _downloadSession;
}

@end
