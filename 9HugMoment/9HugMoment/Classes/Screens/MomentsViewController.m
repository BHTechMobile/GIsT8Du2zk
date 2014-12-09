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
#import "MomentDetailViewController.h"

@interface MomentsViewController ()
@property (nonatomic, strong) FacebookManager *_facebookManager;
@end

@implementation MomentsViewController{
    CaptureVideoViewController *captureVideoViewController;
    FBConnectViewController *fbConnectViewController;
//    NSString *facebookToken;
    MomentsModel *_momentModel;
    DownloadVideoView *_downloadVideoView;
    MomentDetailViewController *momentDetailViewController;
    MessageObject *message;
}
@synthesize _facebookManager;

#pragma mark - MomentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentModel = [[MomentsModel alloc] init];
    [self getAllMessage];
    _downloadVideoView = [DownloadVideoView fromNib];
    CGRect downloadVideoFrame = self.view.frame;
    downloadVideoFrame.origin.y = self.messagesTableView.frame.origin.y;
    downloadVideoFrame.size.height = downloadVideoFrame.size.height - self.messagesTableView.frame.origin.y;
    _downloadVideoView.frame = downloadVideoFrame;
    _downloadVideoView.alpha = 0.0;
    _downloadVideoView.delegate = self;
    [self.view addSubview:_downloadVideoView];
    
    if (!APP_DELEGATE.session.isOpen) {
        APP_DELEGATE.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
        if (APP_DELEGATE.session.state == FBSessionStateCreatedTokenLoaded) {
            [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session,
                                                              FBSessionState status,
                                                              NSError *error) {
                [FBSession setActiveSession:session];
                APP_DELEGATE.session = session;
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
//        captureVideoViewController.userToken = [[UserData currentAccount] strUserToken];
        captureVideoViewController.userToken = [[UserData currentAccount] strFacebookToken];
    }
    
    if ([[segue identifier] isEqualToString:@"pushMomentDetailsView"]) {
        momentDetailViewController = [segue destinationViewController];
        momentDetailViewController.capturePath = [NSURL fileURLWithPath:message.localVideoPath];
        momentDetailViewController.userLabel = message.fullName;
        momentDetailViewController.countVote = (![message.reads isEqualToString:@""])?message.reads:@"0";
        momentDetailViewController.hidesBottomBarWhenPushed = YES;
        NSLog(@"message.localVideoPath %@",message.localVideoPath);
        NSLog(@"momentDetailViewController.capture %@",momentDetailViewController.capturePath);
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
    MessageObject *mymessage = (MessageObject *)[_momentModel.messages objectAtIndex:indexPath.row];
    [cell setMessageWithMessage:mymessage];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    message = [_momentModel.messages objectAtIndex:indexPath.row];
    if (!message.downloaded && message.localVideoPath) {
        _downloadVideoView.alpha = 1;
        [_downloadVideoView showWithAnimation];
        [_downloadVideoView downloadVideoByMessage:message];
    }else {
        //TODO: Go to detail message
        [self performSegueWithIdentifier:@"pushMomentDetailsView" sender:nil];
    }
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

#pragma mark - DownloadVideo delegate
- (void)downloadVideoSuccess:(MessageObject *)message {
    message.downloaded = YES;
    [_downloadVideoView hideWithAnimation];
    //TODO: Go to detail message
    [self performSegueWithIdentifier:@"pushMomentDetailsView" sender:nil];
}

- (void)downloadVideoFailure:(MessageObject *)message  {
    [_downloadVideoView hideWithAnimation];
    [UIAlertView showTitle:@"Error" message:@"Cann't download this video"];
}

@end
