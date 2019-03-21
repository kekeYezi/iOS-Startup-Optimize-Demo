//
//  main.m
//  iOS-Startup-Optimize-Demo
//
//  Created by keke on 2018/8/27.
//  Copyright © 2018年 kekeyezi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KKTimeWatch.h"
#import "SMCallTrace/SMCallTrace.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        KKTimeWatchStart
        [SMCallTrace start];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
