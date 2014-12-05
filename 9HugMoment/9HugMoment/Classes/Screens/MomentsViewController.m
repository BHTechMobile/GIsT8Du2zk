//
//  MomentsViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MomentsViewController.h"
#import "CaptureVideoViewController.h"
#import "FBConnectViewController.h"

@interface MomentsViewController ()
@property (nonatomic, strong) FacebookManager *_facebookManager;
@end

@implementation MomentsViewController{
    CaptureVideoViewController *captureVideoViewController;
    FBConnectViewController *fbConnectViewController;
    NSString *facebookToken;
}
@synthesize _facebookManager;
#pragma mark - Header Controll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                [FBSession setActiveSession:appDelegate.session];
            }];
        }else{
            [self showLoginFB];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button add CaptureVideo

- (IBAction)addCaptureVideoButtonAction:(id)sender {
    [self performSegueWithIdentifier:PUSH_CAPTURE_VIDEOVIEWCONTROLLER sender:nil];
}

- (void)showLoginFB {
    fbConnectViewController = (FBConnectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:PRESENT_TRENDING];
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:PUSH_CAPTURE_VIDEOVIEWCONTROLLER]) {
        captureVideoViewController = [segue destinationViewController];
        captureVideoViewController.userToken = [[UserData currentAccount] strUserToken];
    }
}

@end
