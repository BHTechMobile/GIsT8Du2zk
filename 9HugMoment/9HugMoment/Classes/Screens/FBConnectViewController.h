//
//  FBConnectViewController.h
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBSession.h>
#import "UserData.h"

@interface FBConnectViewController : UIViewController<FBLoginViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
- (IBAction)dismissViewControllerAction:(id)sender;
- (IBAction)touchLoginFaceBook:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dismissViewController;
@property (weak, nonatomic) IBOutlet UIImageView *imageChange;

@end