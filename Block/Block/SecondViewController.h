//
//  SecondViewController.h
//  Block
//
//  Created by peixiaofang on 2017/11/23.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^valueBlock)(NSString *string);

@interface SecondViewController : UIViewController
@property (nonatomic, copy) valueBlock valueBlock;

@end
