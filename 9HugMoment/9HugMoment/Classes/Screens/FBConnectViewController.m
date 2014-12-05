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
            appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
//            appDelegate.session = [[FBSession alloc] init];
        }
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            [self login];
        }];
    }
}

#pragma mark - Check/Creat account 9Hug

- (void)checkLogin9hug{
    NSDictionary *_dictLogin =@{@"email":[[UserData currentAccount] strFacebookId],
                                @"password":SYSTEM_PASSWORD
                                };
    [BaseServices loginClient9Hug:_dictLogin success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object login %@",responseObject);
        if ([[responseObject objectForKey:@"status" ] isEqualToString:@"1"]) {
            [[UserData currentAccount] setStrUserToken:[responseObject valueForKey:@"token"]];
            NSLog(@"USER TOKEN = %@",[responseObject valueForKey:@"token"]);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion: nil];
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"errorrrr %@",error);
        [self createAccount9hug];
    }];
}

- (void)createAccount9hug{
    NSDictionary *_dictCreate= @{@"fullname":[[UserData currentAccount] strFullName],
                                 @"email":[[UserData currentAccount] strFacebookId],
                                 @"password":SYSTEM_PASSWORD
                                 };
    [BaseServices createAccount9Hug:_dictCreate success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object create %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
    }];
    [self checkLogin9hug];
}
#pragma mark - Check session facebook

- (void)checkSession{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                NSLog(@"appDelegate.session.isOpen = %d",appDelegate.session.isOpen);
            }];
        }
    }
}

#pragma mark - Check status login facebook

- (void)getAvatarFB{
    NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:objectLogin];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",
                                       [dicUser objectForKey:@"id"]]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
}

- (void)login{
    FBRequest *_fbRequest = [FBRequest requestForMe];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [_fbRequest setSession:appDelegate.session];
    [_fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSDictionary *_userInfo = nil;
         if( [result isKindOfClass:[NSDictionary class]] )
         {
             _userInfo = (NSDictionary *)result;
             NSLog(@"_userFB = %@",_userInfo);
             [[NSUserDefaults standardUserDefaults]setObject:_userInfo forKey:objectLogin];
             NSLog(@"_userFB after = %@",_userInfo);
             [self getAvatarFB];
             [self loginid:_userInfo];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [FBSession setActiveSession:appDelegate.session];
             [self checkLogin9hug];
         }
     }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if (appDelegate.session.isOpen) {
            [appDelegate.session closeAndClearTokenInformation];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:objectLogin];
            [[UserData currentAccount] clearCached];
        }
    }
}

#pragma mark - Method Login/Logout

-(void)loginid:(NSDictionary *)user{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[user objectForKey:@"id"]]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSLog(@"image 1 %@",image);
    if (user) {
        [[UserData currentAccount] setStrFacebookToken:appDelegate.session.accessTokenData.accessToken];
        [[UserData currentAccount] setStrFacebookId:[user valueForKey:@"id"]];
        [[UserData currentAccount] setStrFullName:[user valueForKey:@"name"]];
        
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
    [self checkLogin9hug];
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

