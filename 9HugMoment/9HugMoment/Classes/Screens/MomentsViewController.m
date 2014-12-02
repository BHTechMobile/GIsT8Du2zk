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
}
@synthesize _facebookManager;
#pragma mark - Header Controll

- (void)viewDidLoad {
    [super viewDidLoad];
    _facebookManager = [FacebookManager sharedManager];
    [_facebookManager awakeFBSession];
    if ([_facebookManager isFBSessionOpen]) {
//        NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:objectLogin];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",
//                                           [dicUser objectForKey:@"id"]]];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//        NSLog(@"image %@",image);
        NSLog(@"You are login!");
    }else{
        NSLog(@"You are don't login");
        [self showLoginFB];
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
    [self performSegueWithIdentifier:@"pushCaptureVideoViewController" sender:nil];
}

- (void)showLoginFB {
    fbConnectViewController = (FBConnectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"trending"];
    //menu is only an example
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushCaptureVideoViewController"]) {
        captureVideoViewController = [segue destinationViewController];
    }
}

@end
