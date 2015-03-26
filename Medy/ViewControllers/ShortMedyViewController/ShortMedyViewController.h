//
//  ShortMedyViewController.h
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILTranslucentView.h"

@interface ShortMedyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLbl;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *medyBtn;
@property (weak, nonatomic) IBOutlet UIButton *circleBtn;
@property (weak, nonatomic) IBOutlet UIButton *clockBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (weak, nonatomic) IBOutlet UIView *medyInfoView;
@property (weak, nonatomic) IBOutlet UIView *totalMedyInfoView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *headLevelLbl;
@property (weak, nonatomic) IBOutlet UILabel *trailLevelLbl;
@property (weak, nonatomic) IBOutlet UIProgressView *levelProgress;
@property (weak, nonatomic) IBOutlet ILTranslucentView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *playMedyBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseMedyBtn;

- (IBAction)didMedyTouchDown:(id)sender;
- (IBAction)didMedyTouchUp:(id)sender;
- (IBAction)didCircleClick:(id)sender;
- (IBAction)didClockClick:(id)sender;
- (IBAction)didSettingsClick:(id)sender;
- (IBAction)didVolumeChange:(id)sender;
- (IBAction)didMedyTouchOutside:(id)sender;
- (IBAction)didPlaymedyTap:(id)sender;
- (IBAction)didPausemedyTap:(id)sender;

@end
