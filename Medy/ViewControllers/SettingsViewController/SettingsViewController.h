//
//  SettingsViewController.h
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *headLevelLbl;
@property (weak, nonatomic) IBOutlet UILabel *trailLevelLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *levelProgress;

- (IBAction)didReminderClicked:(id)sender;
- (IBAction)didInviteClicked:(id)sender;
- (IBAction)didMemberClicked:(id)sender;
- (IBAction)didEventClicked:(id)sender;
- (IBAction)didContactClicked:(id)sender;
- (IBAction)didTutorialClicked:(id)sender;

@end
