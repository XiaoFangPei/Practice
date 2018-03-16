//
//  UILabel+VerticalAlign.m
//  Label
//
//  Created by peixiaofang on 2018/3/16.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)
- (void)alignTop {
    CGRect fontframe = [self textRectForBounds:self.bounds limitedToNumberOfLines:0];
    CGSize rowSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    double finalHeight = fontframe.size.height;
    //double finalWidth = self.frame.size.width;
    int newLinesToPad = (self.frame.size.height - finalHeight)/rowSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}
- (void)alignBottom {
    
}
@end
