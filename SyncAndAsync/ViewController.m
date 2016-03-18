//
//  ViewController.m
//  SyncAndAsync
//
//  Created by Hoàng Thái on 3/18/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSTimer *Timer;
    NSDate *startDate;
    BOOL running;
    NSString *getTimeString;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbl.text = @"00.00.00.000";
    running = FALSE;
    startDate = [NSDate date];
}


- (void) demoSynchronous {
    dispatch_queue_t serialQueue = dispatch_queue_create("sync", DISPATCH_QUEUE_SERIAL);
    for (int i = 1; i <= 20; i++) {
        dispatch_sync(serialQueue, ^{
            [NSThread sleepForTimeInterval:0.2];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSDate *currentDate = [NSDate date];
                NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
                NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
                NSString *timeString=[dateFormatter stringFromDate:timerDate];
                getTimeString = [NSString stringWithFormat:@"%@", timeString];
                NSLog(@"%@", getTimeString);
                if (i == 20) {
                    NSLog(@"Done");
                    running = FALSE;
                    [Timer invalidate];
                    Timer = nil;
                }
            });
        });
    }
}

- (void) demoAsynchronous {
    dispatch_queue_t serialQueue = dispatch_queue_create("sync", DISPATCH_QUEUE_SERIAL);
    for (int i = 1; i <= 20; i++) {
        dispatch_async(serialQueue, ^{
            [NSThread sleepForTimeInterval:0.2];
            NSLog(@"%@", getTimeString);
            if (i == 20) {
                NSLog(@"Done");
                running = FALSE;
                [Timer invalidate];
                Timer = nil;
            }
        });
    }
}
- (IBAction)syncPressed:(id)sender {
    startDate = [NSDate date];
    self.lbl.text = @"00.00.00.000";
    running = TRUE;
    if (Timer == nil) {
        Timer = [NSTimer scheduledTimerWithTimeInterval:0.0167
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    [self demoSynchronous];
}

- (IBAction)asyncPressed:(id)sender {
    startDate = [NSDate date];
    self.lbl.text = @"00.00.00.000";
    running = TRUE;
    if (Timer == nil) {
        Timer = [NSTimer scheduledTimerWithTimeInterval:0.0167
                                                     target:self
                                                   selector:@selector(updateTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    [self demoAsynchronous];
}

- (IBAction)startPressed:(id)sender {
    if(!running){
        running = TRUE;
        self.btnStart.hidden = YES;
        if (Timer == nil) {
            Timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }else{
        running = FALSE;
        [Timer invalidate];
        Timer = nil;
    }
    
}
- (IBAction)stopPressed:(id)sender {
    running = FALSE;
    [Timer invalidate];
    Timer = nil;
    self.btnStart.hidden = NO;
}

-(void)updateTimer{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    getTimeString = [NSString stringWithFormat:@"%@", timeString];
    self.lbl.text = timeString;
}

- (IBAction)resetPressed:(id)sender {
    [Timer invalidate];
    Timer = nil;
    startDate = [NSDate date];
    self.lbl.text = @"00.00.00.000";
    running = FALSE;
    self.btnStart.hidden = NO;
}

@end
