//
//  KKTimeWatch.m
//  Pods
//
//  Created by Daniel on 2017/9/2.
//
//
//* Click https://github.com/kekeYezi/KKTimeWatch
//* or https://kekeyezi.github.io to contact us.
//

#import "KKTimeWatch.h"
#import <UIKit/UIKit.h>
#import <mach/mach_time.h>

@interface KKTimeWatch ()



@property (nonatomic, assign) CFTimeInterval startTimeInterval;

@property (nonatomic, assign) CFTimeInterval passTimeInterval;

@property (nonatomic, strong) NSMutableArray *timeRecordArray;

@end

@implementation KKTimeWatch

static uint64_t loadTime;
static uint64_t applicationRespondedTime = -1;
static mach_timebase_info_data_t timebaseInfo;

static inline NSTimeInterval MachTimeToSeconds(uint64_t machTime) {
    return ((machTime / 1e9) * timebaseInfo.numer) / timebaseInfo.denom;
}

+ (void)load {
    loadTime = mach_absolute_time();
    mach_timebase_info(&timebaseInfo);
    
    @autoreleasepool {
        __block id<NSObject> obs;
        obs = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                                object:nil queue:nil
                                                            usingBlock:^(NSNotification *note) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    applicationRespondedTime = mach_absolute_time();
                                                                    NSLog(@"StartupMeasurer: it took %f seconds until the app could respond to user interaction.", MachTimeToSeconds(applicationRespondedTime - loadTime));
                                                                });
                                                                [[NSNotificationCenter defaultCenter] removeObserver:obs];
                                                            }];
    }
}

+ (instancetype)sharedTimewatch {
    static KKTimeWatch* timewatch;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timewatch = [[KKTimeWatch alloc] init];
    });
    
    return timewatch;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeRecordArray = [NSMutableArray array];
        self.passTimeInterval = 0;
    }
    return self;
}

- (void)startWatch {
    self.startTimeInterval = CACurrentMediaTime();
}

- (void)resetWatch {
    self.startTimeInterval = CACurrentMediaTime();
    self.passTimeInterval = 0;
    [self.timeRecordArray removeAllObjects];
}

- (void)watchEndWithDescription:(NSString *)description {
    [self watchWithDescription:description];
    
    NSString *totoalInfo = [NSString stringWithFormat:@"\n总消耗:%.6f", self.passTimeInterval];
    NSString *showInfoString = [[self.timeRecordArray componentsJoinedByString:@"\n"] stringByAppendingString:totoalInfo];
    
    [[[UIAlertView alloc] initWithTitle:@"KKTimeWatch 时间序列" message:showInfoString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
}

- (void)watchWithDescription:(NSString *)description {
    NSTimeInterval currentTimeInterval = CACurrentMediaTime();
    NSTimeInterval resultTimeInterval = currentTimeInterval - self.startTimeInterval - self.passTimeInterval;
    self.passTimeInterval = self.passTimeInterval + resultTimeInterval;
    NSString *result = [NSString stringWithFormat:@"%@:%.6f", description, resultTimeInterval];
    @synchronized (self) {
        [self.timeRecordArray addObject:result];
    }
}

@end
