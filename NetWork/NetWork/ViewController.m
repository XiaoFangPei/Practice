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
    //[self GETData];
    [self PostWork];
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
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://171.34.43.000:8000/login"];
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
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"222Error: %@", error);
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"11%@", dict);
        }
    }];
    [sessionDataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
