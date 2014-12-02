//
//  FBConnectViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "FBConnectViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookManager.h"
#import "Utilities.h"
#import "BaseServices.h"
#import <MBProgressHUD.h>

@interface FBConnectViewController ()
@property (nonatomic, strong) FacebookManager *_facebookManager;
@end

@implementation FBConnectViewController

@synthesize _facebookManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil] objectAtIndex:0];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _facebookManager = [FacebookManager sharedManager];
    [_facebookManager awakeFBSession];
    if ([_facebookManager isFBSessionOpen]) {
        NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:objectLogin];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",
                                           [dicUser objectForKey:@"id"]]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSLog(@"image %@",image);
    }
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if (!appDelegate.session.isOpen) {
//        appDelegate.session = [[FBSession alloc] init];
//        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
//            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
//                                                             FBSessionState status,
//                                                             NSError *error) {
//            }];
//        }
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Login Facebook

- (IBAction)dismissViewControllerAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion: nil];
}

- (IBAction)touchLoginFaceBook:(id)sender {
    NSLog(@"fb session 33 login %d",APP_DELEGATE.session.isOpen);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        [Utilities showAlertViewWithTitle:@"" andMessage:@"Are you sure you want to logout?" andDelegate:self];
    }
    else if (appDelegate.session.state != FBSessionStateCreated) {
        appDelegate.session = [[FBSession alloc] init];
    }
    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
    }];
    
//    {
//        if (APP_DELEGATE.session.state != FBSessionStateCreated) {
//            APP_DELEGATE.session = [[FBSession alloc]initWithPermissions:@[@"email",@"user_birthday",@"user_birthday",@"user_birthday",]];
//        }
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
////            [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:objectLogin];
////            [self Loginid:userInfo];
////            [self handleLogin:userInfo];
//        }];
//    }
//    NSLog(@"fb session 44 login %d",APP_DELEGATE.session.isOpen);
        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [_facebookManager logout];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:objectLogin];
        [[UserData currentAccount] clearCached];
    }
}

#pragma mark - Method Login/Logout

-(void)Loginid:(NSDictionary *)user{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[user objectForKey:@"id"]]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSLog(@"image %@",image);
    if (user) {
        [[UserData currentAccount] setStrFacebookToken:[[[_facebookManager getActiveFBSession] accessTokenData] accessToken]];
        [[UserData currentAccount] setStrFacebookId:[user valueForKey:@"id"]];
        [[UserData currentAccount] setStrFullName:[user valueForKey:@"name"]];
        NSDictionary *dicParam = @{@"code":[user valueForKey:@"id"],
                                   @"fullname":[user valueForKey:@"name"],
                                   @"facebookid":[user valueForKey:@"id"],
                                   @"facebook_token":[[[_facebookManager getActiveFBSession] accessTokenData] accessToken],
                                   @"nickname":[user valueForKey:@"name"],
                                   @"mobile":@"",
                                   @"email":[user valueForKey:@"email"],
                                   @"password":@""};
        
        [BaseServices createUserWithParam:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response = %@",responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        
        NSLog(@"Login sucessfuly!");
        
    }else{
        [[UserData currentAccount] clearCached];
    }
}

//-(void)Loginoutfb:(UIBarButtonItem *)sender{
//    if ([_facebookManager isFBSessionOpen] ) {
//        [Utilities showAlertViewWithTitle:@"" andMessage:@"Are you sure you want to logout?" andDelegate:self];
//    }else{
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [_facebookManager loginWithCompletion:^(BOOL success, NSDictionary *userInfo)
//         {
//             [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:objectLogin];
//             [self Loginid:userInfo];
//             [self handleLogin:userInfo];
//         }];
//    }
//    
//}

- (void)handleLogin :(NSDictionary *)user{
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToScale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(250, 250), YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [image drawInRect:CGRectMake(0, 0, 250, 250)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

