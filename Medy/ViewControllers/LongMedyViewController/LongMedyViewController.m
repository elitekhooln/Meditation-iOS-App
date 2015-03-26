//
//  LongMedyViewController.m
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import "LongMedyViewController.h"
#import <ActionSheetStringPicker.h>

@interface LongMedyViewController ()
{
    BOOL isMedyStarted;
    NSTimer *medyTimer;
    NSDate *medyStartTime;
    NSDateFormatter *dateFormatter;
    NSDate *medyTime;
    int medyTimeLimit;
}
@end

@implementation LongMedyViewController
@synthesize timeLbl;
@synthesize timeTitleLbl;
@synthesize volumeSlider;
@synthesize medyBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [volumeSlider setThumbImage:[UIImage imageNamed:@"soundIcon"] forState:UIControlStateNormal];
    //[volumeSlider setThumbImage:[UIImage imageNamed:@"soundIcon"] forState:UIControlStateHighlighted];
    
    isMedyStarted = NO;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didMedyClicked:(id)sender {
    if (isMedyStarted) {
        isMedyStarted = NO;
        [medyBtn setImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
        [timeLbl setTextColor:[UIColor blackColor]];
        [timeTitleLbl setText:@"TIMER"];
        [medyTimer invalidate];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                                       fromDate:medyStartTime
                                                                         toDate:[NSDate date]
                                                                        options:0];
        medyTime = [[NSCalendar currentCalendar] dateFromComponents:components];
        [timeLbl setText:[dateFormatter stringFromDate:medyTime]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDate *totalMedyTime = [defaults objectForKey:@"medyTime"];
        NSLog(@"Previous Total Medy Time: %@",[dateFormatter stringFromDate:totalMedyTime]);
        
        totalMedyTime = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:totalMedyTime options:0];
        NSLog(@"Total Medy Time: %@",[dateFormatter stringFromDate:totalMedyTime]);
        [defaults setObject:totalMedyTime forKey:@"medyTime"];
        [defaults synchronize];
    } else {
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 60; i++) {
            [timeArray addObject:[NSNumber numberWithInt:i]];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select duration"
                                                rows:timeArray
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               NSLog(@"Picker: %@", picker);
                                               NSLog(@"Selected Index: %d", (int)selectedIndex);
                                               NSLog(@"Selected Value: %@", selectedValue);
                                               medyTimeLimit = [selectedValue intValue];
                                               
                                               isMedyStarted = YES;
                                               [medyBtn setImage:[UIImage imageNamed:@"pauseBtn"] forState:UIControlStateNormal];
                                               [timeLbl setTextColor:[UIColor redColor]];
                                               [timeTitleLbl setText:@"TIME REMAINING"];
                                               medyStartTime = [NSDate date];
                                               medyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:sender];
    }
}

- (void)countTime {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:medyStartTime
                                                 toDate:[NSDate date]
                                                options:0];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    medyTime = [gregorian dateFromComponents:components];
    
    [timeLbl setText:[dateFormatter stringFromDate:medyTime]];
    
    if ((int)components.minute >= medyTimeLimit) {
        [self didMedyClicked:self];
    }
}
@end
