//
//  Shop.m
//  Block
//
//  Created by peixiaofang on 2017/11/23.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import "Shop.h"

@implementation Shop
// 在其他类中调用改方法
- (void)calculator:(int(^)(int result))block {
    self.result = block(self.result);
    NSLog(@"result = %d", self.result);
}
- (Shop *(^)(int a))add {
    return ^(int a) {
        _result += a;
        return self;
    };
}

@end
