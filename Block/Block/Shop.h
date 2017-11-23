//
//  Shop.h
//  Block
//
//  Created by peixiaofang on 2017/11/23.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) void(^myBlock)(void);

@end
