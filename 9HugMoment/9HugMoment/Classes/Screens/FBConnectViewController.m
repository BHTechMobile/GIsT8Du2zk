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
    [self checkSession];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Login Facebook

- (IBAction)touchLoginFaceBook:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        [Utilities showAlertViewWithTitle:@"" andMessage:@"Are you sure you want to logout?" andDelegate:self];
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            appDelegate.session = [[FBSession alloc] init];
        }
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            [self login];
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)checkSession{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                NSLog(@"appDelegate.session.isOpen = %d",appDelegate.session.isOpen);
            }];
        }
    }
}

- (void)getAvatarFB{
    NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:objectLogin];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",
                                       [dicUser objectForKey:@"id"]]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSLog(@"image 2 %@",image);
}

- (void)login{
    FBRequest *_fbRequest = [FBRequest requestForMe];
    [_fbRequest setSession:APP_DELEGATE.session];
    [_fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSDictionary *_userInfo = nil;
         if( [result isKindOfClass:[NSDictionary class]] )
         {
             _userInfo = (NSDictionary *)result;
             NSLog(@"_userFB = %@",_userInfo);
             [[NSUserDefaults standardUserDefaults]setObject:_userInfo forKey:objectLogin];
             [self getAvatarFB];
             [self Loginid:_userInfo];
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
//        [_facebookManager logout];
//        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:objectLogin];
//        [[UserData currentAccount] clearCached];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if (appDelegate.session.isOpen) {
            [appDelegate.session closeAndClearTokenInformation];
        }
    }
}

#pragma mark - Method Login/Logout

-(void)Loginid:(NSDictionary *)user{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[user objectForKey:@"id"]]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSLog(@"image 1 %@",image);
    if (user) {
        
//        [[UserData currentAccount] setStrFacebookToken:[[[_facebookManager getActiveFBSession] accessTokenData] accessToken]];
//        [[UserData currentAccount] setStrFacebookToken:[[[FBSession activeSession] accessTokenData] accessToken]];
        [[UserData currentAccount] setStrFacebookToken:appDelegate.session.accessTokenData.accessToken];
        [[UserData currentAccount] setStrFacebookId:[user valueForKey:@"id"]];
        [[UserData currentAccount] setStrFullName:[user valueForKey:@"name"]];
//        NSDictionary *dicParam = @{@"code":[user valueForKey:@"id"],
//                                   @"fullname":[user valueForKey:@"name"],
//                                   @"facebookid":[user valueForKey:@"id"]
//                                   };
        
        NSDictionary *dicParam = @{@"code":[user valueForKey:@"id"],
                                   @"fullname":[user valueForKey:@"name"],
                                   @"facebookid":[user valueForKey:@"id"] ,
                                   @"facebook_token":appDelegate.session.accessTokenData.accessToken,
                                   @"nickname":[user valueForKey:@"name"]
                                   };
        
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

