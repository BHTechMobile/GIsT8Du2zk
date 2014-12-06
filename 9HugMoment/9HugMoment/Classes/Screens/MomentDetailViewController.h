//
//  MomentDetailViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *momentSegmentController;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addVideoButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (IBAction)addVideoButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)momentSegmentControllerAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *extendView;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@end
