//
//  ViewController.m
//  Block
//
//  Created by peixiaofang on 2017/11/23.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

#import "ViewController.h"
#import "Shop.h"
#import "SecondViewController.h"

//2个宏
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

// block的定义
// 无参数无返回值
void (^block)(void);
// 无参有返回值
int (^block1)(void);
// 有参有返回
int (^block2)(int number);

void test1() {
    int a = 10;
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);// a是局部变量，block定义之后a就被销毁了。
    };
    a = 20;
    block();
}
void test2() {
    __block int a = 10;// __block修饰会编译成一个struct类型，在arc下会强引用，mrc下是将不会retain，可以避免循环引用。
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);
    };
    a = 20;
    block();
}
void test3() {
    static int a = 10; // static 函数每次被调用，普通局部变量都是重新分配，而静态局部变量保持上次调用的值不变。
    void (^block)(void) = ^{
        NSLog(@"a is %d", a);
    };
    a = 20;
    block();
}

int a = 10;
void test4() {
    void (^block)(void) = ^{
        NSLog(@"a is %d", a); // a是全局变量
    };
    a = 20;
    block();
}

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFild;
@property (nonatomic, copy) NSString *string;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    test1(); // 10
    test2(); // 20
    test3(); // 20
    test4(); // 20
    // 只有普通局部变量是传值，其他情况都是传址。
    
    [self test5];
    [self test6];
    [self test7];
    [self test8];
    [self test9];
}
#pragma mark - __weak使用
- (void)test5 {
    // block的循环引用
    Shop *shop = [[Shop alloc] init];
    shop.string = @"welcom to my shop";
    //__weak typeof(shop) weakShop = shop;
    WeakSelf(shop);
    shop.myBlock = ^{
        // 出现循环引用 shop指向Shop对象，shop属性myBlock指向Block，block代码指向Shop对象
        NSLog(@"%@", weakshop.string);
    };
    shop.myBlock();
}
#pragma mark - __weak和__strong一起使用
- (void)test6 {
   Shop *shop = [[Shop alloc] init];
   shop.string = @"welcom to my shop";
   WeakSelf(shop);
   shop.myBlock = ^{
        StrongSelf(shop); // 内部强引用不影响外部对象
        NSLog(@"%@",shop.string);
   };
   shop.myBlock();
}
- (void)test7 {
    Shop *shop = [[Shop alloc] init];
    shop.string = @"welcom to my shop";
    WeakSelf(shop);
    shop.myBlock = ^{
        StrongSelf(shop);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",shop.string);
        });
        // 注释掉StrongSelf(shop) 延迟2秒执行发现会娶不到弱指针，打印nill。需要在block内部将弱指针在强引用一下
    };
    shop.myBlock();
}
#pragma mark - Block传值
// 从第一个页面传到第二个页面一般用属性传值
- (IBAction)btn:(id)sender {
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    secondVC.valueBlock = ^(NSString *string) {
        NSLog(@"ViewController拿到了SecondVC的值%@", string);
        self.textFild.text = string;
    };
    [self presentViewController:secondVC animated:YES completion:nil];
}
#pragma mark - Block作为参数使用
- (void)test8 {
    Shop *shop = [[Shop alloc] init];
    // 调用 block用作参数
    [shop calculator:^int(int result) {
        result += 5;
        return result;
    }];
}
#pragma MARK - block作为返回值使用
- (void)test9 {
    Shop *shop = [[Shop alloc] init];
    shop.add(1).add(2).add(3);
    NSLog(@"%d", shop.result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
