//
//  MomentDetailViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MomentDetailViewController.h"

@interface MomentDetailViewController ()

@end

@implementation MomentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_contentScrollView addSubview:_playerView];
    CGRect frameExtend = [_extendView frame];
    frameExtend.origin.y = CGRectGetHeight(_playerView.frame);
    [_extendView setFrame:frameExtend];
    CGRect frameScroll = [_contentScrollView frame];
    frameScroll.size.height= CGRectGetHeight(_playerView.frame)+CGRectGetHeight(_extendView.frame);
    [_contentScrollView setFrame:frameScroll];
    [_contentScrollView addSubview:_extendView];
    [_contentScrollView setContentSize:CGSizeMake(320, CGRectGetHeight(_contentScrollView.frame)+ (IS_IPHONE_5 ? 330:400))];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Control

- (IBAction)momentSegmentControllerAction:(id)sender {
    
}

- (IBAction)addVideoButtonAction:(id)sender {
    
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
