//
//  MomentsViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *addCaptureVideoButton;
- (IBAction)addCaptureVideoButtonAction:(id)sender;
- (void)showLoginFB;
@end
