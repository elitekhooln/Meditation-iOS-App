//
//  ShortMedyViewController.m
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import "ShortMedyViewController.h"
#import <ActionSheetDatePicker.h>
#import <AVFoundation/AVFoundation.h>

@interface ShortMedyViewController ()
{
    BOOL isMedyStarted;
    NSTimer *medyTimer;
    NSDate *medyStartTime;
    NSDateFormatter *dateFormatter;
    NSDate *medyTime;
    int selectedButtonNumber;
    NSArray *navButtonArray;
    AVAudioPlayer *audioPlayer;
    int levelupMinutes;
    int medyButtonStatus; // 0: can play, start no pause // 1: started no play no pause // 2: can pause no play, no start
}
@end

@implementation ShortMedyViewController
@synthesize timeLbl;
@synthesize timeTitleLbl;
@synthesize volumeSlider;
@synthesize medyBtn;
@synthesize circleBtn;
@synthesize clockBtn;
@synthesize settingsBtn;
@synthesize medyInfoView;
@synthesize totalMedyInfoView;
@synthesize totalTimeLbl;
@synthesize totalTimeTitle;
@synthesize headLevelLbl;
@synthesize trailLevelLbl;
@synthesize levelProgress;
@synthesize overlayView;
@synthesize playMedyBtn;
@synthesize pauseMedyBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [volumeSlider setThumbImage:[UIImage imageNamed:@"soundIcon"] forState:UIControlStateNormal];
    //[volumeSlider setThumbImage:[UIImage imageNamed:@"soundIcon"] forState:UIControlStateHighlighted];
    
    isMedyStarted = NO;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    [circleBtn setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [circleBtn setImage:[UIImage imageNamed:@"circle_bl"] forState:UIControlStateSelected];
    
    [clockBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    [clockBtn setImage:[UIImage imageNamed:@"clock_bl"] forState:UIControlStateSelected];
    
    [settingsBtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [settingsBtn setImage:[UIImage imageNamed:@"settings_bl"] forState:UIControlStateSelected];
    
    selectedButtonNumber = 1;
    navButtonArray = @[clockBtn, circleBtn, settingsBtn];
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:YES];
    
    NSError *playerError;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"Peaceful_Music_Meditation" ofType:@"mp3"]] error:&playerError];
    audioPlayer.meteringEnabled = YES;
    audioPlayer.numberOfLoops = -1;
    if (audioPlayer == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    
    [audioPlayer prepareToPlay];
    audioPlayer.currentTime = 0;
    [self didVolumeChange:self];
    
    //levelProgress.trackTintColor = [UIColor colorWithRed:0.0f / 255.0f green:158.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f];
    [volumeSlider setMinimumTrackTintColor:[UIColor colorWithRed:0.0f / 255.0f green:148.0f / 255.0f blue:255.0f / 255.0f alpha:1.0f]];
    
    //ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:self.view.frame];
    //[self.view addSubview:translucentView]; //that's it :)
    
    //optional:
    overlayView.translucentAlpha = 0.0f;
    overlayView.translucentStyle = UIBarStyleDefault;
    overlayView.translucentTintColor = [UIColor clearColor];
    overlayView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.45f];
    
    overlayView.userInteractionEnabled = YES;
    UITapGestureRecognizer *overlayViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCircleClick:)];
    [overlayView addGestureRecognizer:overlayViewTapGesture];
    
    levelupMinutes = 3;
    
    medyButtonStatus = 0;
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


- (IBAction)didMedyTouchDown:(id)sender {
    medyButtonStatus = 1;
    [playMedyBtn setImage:[UIImage imageNamed:@"medyPlayBtnGray"] forState:UIControlStateNormal];
    playMedyBtn.enabled = NO;
    [pauseMedyBtn setImage:[UIImage imageNamed:@"medyPauseGray"] forState:UIControlStateNormal];
    pauseMedyBtn.enabled = NO;
    
    [self startMeditation];
}

- (void)startMeditation {
    [audioPlayer play];
    [self didVolumeChange:self];
    
    if (selectedButtonNumber != 1) {
        [self didCircleClick:self];
    }
    
    isMedyStarted = YES;
    [timeLbl setTextColor:[UIColor redColor]];
    medyStartTime = [NSDate date];
    medyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
}

- (IBAction)didMedyTouchUp:(id)sender {
    medyButtonStatus = 0;
    [playMedyBtn setImage:[UIImage imageNamed:@"medyPlayBtn"] forState:UIControlStateNormal];
    playMedyBtn.enabled = YES;
    [pauseMedyBtn setImage:[UIImage imageNamed:@"medyPauseGray"] forState:UIControlStateNormal];
    pauseMedyBtn.enabled = NO;
    
    [self stopMeditation];
}

- (void)stopMeditation {
    isMedyStarted = NO;
    [timeLbl setTextColor:[UIColor blackColor]];
    [medyTimer invalidate];
    medyTimer = nil;
    
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
    
    [audioPlayer pause];
}

- (IBAction)didCircleClick:(id)sender {
    if (selectedButtonNumber == 1) {
        return;
    }
    [overlayView setHidden:YES];
    
    if (selectedButtonNumber == 2 || selectedButtonNumber == 1) {
        CGRect totalMedyInfoViewFrame = totalMedyInfoView.frame;
        totalMedyInfoViewFrame.origin.y = -totalMedyInfoViewFrame.size.height;
        CGRect originTotalMedyInfoViewFrame = totalMedyInfoViewFrame;
        originTotalMedyInfoViewFrame.origin.y = 0;
        totalMedyInfoView.frame = originTotalMedyInfoViewFrame;
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             totalMedyInfoView.frame = totalMedyInfoViewFrame;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                             [totalMedyInfoView setHidden:YES];
                         }];
    }
    
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:NO];
    selectedButtonNumber = 1;
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:YES];
}

- (IBAction)didClockClick:(id)sender {
    if (selectedButtonNumber == 0) {
        return;
    }
    [overlayView setHidden:YES];
    
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:NO];
    selectedButtonNumber = 0;
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:YES];
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 60; i++) {
        [timeArray addObject:[NSNumber numberWithInt:i]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *notificationTime;
    NSNumber *notificationTimeSet = [defaults objectForKey:@"NotificationTimeSet"];
    if (notificationTimeSet && [notificationTimeSet boolValue] == YES) {
        notificationTime = [defaults objectForKey:@"NotificationTime"];
    } else {
        notificationTime = [NSDate date];
    }
    
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"Daily Reminders" datePickerMode:UIDatePickerModeTime selectedDate:notificationTime doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *selectedDateComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:selectedDate];
        NSDateComponents *currentDatecomponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:selectedDate];
        [currentDatecomponents setHour:selectedDateComponents.hour];
        [currentDatecomponents setMinute:selectedDateComponents.minute];
        [currentDatecomponents setSecond:0];
        selectedDate = [calendar dateFromComponents:currentDatecomponents];
        
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        NSLog(@"%@", [dateFormatter stringFromDate:selectedDate]);
        NSLog(@"%@", selectedDate);
        [localNotification setFireDate:selectedDate];
        [localNotification setAlertBody:@"It's your meditation time"];
        //[localNotification setAlertAction:@"Show me the item"];
        [localNotification setTimeZone:[NSTimeZone systemTimeZone]];
        [localNotification setRepeatInterval:NSCalendarUnitDay];
        //[localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [defaults setObject:selectedDate forKey:@"NotificationTime"];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"NotificationTimeSet"];
        [defaults synchronize];
        
        [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:NO];
        selectedButtonNumber = 1;
        [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:YES];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"NotificationTimeSet"];
        [defaults synchronize];
        
        [self didCircleClick:self];
    } origin:sender];
    
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"Clear"  style:UIBarButtonItemStylePlain target:nil action:nil]];
    
    [picker addCustomButtonWithTitle:@"Cancel" actionBlock:^{
        [self didCircleClick:self];;
    }];
    [picker showActionSheetPicker];
}

- (IBAction)didSettingsClick:(id)sender {
    if (selectedButtonNumber == 2) {
        return;
    }
    
    [overlayView setHidden:NO];
    
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:NO];
    selectedButtonNumber = 2;
    [(UIButton *)[navButtonArray objectAtIndex:selectedButtonNumber] setSelected:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *totalMedyTime = [defaults objectForKey:@"medyTime"];
    NSNumber *userLevel = [defaults objectForKey:@"userLevel"];
    
    [totalTimeLbl setText:[dateFormatter stringFromDate:totalMedyTime]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                                   fromDate:totalMedyTime];
    
    int totalMinutes = (int)(components.hour * 60 + components.minute);
    
    userLevel = [NSNumber numberWithInt:totalMinutes / levelupMinutes + 1];
    [defaults setObject:userLevel forKey:@"userLevel"];
    [headLevelLbl setText:[NSString stringWithFormat:@"LV.%d", [userLevel intValue]]];
    [trailLevelLbl setText:[NSString stringWithFormat:@"LV.%d", [userLevel intValue] + 1]];
    totalMinutes = totalMinutes % levelupMinutes;
    int levelProgressValue = totalMinutes * 60 + (int)components.second;
    [levelProgress setProgress:(float)levelProgressValue / (float)(levelupMinutes * 60)];
    
    [totalMedyInfoView setHidden:NO];
    CGRect totalMedyInfoViewFrame = totalMedyInfoView.frame;
    totalMedyInfoViewFrame.origin.y = -totalMedyInfoViewFrame.size.height;
    CGRect originTotalMedyInfoViewFrame = totalMedyInfoViewFrame;
    originTotalMedyInfoViewFrame.origin.y = 0;
    totalMedyInfoView.frame = totalMedyInfoViewFrame;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         totalMedyInfoView.frame = originTotalMedyInfoViewFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}

- (IBAction)didVolumeChange:(id)sender {
    [audioPlayer setVolume:volumeSlider.value];
}

- (IBAction)didMedyTouchOutside:(id)sender {
    NSLog(@"Medy touch outside");
    [self didMedyTouchUp:self];
}

- (IBAction)didPlaymedyTap:(id)sender {
    medyButtonStatus = 2;
    [playMedyBtn setImage:[UIImage imageNamed:@"medyPlayBtnGray"] forState:UIControlStateNormal];
    playMedyBtn.enabled = NO;
    [pauseMedyBtn setImage:[UIImage imageNamed:@"medyPause"] forState:UIControlStateNormal];
    pauseMedyBtn.enabled = YES;
    [medyBtn setImage:[UIImage imageNamed:@"holdBtnGray"] forState:UIControlStateNormal];
    medyBtn.enabled = NO;
    
    [self startMeditation];
}

- (IBAction)didPausemedyTap:(id)sender {
    medyButtonStatus = 0;
    [playMedyBtn setImage:[UIImage imageNamed:@"medyPlayBtn"] forState:UIControlStateNormal];
    playMedyBtn.enabled = YES;
    [pauseMedyBtn setImage:[UIImage imageNamed:@"medyPauseGray"] forState:UIControlStateNormal];
    pauseMedyBtn.enabled = NO;
    [medyBtn setImage:[UIImage imageNamed:@"holdBtn"] forState:UIControlStateNormal];
    medyBtn.enabled = YES;
    
    [self stopMeditation];
}

- (void)countTime {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:medyStartTime
                                                 toDate:[NSDate date]
                                                options:0];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    medyTime = [gregorian dateFromComponents:components];
    [timeLbl setText:[dateFormatter stringFromDate:medyTime]];
}
@end
