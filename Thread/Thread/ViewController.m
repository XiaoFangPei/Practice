//
//  ViewController.m
//  Thread
//
//  Created by peixiaofang on 2018/3/19.
//  Copyright © 2018年 sinosoft. All rights reserved.
// iOS多线程编程

// 主线程负责用户看得见的任务 例如:添加控件,刷新页面 除了主线程以外,都叫子线程。
// 子线程一般负责用户之间看不到的任务,例如,加载图片的过程,下载视频等

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*GCD 队列和执行方式
     主队列 是GCD自带的一种特殊串行队列，放在主队列中的任务，都会放在主线程中执行
     dispatch_get_main_queue()
     全局队列
     队列 任务执行方式 并发多个任务同时执行，串行一个一个执行
     1 串行队列 让任务一个接一个地执行 （一个任务执行完毕后，再执行下一个任务）
     2 并发队列 可以多个任务同时执行 （自动开启多个线程同时执行任务）
     3 主队列 专门负责调度主线程任务，没有办法开辟新线程，任务在主线程只会顺序执行
     执行方式 执行的顺序 同步按顺序执行，异步不按顺序执行
     1.同步执行  在当前线程中执行任务，不具备开启新线程的能力
     2.异步执行 在新的线程中执行任务，具备开启新线程的能力
     任务 block
     死锁 如果向主队列中添加一个同步任务会死锁
     死锁原因：我们知道dispatch_sync表示同步的执行任务，也就是说执行dispatch_sync后，当前队列会阻塞。而dispatch_sync中的block如果要在当前队列中执行，就得等待当前队列程执行完成。
        主队列在执行dispatch_sync，随后队列中新增一个任务block。因为主队列是同步队列，所以block要等dispatch_sync执行完才能执行，但是dispatch_sync是同步派发，要等block执行完才算是结束。在主队列中的两个任务互相等待，导致了死锁。
     */
//    NSLog(@"%@", [NSThread currentThread]);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"async----%@",[NSThread currentThread]);
//    });
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"sync----%@",[NSThread currentThread]);
//    });
//   NSLog(@"----%@",[NSThread currentThread]);
    // 开辟队列
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
    /**
     参数1：标签，用于区分队列
     参数2：队列的类型，表示这个队列是串行队列还是并发队列NUll表示串行队列，
     DISPATCH_QUEUE_CONCURRENT表示并发队列
     */
    // 执行队列的方法
    // 异步执行
    //dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
    // 同步执行
    //dispatch_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
    //[self asncGlobalQueue];
    //[self groupQueue];
    // 创建信号量
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2); // 创建信号量，并设置初始值为2
//    dispatch_async(myQueue, ^{
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 等待信号量大于等于1
//
//        dispatch_semaphore_signal(semaphore);// 发送信号量，信号量加1
//
//    });
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) // 等待信号量
    //NSOperation 同步执行 是对gcd中block的封装，也表示要执行的任务。表示的任务可以被取消
//    [self operationQueue];
    //[self testSerialQueueWithAsync];
    //[self testConcurrentQueueWithAsync];
    //[self testSerialQueueWithSync];
    //[self testConcurrentQueueWithSync];
    //[self testBarrierSyncWithConCurrentQueue];
}
- (void)operationQueue {
    
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"=========%@", [NSThread currentThread]);
    }];
    //[operation start]; //NSOperation可以调用start方法来执行任务，但默认是同步执行的
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operation addExecutionBlock:^{
        NSLog(@"====block1");
        NSLog(@"=========%@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"====block2");
         NSLog(@"=========%@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^{
        NSLog(@"====block3");
         NSLog(@"=========%@", [NSThread currentThread]);
    }];
    [operationQueue addOperation:operation];
    NSLog(@"=====结束");
    // 取消任务
    [operation cancel];
    [operationQueue cancelAllOperations];
}
-(void)groupQueue {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue2 = dispatch_queue_create("com.sinosoft.queue",DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"1======%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i<5; i++) {
            NSLog(@"2======%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue2, ^{
     NSLog(@"组1和组2都完成了=========%@", [NSThread currentThread]);
    });
   long isCompleted =  dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"%ld", isCompleted);
    /*
     dispatch_group_wait方法是一个很有用的方法，它的完整定义如下：
     
     dispatch_group_wait(group: dispatch_group_t, _ timeout: dispatch_time_t) -> Int
     
     第一个参数表示要等待的group，第二个则表示等待时间。返回值表示经过指定的等待时间，属于这个group的任务是否已经全部执行完，如果是则返回0，否则返回非0。
     
     第二个dispatch_time_t类型的参数还有两个特殊值：DISPATCH_TIME_NOW和DISPATCH_TIME_FOREVER。
     
     前者表示立刻检查属于这个group的任务是否已经完成，后者则表示一直等到属于这个group的任务全部完成。
     */
}
// 串行队列异步
//遵守先进先出原则 顺序打印。每次dispatch_async开辟线程执行串行队列中的任务时，总是使用同一个异步线程。serial_queue Running on main Thread这句话并没有在最后 执行，而是会 出现在随机的位置，它会开辟一个新的县城执行，不会阻塞主线程。
- (void)testSerialQueueWithAsync {
    dispatch_queue_t serial_queue = dispatch_queue_create("com.reviewcode.www", DISPATCH_QUEUE_SERIAL);
    for (int index = 0; index < 10; index++) {
        dispatch_async(serial_queue, ^{
            NSLog(@"serial_queueindex=%d", index);
            NSLog(@"currentThread= %@", [NSThread currentThread]);
        });
    }
    NSLog(@"serial_queue Running on main Thread");
}
// 并行异步
//每次执行一次任务dispatch_async总会为我们开辟一个新的线程来执行任务。不同线程开始结束时间都不一样，导致了乱序 主线程没有阻塞。
- (void)testConcurrentQueueWithAsync {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.xiaofang.www", DISPATCH_QUEUE_CONCURRENT);
    for (int index = 0; index < 10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index=%d", index);
            NSLog(@"currentThread= %@", [NSThread currentThread]);
        });
    }
    NSLog(@"Running on main Thread");
}
// 串行同步
// dispatch_sync并没有开辟一个新的线程，直接在当前线程中执行代码（主线程），所以会阻塞当前线程。
- (void)testSerialQueueWithSync {
    dispatch_queue_t serial_queue = dispatch_queue_create("com.reviewcode.www", DISPATCH_QUEUE_SERIAL);
    for (int index = 0; index < 10; index++) {
        dispatch_sync(serial_queue, ^{
            NSLog(@"serial_queueindex=%d", index);
            NSLog(@"currentThread= %@", [NSThread currentThread]);
        });
    }
    NSLog(@"serial_queue Running on main Thread");
}
//并行同步
// 结果和 在串行队列执行的效果一摸一样。dispatch_sync并没有开辟一个新的线程，
- (void)testConcurrentQueueWithSync {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.xiaofang.www", DISPATCH_QUEUE_CONCURRENT);
    for (int index = 0; index < 10; index++) {
        dispatch_sync(concurrent_queue, ^{
            NSLog(@"index=%d", index);
            NSLog(@"currentThread= %@", [NSThread currentThread]);
        });
    }
    NSLog(@"Running on main Thread");
}
// dispatch_barrier之后的任务总是得dispatch_barrier之前的任务完成之后再执行
// barrier和串行队列配合是完全没有意义的。barrier的目的是为了某种情况下，同一个队列中有一些并发任务必须在另一些并发任务之后执行，所以需要一个类似于拦截的功能，迫使执行的任务必须等待。串行队列中的所有任务本身就是按照顺序执行的，没有必要使用拦截功能。
// barrier实现的基本条件是要写在同一个队列中。使用global queue系统分配你的可能是不同的并行队列，你在其中插入一个barrier没有意义。
//dispatch_barrier_sync 会在队列中充当一个栅栏的作用，凡是在他之后进入队列的任务，总会在dispatch_barrier_sync之前的所有任务执行完毕之后才执行。 会在主线程执行队列中的任务，主线程会被阻塞，从而在barrier之后执行。
- (void)testBarrierSyncWithConCurrentQueue {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.xiaofang.www", DISPATCH_QUEUE_CONCURRENT);
    for (int index = 0; index<10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index = %d", index);
        });
    }
    for (int j = 0; j<100; j++) {
        dispatch_barrier_sync(concurrent_queue, ^{
            if (j == 100 - 1) {
                NSLog(@"barrier Finished");
                NSLog(@"currentThread= %@", [NSThread currentThread]);
            }
        });
    }
    NSLog(@"Running on main Thread");
    for (int index = 10; index<20; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index = %d", index);
        });
    }
}
// dispatch_barrier_async 会开辟一条新的线程执行其中的任务，所以不会阻塞当前线程，其他功能和dispatch_barrier_sync相同。
- (void)testBarrierAsyncWithConCurrentQueue {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.xiaofang.www", DISPATCH_QUEUE_CONCURRENT);
    for (int index = 0; index<10; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index = %d", index);
        });
    }
    for (int j = 0; j<100; j++) {
        dispatch_barrier_async(concurrent_queue, ^{
            if (j == 100 - 1) {
                NSLog(@"barrier Finished");
                NSLog(@"currentThread= %@", [NSThread currentThread]);
            }
        });
    }
    NSLog(@"Running on main Thread");
    for (int index = 10; index<20; index++) {
        dispatch_async(concurrent_queue, ^{
            NSLog(@"index = %d", index);
        });
    }
}
// 测试NSMutableDictionary是否是线程安全的
- (void)testMutableDictionnaryThreadSafe {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.xiaofang.www", DISPATCH_QUEUE_CONCURRENT);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(concurrent_queue, ^{
        for (int index = 0; index < 100; index++) {
            dict[@(index)] = @(index);
        }
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"dict is %@", dict);
}
 // 运行崩溃 说明NSMutableDictionnary不是线程安全的
// 使用GCD实现线程安全的字典

- (void)asncGlobalQueue {
    // 获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_queue_create("com.sinosoft.queue",NULL);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    void (^task) (void) = ^ {
        dispatch_sync(queue, ^{
            NSLog(@"Login %@", [NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"Download A %@", [NSThread currentThread]);
        });
        dispatch_async(queue, ^{
            NSLog(@"Download B %@", [NSThread currentThread]);
        });
    };
    dispatch_sync(queue2, task);
//    dispatch_async(queue, ^{
//        NSLog(@"任务1%@\n", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务2%@\n", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务3%@\n", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"任务4%@", [NSThread currentThread]);
//    });
    dispatch_async(queue2, ^{
        NSLog(@"任务5%@\n", [NSThread currentThread]);
    });
//    dispatch_sync(queue2, ^{
//        NSLog(@"任务6%@\n", [NSThread currentThread]);
//    });
//    dispatch_sync(queue2, ^{
//        NSLog(@"任务7%@\n", [NSThread currentThread]);
//    });
//    dispatch_sync(queue2, ^{
//        NSLog(@"任务8%@", [NSThread currentThread]);
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
