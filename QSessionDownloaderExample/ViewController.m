//
//  ViewController.m
//  OCNSURLSession
//
//  Created by JHQ0228 on 16/6/9.
//  Copyright © 2016年 QianQian-Studio. All rights reserved.
//

#import "ViewController.h"

#import "QDownloaderManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *progressBtn1;
@property (nonatomic, strong) UIButton *progressBtn2;

@property (nonatomic, strong) NSURL *url1;
@property (nonatomic, strong) NSURL *url2;

@end

@implementation ViewController

- (IBAction)start1:(UIButton *)sender {
    
    self.progressBtn1 = sender;
    [self startDownload1:sender];
}

- (IBAction)goon1 {
    
    [self startDownload1:self.progressBtn1];
}

- (IBAction)pause1 {
    
    [self pauseDownload1];
}

- (IBAction)cancel1 {
    
    [self cancelDownload1];
}

// 开始下载

- (void)startDownload1:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.2.dmg"];
    self.url1 = url;
    
    [[QDownloaderManager sharedManager] q_downloadWithURL:url progress:^(float progress) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.progressBtn1 q_setButtonWithProgress:progress lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
        });
        
    } successed:^(NSString *targetPath) {
        
        NSLog(@"%@", targetPath);
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

// 暂停下载

- (void)pauseDownload1 {
    
    [[QDownloaderManager sharedManager] q_pauseWithURL:self.url1];
}

// 取消下载

- (void)cancelDownload1{
    
    [[QDownloaderManager sharedManager] q_cancelWithURL:self.url1];
    
    [self.progressBtn1 q_setButtonWithProgress:0 lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
}

/******************************************************************************************************************************/

- (IBAction)start2:(UIButton *)sender {
    
    self.progressBtn2 = sender;
    [self startDownload2:sender];
}

- (IBAction)goon2 {
    
    
    [self startDownload2:self.progressBtn2];
}

- (IBAction)pause2 {
    
    [self pauseDownload2];
}

- (IBAction)cancel2 {
    
    [self cancelDownload2];
}

// 开始下载

- (void)startDownload2:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    self.url2 = url;
    
    [[QDownloaderManager sharedManager] q_downloadWithURL:url progress:^(float progress) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.progressBtn2 q_setButtonWithProgress:progress lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
        });
        
    } successed:^(NSString *targetPath) {
        
        NSLog(@"%@", targetPath);
        
    } failed:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

// 暂停下载

- (void)pauseDownload2 {
    
    [[QDownloaderManager sharedManager] q_pauseWithURL:self.url2];
}

// 取消下载

- (void)cancelDownload2{
    
    [[QDownloaderManager sharedManager] q_cancelWithURL:self.url2];
    
    [self.progressBtn2 q_setButtonWithProgress:0 lineWidth:10 lineColor:nil backgroundColor:[UIColor yellowColor]];
}

@end
