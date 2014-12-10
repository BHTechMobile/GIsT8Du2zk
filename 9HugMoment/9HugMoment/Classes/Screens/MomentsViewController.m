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
#import "ODRefreshControl.h"

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
    ODRefreshControl *_refreshControl;
    MBProgressHUD *_hud;
}
@synthesize _facebookManager;

#pragma mark - MomentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentModel = [[MomentsModel alloc] init];
    _downloadVideoView = [DownloadVideoView fromNib];
    CGRect downloadVideoFrame = self.view.frame;
    downloadVideoFrame.origin.y = self.messagesTableView.frame.origin.y;
    downloadVideoFrame.size.height = downloadVideoFrame.size.height - self.messagesTableView.frame.origin.y;
    _downloadVideoView.frame = downloadVideoFrame;
    _downloadVideoView.alpha = 0.0;
    _downloadVideoView.delegate = self;
    [self.view addSubview:_downloadVideoView];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.userInteractionEnabled = NO;
    _hud.labelText = NSLocalizedString(@"Loading...", nil);
    _hud.labelFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.messagesTableView];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    if (!APP_DELEGATE.session.isOpen) {
        APP_DELEGATE.session = [[FBSession alloc] initWithPermissions:@[@"publish_actions",@"public_profile", @"user_friends",@"read_friendlists"]];
        if (APP_DELEGATE.session.state == FBSessionStateCreatedTokenLoaded) {
            [APP_DELEGATE.session openWithCompletionHandler:^(FBSession *session,
                                                              FBSessionState status,
                                                              NSError *error) {
                [FBSession setActiveSession:session];
                APP_DELEGATE.session = session;
                [self getAllMessage];
            }];
        }else{
            [self showLoginFB];
        }
    }
    
    CGRect frameExtend2 = [_newsMomentButton frame];
    frameExtend2.origin.y = WIDTH_BUTTON_NEW_MOMENTS;
    frameExtend2.origin.x = CGRectGetWidth(self.view.frame)/3;
    frameExtend2.size.width = CGRectGetWidth(self.view.frame)/3;
    frameExtend2.size.height = HIGHT_BUTTON_NEW_MOMENTS;
    
    _newsMomentButton = [[UIButton alloc] initWithFrame:frameExtend2];
    [_newsMomentButton setBackgroundColor:[UIColor lightGrayColor]];
    _newsMomentButton.layer.cornerRadius = CORNER_RADIUS;
    
    [_newsMomentButton setTitle:TITLE_BUTTON_NEW_MOMENTS forState:UIControlStateNormal];
    [_newsMomentButton.titleLabel setFont:[UIFont systemFontOfSize:TITLE_BUTTON_NEW_MOMENTS_FONT_SIZE]];
    [_newsMomentButton addTarget:self action:@selector(callPullDownRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_newsMomentButton];
    
    self.newsMomentButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNSNotifications:)
                                                 name:CALL_PUSH_NOTIFICATIONS object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)pushNSNotifications:(NSNotification*)notify{
    self.newsMomentButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)addCaptureVideoButtonAction:(id)sender {
    [self performSegueWithIdentifier:PUSH_CAPTURE_VIDEOVIEWCONTROLLER sender:nil];
}

- (IBAction)refreshButtonAction:(id)sender {
    [self getAllMessage];
}

#pragma mark - Custom Methods

- (void)showLoginFB {
    fbConnectViewController = (FBConnectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:PRESENT_TRENDING];
    fbConnectViewController.delegate = self;
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}

- (void)getAllMessage {
    _newsMomentButton.hidden = YES;
    [_hud show:YES];
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"count : %lu",(unsigned long)_momentModel.messages.count);
        [_messagesTableView reloadData];
        [_hud hide:YES];
    } failure:^(NSError *error) {
        [_hud hide:YES];
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:PUSH_CAPTURE_VIDEOVIEWCONTROLLER]) {
        captureVideoViewController = [segue destinationViewController];
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

#pragma mark - Button New moment

-(void)callPullDownRequest:(UIButton *)btn{
    [self getAllMessage];
}

#pragma mark - DownloadVideo delegate
- (void)downloadVideoSuccess:(MessageObject *)messageObject {
    messageObject.downloaded = YES;
    [_downloadVideoView hideWithAnimation];
    //TODO: Go to detail message
    [self performSegueWithIdentifier:@"pushMomentDetailsView" sender:nil];
}

- (void)downloadVideoFailure:(MessageObject *)messageObject  {
    [_downloadVideoView hideWithAnimation];
    [UIAlertView showTitle:@"Error" message:@"Cann't download this video"];
}

#pragma mark - Refresh control management

- (void)refreshTableView {
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"Message found: %lu",(unsigned long)_momentModel.messages.count);
        [self refreshTableViewDone];
    } failure:^(NSError *error) {
        [self refreshTableViewDone];
    }];
    _newsMomentButton.hidden = YES;
}

- (void)refreshTableViewDone {
    [_refreshControl endRefreshing];
    [_messagesTableView reloadData];
}

#pragma mark - FBConnectViewController Delegate

-(void)fbConnectViewController:(FBConnectViewController *)vc didConnectFacebookSuccess:(id)response{
    [self getAllMessage];
}

@end
