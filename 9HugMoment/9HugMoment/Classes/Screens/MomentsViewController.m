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
#import "ArrayDataSource.h"

static NSString * const MomentViewCellIdentifier = @"MomentViewCellIdentifier";

@interface MomentsViewController ()
@property (nonatomic, strong) FacebookManager *_facebookManager;
@property (nonatomic, strong) ArrayDataSource *arrayDataSource;
@end

@implementation MomentsViewController{
    CaptureVideoViewController *captureVideoViewController;
    FBConnectViewController *fbConnectViewController;
    MomentsModel *_momentModel;
    DownloadVideoView *_downloadVideoView;
    MomentDetailViewController *momentDetailViewController;
    MessageObject *message;
    ODRefreshControl *_refreshControl;
    MBProgressHUD *_hud;
    NSCache *_avatarCache;
}
@synthesize _facebookManager;

#pragma mark - MomentsViewController management

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentModel = [[MomentsModel alloc] init];
    _avatarCache = [[NSCache alloc] init];
    
    _downloadVideoView = [DownloadVideoView downloadVideoViewWithDelegate:self];
    [self.view addSubview:_downloadVideoView];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
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
    [[FBSession activeSession] closeAndClearTokenInformation];
    [APP_DELEGATE.session closeAndClearTokenInformation];
    [[UserData currentAccount] clearCached];
    [self showLoginFB];
}

#pragma mark - Custom Methods

- (void)showLoginFB {
    fbConnectViewController = (FBConnectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:PRESENT_TRENDING];
    fbConnectViewController.delegate = self;
    fbConnectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:fbConnectViewController animated:YES completion:nil];
}

- (void)setupTable{
    for (int i=0; i<_momentModel.messages.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self setupTableView:indexPath];
    }
}

- (void)getAllMessage {
    _newsMomentButton.hidden = YES;
    [_hud show:YES];
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"count : %lu",(unsigned long)_momentModel.messages.count);
        [_messagesTableView reloadData];
        [self setupTable];
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
        momentDetailViewController.messageObject = message;
        momentDetailViewController.hidesBottomBarWhenPushed = YES;
        NSLog(@"message.localVideoPath %@",message.localVideoPath);
        NSLog(@"momentDetailViewController.capture %@",momentDetailViewController.capturePath);
    }
}

#pragma mark - TableView delegates & datasources

- (void)setupTableView:(NSIndexPath *)indexPath{
    TableViewCellConfigureBlock configureCell = ^(MomentsMessageTableViewCell *momentsMessageTableViewCell, MessageObject *myMessage){
        [momentsMessageTableViewCell setMessageWithMessage:myMessage];
    };
    _arrayDataSource = [[ArrayDataSource alloc]initWithItems:_momentModel.messages
                                              cellIdentifier:MomentViewCellIdentifier
                                          configureCellBlock:configureCell];
    
    self.messagesTableView.dataSource = self.arrayDataSource;
    [self.messagesTableView registerClass:[MomentsMessageTableViewCell class] forCellReuseIdentifier:MomentViewCellIdentifier];
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
