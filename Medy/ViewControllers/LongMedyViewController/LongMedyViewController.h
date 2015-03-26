//
//  LongMedyViewController.h
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongMedyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLbl;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *medyBtn;

- (IBAction)didMedyClicked:(id)sender;

@end
