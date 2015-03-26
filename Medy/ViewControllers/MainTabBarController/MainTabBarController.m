//
//  MainTabBarController.m
//  Medy
//
//  Created by Khoo Leen on 04/12/14.
//  Copyright (c) 2014 Khoo Leen. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()
{
    BOOL isMedyStarted;
    NSTimer *medyTimer;
    NSDate *medyStartTime;
    NSDateFormatter *dateFormatter;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }];
    
    CGRect viewFrame=self.tabBar.frame;
    viewFrame.size.height += 10;
    self.tabBar.frame=viewFrame;
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

@end
