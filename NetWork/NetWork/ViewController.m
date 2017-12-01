//
//  ViewController.m
//  NetWork
//
//  Created by peixiaofang on 2017/11/29.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self GETData];
}
- (void)GETData{
    NSURL *url = [NSURL URLWithString:@"http://"];
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
