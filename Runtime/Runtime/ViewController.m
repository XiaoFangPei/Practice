//
//  ViewController.m
//  Runtime
//
//  Created by peixiaofang on 2017/11/28.
//  Copyright © 2017年 peixiaofang. All rights reserved.
//

/*
 1.SEL selector在Objc中的表示。selector是方法选择器，其实作用就是和名字一样，它的数据结构是
 typedef struct objc_selector *SEL;
 2. id 是一个参数类型，它是指向某个类的实例指针，定义如下
 typedef struct objc_object *id;
 struct objc_object {
 Class isa;
 };
 3. Class 指向objc_class结构体的 指针
 4. Method 代表类中的某个方法的结构体类型
 5. IMP 函数指针，由编译器生成的
 6. Cache
 7.Prooerty
 */
#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"

typedef struct objc_selector *SEL;
typedef struct objc_object *id;
//struct objc_object {
//    Class isa;
//};
//typedef struct objc_class *Class;
//typedef struct objc_property_t *Property;
//struct objc_class {
//    Class isa OBJC_ISA_AVAILABILITY;
//};

@interface ViewController ()

@end

@implementation ViewController
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzlledSelector = @selector(xxx_ViewDidLoad);
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzlledSelector);
        BOOL didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(aClass, swizzlledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
- (void)xxx_ViewDidLoad {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //id objc_msgSend(id self, SEL op);
   // class_addIvar([Person class], <#const char * _Nonnull name#>, <#size_t size#>, <#uint8_t alignment#>, <#const char * _Nullable types#>)
    unsigned int outCount =0;
    objc_property_t *priperties = class_copyPropertyList([Person class], &outCount);
    NSLog(@"%d", outCount);
    for (NSInteger i = 0; i < outCount; i++) {
        NSString *name = @(property_getName(priperties[i]));// 用来查找属性的名称，返回c字符串
        NSString *attributes = @(property_getAttributes(priperties[i])); // 函数挖掘属性的真实名称和@encode类型，返回字符串
         NSLog(@"%@--------%@", name, attributes);
    }
    
}
// 消息转发 重定向
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(myMethod)) {
        return [Person class];
    }
    return [super forwardingTargetForSelector:aSelector];
}
// 转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([[Person class] respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:[Person class]];
    } else
        [super forwardInvocation:anInvocation];
}
- (void)myMethod {

}
- (void)alternateObject {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
