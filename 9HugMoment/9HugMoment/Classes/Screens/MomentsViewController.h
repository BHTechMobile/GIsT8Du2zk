//
//  MomentsViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MomentsMessageTableViewCell.h"
#import "MessageObject.h"

@interface MomentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MomentsMessageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addCaptureVideoButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

- (IBAction)addCaptureVideoButtonAction:(id)sender;
- (void)showLoginFB;

@end
