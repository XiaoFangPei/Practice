//
//  ViewController.m
//  Label
//
//  Created by peixiaofang on 2018/3/14.
//  Copyright © 2018年 sinosoft. All rights reserved.
//


#import "ViewController.h"
#import "TopLeftLabel.h"
#import "UILabel+VerticalAlign.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 一  label 顶部对齐  1 修改label的高度 2.末尾补充换行符”\n”3.使用uitextfield代替设置不能滚动，不能编辑。4label添加类别。 5laabel添加子类
    UILabel *topLrftLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds
                                                                      .size.width, 100)];
    topLrftLabel0.backgroundColor = [UIColor orangeColor];
    topLrftLabel0.numberOfLines = 0;
    topLrftLabel0.text = @"往事尽给新币，线图照着的你环氧 变本加厉的说课好多微缺五号后退推倒撑到了 最好你好呀你电话的空白空白空白空白";
    [topLrftLabel0 alignTop];
    [self.view addSubview:topLrftLabel0];
    
    TopLeftLabel *topLrftLabel = [[TopLeftLabel alloc] initWithFrame:CGRectMake(0, 205, self.view.bounds
                                                                      .size.width, 100)];
    topLrftLabel.backgroundColor = [UIColor orangeColor];
    topLrftLabel.numberOfLines = 0;
    topLrftLabel.text = @"往事尽给新币，线图照着的你环氧 变本加厉的说课好多微缺五号后退推倒撑到了 最好你好呀你电话的空白空白空白空白";
    //[topLrftLabel alignTop];
    [self.view addSubview:topLrftLabel];
    
    // UILabel显示HTML文本
    NSString *htmlStr  = @"<html><body> Some html string \n <font size=\"13\" color=\"red\">This is some text!</font> </body></html>";
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    myLabel.attributedText = attStr;
    [self.view addSubview:myLabel];
}

- (void)viewDidLayoutSubviews {
    [self.testLabel sizeToFit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
