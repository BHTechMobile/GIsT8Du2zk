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
        appDelegate.session = [[FBSession alloc] init];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                NSLog(@"You are login = %d",appDelegate.session.isOpen);
            }];
            
        }else{
            NSLog(@"You are don't login %d",appDelegate.session.isOpen);
            [self showLoginFB];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    facebookToken = appDelegate.session.accessTokenData.accessToken;
    NSLog(@" facebookToken = %@",appDelegate.session.accessTokenData.accessToken);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button add CaptureVideo

- (IBAction)addCaptureVideoButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"pushCaptureVideoViewController" sender:nil];
}

- (void)showLoginFB {
    fbConnectViewController = (FBConnectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"trending"];
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushCaptureVideoViewController"]) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        captureVideoViewController = [segue destinationViewController];
        captureVideoViewController.userToken = [[UserData currentAccount] strUserToken];
        NSLog(@"userTokennnnnn in Moments %@",[[UserData currentAccount] strUserToken]);
    }
}

@end
