//
//  main.m
//  CYuYan
//
//  Created by peixiaofang on 2017/11/29.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
#pragma mark 求5！用c语言即 1*2*3*4*5
        int i,t;
        t = 1;
        i = 2;
        while (i <= 5) {
            t = t * i;
            i = i + 1;
        }
        printf("%d\n", t);
#pragma mark 求多项式1 - 1/2 + 1/3 - 1/4 + ··· + 1/99 - 1/100
        int sign = 1;
        double deno = 2.0,sum = 1.0,term = 0;
        while (deno <= 100) {
            sign = -sign;
            term = sign / deno;
            sum = sum + term;
            deno = deno + 1;
        }
        printf("%f\n", sum);
        // 字符变量
        char c = '?';
        printf("%d  %c\n", c, c);
        //sizeof(int); 4个字节
        unsigned char c1 = 255;
        printf("%d\n", c1);
        float a = 3.14159;
        printf("%f %lu\n", a, sizeof(float));
        int i1 = 3;
        printf("%d\n", ++i1);
        printf("%d\n", i1++);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
