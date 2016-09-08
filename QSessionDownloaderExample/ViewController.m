//
//  ViewController.m
//  OCNSURLSession
//
//  Created by JHQ0228 on 16/6/9.
//  Copyright © 2016年 QianQian-Studio. All rights reserved.
//

#import "ViewController.h"

#import "QSessionDownloader.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *progressBtn1;
@property (nonatomic, strong) UIButton *progressBtn2;

@property (nonatomic, strong) NSURL *url1;
@property (nonatomic, strong) NSURL *url2;

@end

@implementation ViewController

/// 开始下载

- (void)startDownloadWithURL:(NSURL *)url button:(UIButton *)button {
    
    [[QSessionDownloader defaultDownloader] q_downloadWithURL:url progress:^(float progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [button q_setButtonWithProgress:progress lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
        });
        
    } successed:^(NSString *targetPath) {
        
        NSLog(@"文件下载成功：%@", targetPath);
        
    } failed:^(NSError *error) {
        
        if ([error.userInfo[NSLocalizedDescriptionKey] isEqualToString:@"pauseDownload"]) {
            
            NSLog(@"暂停下载");
            
        } else if ([error.userInfo[NSLocalizedDescriptionKey] isEqualToString:@"cancelDownload"]) {
            
            NSLog(@"取消下载");
            
        } else {
            
            NSLog(@"文件下载失败：%@", error.userInfo[NSLocalizedDescriptionKey]);
        }
    }];
}

/// 暂停下载

- (void)pauseDownloadWithURL:(NSURL *)url {
    
    [[QSessionDownloader defaultDownloader] q_pauseWithURL:url];
}

/// 取消下载

- (void)cancelDownloadWithURL:(NSURL *)url button:(UIButton *)button {
    
    [[QSessionDownloader defaultDownloader] q_cancelWithURL:url];
    
    [button q_setButtonWithProgress:0 lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
}

/******************************************************************************************************************************/

- (IBAction)start1:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"];
    
    self.url1 = url;
    self.progressBtn1 = sender;
    
    [self startDownloadWithURL:url button:sender];
}

- (IBAction)goon1 {
    
    [self startDownloadWithURL:self.url1 button:self.progressBtn1];
}

- (IBAction)pause1 {
    
    [self pauseDownloadWithURL:self.url1];
}

- (IBAction)cancel1 {
    
    [self cancelDownloadWithURL:self.url1 button:self.progressBtn1];
}

/******************************************************************************************************************************/

- (IBAction)start2:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    self.url2 = url;
    self.progressBtn2 = sender;
    
    [self startDownloadWithURL:url button:sender];
}

- (IBAction)goon2 {
    
    [self startDownloadWithURL:self.url2 button:self.progressBtn2];
}

- (IBAction)pause2 {
    
    [self pauseDownloadWithURL:self.url2];
}

- (IBAction)cancel2 {
    
    [self cancelDownloadWithURL:self.url2 button:self.progressBtn2];
}

@end
