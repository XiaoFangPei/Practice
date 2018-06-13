//
//  ViewController.m
//  NetWork
//
//  Created by peixiaofang on 2017/11/29.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self GETData];
    [self PostWork];
    [self downloadBigFileTask];
}
- (void)GETData{
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.11"];
    // 如果URL含有中文字符需要utf-8编码
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionData = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"从服务器获取到数据");
        if (error) {
            NSLog(@"222Error: %@", error);
        } else {
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"11%@", dict);
        }
    }];
    // 5.最后一步，执行任务（resume也是继续执行）:
    [sessionData resume];
}
- (void)PostWork {
    
    
    //NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    // 代理方式
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"http://xxx.34.43.000:8000/login"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSDictionary *dic = @{
                            @"biz":@{
                                    @"username":@"xxff",
                                    @"device_id" : @"d41d8cd98f00b204e9800998ecf8427e",
                                    @"password" : @"xxxxx"

                                    },
                           
                    };
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paramStr = [[NSString alloc] initWithData:paramData encoding:NSUTF8StringEncoding];
    paramStr = [NSString stringWithFormat:@"xmas-json=%@", paramStr];
    request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request];
    
    // block 方式初始化task
//    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        if (error) {
//            NSLog(@"222Error: %@", error);
//        } else {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"11%@", dict);
//        }
//    }];
    [sessionDataTask resume];
}
- (void)downloadTask {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@""];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [downloadTask resume];
}
- (void)downloadBigFileTask {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@""];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    [downloadTask resume];
}
#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}
// 后台下载
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

#pragma mark - NSURLSessionTaskDelegate
// 请求结束或者是失败的时候调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
}
#pragma mark - NSURLSessionDataDelegate
// 使用block方式初始化task的话设置的代理方法将无效
/**
 * 接收到服务器的响应 它默认会取消该请求
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param response          响应头信息
 *  @param completionHandler 回调 传给系统
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    /*
     NSURLSessionResponseCancel = 0,取消 默认
     NSURLSessionResponseAllow = 1, 接收
     NSURLSessionResponseBecomeDownload = 2, 变成下载任务
     NSURLSessionResponseBecomeStream        变成流
     */
    completionHandler(NSURLSessionResponseAllow);
}
//接收到服务器的响应 调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
