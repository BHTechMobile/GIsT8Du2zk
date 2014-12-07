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
#import "MomentsModel.h"

@interface MomentsViewController ()
@property (nonatomic, strong) FacebookManager *_facebookManager;
@end

@implementation MomentsViewController{
    CaptureVideoViewController *captureVideoViewController;
    FBConnectViewController *fbConnectViewController;
    NSString *facebookToken;
    MomentsModel *_momentModel;
}
@synthesize _facebookManager;

#pragma mark - MomentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentModel = [[MomentsModel alloc] init];
    [self getAllMessage];
    
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

#pragma mark - Actions

- (IBAction)addCaptureVideoButtonAction:(id)sender {
    [self performSegueWithIdentifier:PUSH_CAPTURE_VIDEOVIEWCONTROLLER sender:nil];
}

#pragma mark - Custom Methods

- (void)showLoginFB {
    fbConnectViewController = (FBConnectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:PRESENT_TRENDING];
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}

- (void)getAllMessage {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"count : %lu",(unsigned long)_momentModel.messages.count);
        [_messagesTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:PUSH_CAPTURE_VIDEOVIEWCONTROLLER]) {
        captureVideoViewController = [segue destinationViewController];
        captureVideoViewController.userToken = [[UserData currentAccount] strUserToken];
    }
}

#pragma mark - TableView delegates & datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTION_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_ROW_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _momentModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentsMessageTableViewCell *cell = (MomentsMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MOMENTS_MESSAGE_TABLE_VIEW_CELL];
    if (!cell) {
        cell = [[MomentsMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_MOMENTS_MESSAGE_TABLE_VIEW_CELL];
    }
    cell.delegate = self;
    MessageObject *message = (MessageObject *)[_momentModel.messages objectAtIndex:indexPath.row];
    [cell setMessageWithMessage:message];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageObject *message = [_momentModel.messages objectAtIndex:indexPath.row];
    //TODO: Go to detail message
}

#pragma mark - MomentsMessageTableViewCell delegate 

- (void)resetMessageAtCell:(MomentsMessageTableViewCell *)messageCell
{
    MomentsMessageTableViewCell *currentCell = messageCell;
    NSIndexPath *indexPath = [_messagesTableView indexPathForCell:currentCell];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MessageObject *currentMessage = [_momentModel.messages objectAtIndex:indexPath.row];
    [_momentModel resetMessages:currentMessage Success:^(id result) {
        [_messagesTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
