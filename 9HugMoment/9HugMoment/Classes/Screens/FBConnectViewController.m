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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _facebookManager = [FacebookManager sharedManager];
    [_facebookManager awakeFBSession];
    if ([_facebookManager isFBSessionOpen]) {
        NSDictionary *dicUser = [[NSUserDefaults standardUserDefaults] objectForKey:objectLogin];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",
                                           [dicUser objectForKey:@"id"]]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSLog(@"image %@",image);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Login Facebook

- (IBAction)touchLoginFaceBook:(id)sender {
    if ([_facebookManager isFBSessionOpen] ) {
        [Utilities showAlertViewWithTitle:@"" andMessage:@"Are you sure you want to logout?" andDelegate:self];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_facebookManager loginWithCompletion:^(BOOL success, NSDictionary *userInfo)
         {
             
             [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:objectLogin];
             [self Loginid:userInfo];
             [self handleLogin:userInfo];
             
         }];
    }
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
    //change icon
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[user objectForKey:@"id"]]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    if (user) {
        
        [[UserData currentAccount] setStrFacebookToken:[[[_facebookManager getActiveFBSession] accessTokenData] accessToken]];
        [[UserData currentAccount] setStrFacebookId:[user valueForKey:@"id"]];
        [[UserData currentAccount] setStrFullName:[user valueForKey:@"name"]];
        NSDictionary *dicParam = @{@"code":[user valueForKey:@"id"],@"fullname":[user valueForKey:@"name"],@"facebookid":[user valueForKey:@"id"],@"facebook_token":[[[_facebookManager getActiveFBSession] accessTokenData] accessToken],@"nickname":[user valueForKey:@"name"],@"mobile":@"",@"email":[user valueForKey:@"email"],@"password":@""};
        
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

-(void)Loginoutfb:(UIBarButtonItem *)sender{
    if ([_facebookManager isFBSessionOpen] ) {
        [Utilities showAlertViewWithTitle:@"" andMessage:@"Are you sure you want to logout?" andDelegate:self];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_facebookManager loginWithCompletion:^(BOOL success, NSDictionary *userInfo)
         {
             
             [[NSUserDefaults standardUserDefaults]setObject:userInfo forKey:objectLogin];
             [self Loginid:userInfo];
             [self handleLogin:userInfo];
         }];
    }
    
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

