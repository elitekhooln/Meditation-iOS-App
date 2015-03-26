//
//  SettingsViewController.m
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import "SettingsViewController.h"
#import <ActionSheetDatePicker.h>

@interface SettingsViewController ()
{
    NSDateFormatter *dateFormatter;
}
@end

@implementation SettingsViewController

@synthesize totalTimeLbl;
@synthesize headLevelLbl;
@synthesize trailLevelLbl;
@synthesize levelProgress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *totalMedyTime = [defaults objectForKey:@"medyTime"];
    NSNumber *userLevel = [defaults objectForKey:@"userLevel"];
    
    [totalTimeLbl setText:[dateFormatter stringFromDate:totalMedyTime]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                                   fromDate:totalMedyTime];
    
    int totalMinutes = (int)(components.hour * 60 + components.minute);
    
    userLevel = [NSNumber numberWithInt:totalMinutes / 30 + 1];
    [defaults setObject:userLevel forKey:@"userLevel"];
    [headLevelLbl setText:[NSString stringWithFormat:@"LV.%d", [userLevel intValue]]];
    [trailLevelLbl setText:[NSString stringWithFormat:@"LV.%d", [userLevel intValue] + 1]];
    totalMinutes = totalMinutes % 30;
    int levelProgressValue = totalMinutes * 60 + (int)components.second;
    [levelProgress setProgress:levelProgressValue / (30 * 60)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didReminderClicked:(id)sender {
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 60; i++) {
        [timeArray addObject:[NSNumber numberWithInt:i]];
    }
    
    [ActionSheetDatePicker showPickerWithTitle:@"Select time" datePickerMode:UIDatePickerModeDateAndTime selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        // Schedule the notification
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        NSLog(@"%@", [dateFormatter stringFromDate:selectedDate]);
        NSLog(@"%@", selectedDate);
        //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        localNotification.fireDate = selectedDate;
        localNotification.alertBody = @"It's your meditation time";
        //localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone systemTimeZone];
        //localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        ;
    } origin:sender];
}

- (IBAction)didInviteClicked:(id)sender {
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //set receipients
    NSArray *recipients = [[NSArray alloc] init];
    
    //set message text
    NSString * message = @"Use Medy app for your meditation.";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops, error while sendind SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didMemberClicked:(id)sender {
    // Subscription
}

- (IBAction)didEventClicked:(id)sender {
    // WebView
}

- (IBAction)didContactClicked:(id)sender {
    //check if the device can send email
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //set receipients
    NSArray *recipients = @[@"info@medy.com"];
    
    //set message text
    NSString * message = @"";
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:recipients];
    [mailController setMessageBody:message isHTML:YES];
    
    // Present message view controller on screen
    [self presentViewController:mailController animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            ;
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oops, error while sendind email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
            break;
            ;
            break;
        case MFMailComposeResultSaved:
            ;
            break;
        case MFMailComposeResultSent:
            ;
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTutorialClicked:(id)sender {
}
@end
