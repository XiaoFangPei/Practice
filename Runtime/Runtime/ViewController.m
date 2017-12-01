//
//  ViewController.m
//  Runtime
//
//  Created by peixiaofang on 2017/11/28.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //id objc_msgSend(id self, SEL op);
    
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(myMethod)) {
        
    }
}
- (void)myMethod {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
