//
//  ConsumTimeHelper.m
//  iOS-Startup-Optimize-Demo
//
//  Created by keke on 2018/8/28.
//  Copyright © 2018年 kekeyezi. All rights reserved.
//

#import "ConsumTimeHelper.h"
#import <UIKit/UIKit.h>
#import "YYModel.h"
#import "YYGHUser.h"

@implementation ConsumTimeHelper

+ (void)consumTimeWithCount:(long)count {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    /// Benchmark
    NSTimeInterval begin, end;
    
    @autoreleasepool {
        for (int i = 0; i < count; i++) {
            // YYModel
            [YYGHUser yy_modelWithJSON:json];
        }
    }
    /// warm up holder
    NSMutableArray *holder = [NSMutableArray new];
    for (int i = 0; i < 1800; i++) {
        [holder addObject:[NSDate new]];
    }
    [holder removeAllObjects];
    
    /*------------------- JSON Serialization -------------------*/
    {
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        printf("JSON(*):            %8.2f   ", (end - begin) * 1000);
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:nil];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        printf("%8.2f   \n", (end - begin) * 1000);
    }
    
    /*------------------- YYModel -------------------*/
    {
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                YYGHUser *user = [YYGHUser yy_modelWithJSON:json];
                [holder addObject:user];
            }
        }
        end = CACurrentMediaTime();
        printf("YYModel(#):         %8.2f   ", (end - begin) * 1000);
        
        
        YYGHUser *user = [YYGHUser yy_modelWithJSON:json];
        if (user.userID == 0) NSLog(@"error!");
        if (!user.login) NSLog(@"error!");
        if (!user.htmlURL) NSLog(@"error");
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSDictionary *json = [user yy_modelToJSONObject];
                [holder addObject:json];
            }
        }
        end = CACurrentMediaTime();
        if ([NSJSONSerialization isValidJSONObject:[user yy_modelToJSONObject]]) {
            printf("%8.2f   ", (end - begin) * 1000);
        } else {
            printf("   error   ");
        }
        
        
        [holder removeAllObjects];
        begin = CACurrentMediaTime();
        @autoreleasepool {
            for (int i = 0; i < count; i++) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                [holder addObject:data];
            }
        }
        end = CACurrentMediaTime();
        printf("%8.2f\n", (end - begin) * 1000);
    }
}

@end
