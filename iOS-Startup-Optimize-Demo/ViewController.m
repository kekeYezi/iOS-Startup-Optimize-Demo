//
//  ViewController.m
//  iOS-Startup-Optimize-Demo
//
//  Created by keke on 2018/8/27.
//  Copyright © 2018年 kekeyezi. All rights reserved.
//

#import "ViewController.h"
#import "KKTimeWatch.h"
#import "ConsumTimeHelper.h"
#import "SMCallTrace.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    KKTimeWatchRecord(@"viewDidAppear")
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testInMainThread];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)testInMainThread {
    KKTimeWatchRecord(@"sleepFunc2 start")
    [ConsumTimeHelper consumTimeWithCount:8000];
    KKTimeWatchRecord(@"sleepFunc2 end")
    [SMCallTrace stop];
    [SMCallTrace save];
}

- (void)testInDispatchGlobalQueue {
    KKTimeWatchRecord(@"sleepFunc2 start")
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^() {
        [ConsumTimeHelper consumTimeWithCount:30000];
        dispatch_async(dispatch_get_main_queue(), ^{
            KKTimeWatchRecord(@"sleepFunc2 end")
//            [SMCallTrace stop];
//            [SMCallTrace save];
        });
    });
}

- (IBAction)touchTest:(id)sender {
    NSLog(@"touchTest");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"tap");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
