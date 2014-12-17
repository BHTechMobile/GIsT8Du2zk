//
//  MyMomentsViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MyMomentsViewController.h"
#import "CaptureVideoViewController.h"
#import "FBConnectViewController.h"
#import "MomentsModel.h"
#import "MomentDetailViewController.h"
#import "ODRefreshControl.h"
#import "MyMomentsModel.h"
#import "ArrayDataSource.h"
#define kYouTitle @"My Moments"

static NSString * const MomentViewCellIdentifier = @"MomentViewCellIdentifier";

@interface MyMomentsViewController ()

@property (nonatomic, strong) FacebookManager *_facebookManager;
@property (nonatomic, strong) ArrayDataSource *arrayDataSource;

@end

@implementation MyMomentsViewController{
    CaptureVideoViewController *captureVideoViewController;
    FBConnectViewController *fbConnectViewController;
    MomentsModel *_momentModel;
    MyMomentsModel *_myMomentModel;
    DownloadVideoView *_downloadVideoView;
    MomentDetailViewController *momentDetailViewController;
    MessageObject *message;
    ODRefreshControl *_refreshControl;
    MBProgressHUD *_hud;
    NSCache *_avatarCache;
    NSMutableArray *personArray;
}
@synthesize _facebookManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = kYouTitle;
    _myMomentModel = [[MyMomentsModel alloc] init];
    _avatarCache = [[NSCache alloc] init];
    _downloadVideoView = [DownloadVideoView fromNib];
    CGRect downloadVideoFrame = self.view.frame;
    downloadVideoFrame.origin.y = self.myMessagesTableView.frame.origin.y;
    downloadVideoFrame.size.height = downloadVideoFrame.size.height - self.myMessagesTableView.frame.origin.y;
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
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myMessagesTableView];
    [_refreshControl addTarget:self action:@selector(refreshTableVieww) forControlEvents:UIControlEventValueChanged];

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
    
    [self refreshTableVieww];
//    NSMutableArray *personArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushNSNotifications:(NSNotification*)notify{
    self.newsMomentButton.hidden = NO;
}

#pragma mark - Custom Methods

//- (void)setupTable{
//    NSLog(@"_myMomentModel.messages == %lu",(unsigned long)_myMomentModel.messages.count);
//    for (int i=0; i<_myMomentModel.messages.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [self setupTableView:indexPath];
//    }
//}

- (void)getAllMessage {
    _newsMomentButton.hidden = YES;
    [_hud show:YES];
    [_momentModel getAllMessagesSuccess:^(id result) {
        NSLog(@"count : %lu",(unsigned long)_myMomentModel.messages.count);
        [_myMessagesTableView reloadData];
        [_hud hide:YES];
    } failure:^(NSError *error) {
        [_hud hide:YES];
    }];
}

#pragma mark - TableView delegates & datasources

//- (void)setupTableView:(NSIndexPath *)indexPath{
//    TableViewCellConfigureBlock configureCell = ^(MomentsMessageTableViewCell *momentsMessageTableViewCell, MyMomentsModel *myMomentsModel){
//        MessageObject *mymessage = (MessageObject *)[myMomentsModel.messages objectAtIndex:indexPath.row];
//        [momentsMessageTableViewCell setMessageWithMessage:mymessage];
//        UIImage *userAvatar = [_avatarCache objectForKey:mymessage.userFacebookID];
//        if (!userAvatar) {
//            [BaseServices downloadUserImageWithFacebookID:mymessage.userFacebookID
//                                                  success:^(AFHTTPRequestOperation *operation, id responseObject){
//                momentsMessageTableViewCell.thumbnailImageView.image = responseObject;
//                [_avatarCache setObject:responseObject forKey:mymessage.userFacebookID];
//            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//                NSLog(@"Error get user image from facebook: %@",error);
// }];
//        }else {
//            momentsMessageTableViewCell.thumbnailImageView.image = userAvatar;
//        }
//    };
//    [personArray addObject:[_myMomentModel.messages objectAtIndex:indexPath.row]];
//    _arrayDataSource = [[ArrayDataSource alloc]initWithItems:personArray
//                                              cellIdentifier:MomentViewCellIdentifier
//                                          configureCellBlock:configureCell];
//    
//    self.myMessagesTableView.dataSource = self.arrayDataSource;
//    [self.myMessagesTableView registerClass:[MomentsMessageTableViewCell class] forCellReuseIdentifier:MomentViewCellIdentifier];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_ROW_TABLE_VIEW_MOMENTS_VIEW_CONTROLLER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myMomentModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentsMessageTableViewCell *cell = (MomentsMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER_MOMENTS_MESSAGE_TABLE_VIEW_CELL];
    if (!cell) {
        cell = [[MomentsMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER_MOMENTS_MESSAGE_TABLE_VIEW_CELL];
    }
    MessageObject *mymessage = (MessageObject *)[_myMomentModel.messages objectAtIndex:indexPath.row];
    [cell setMessageWithMessage:mymessage];
    UIImage *userAvatar = [_avatarCache objectForKey:mymessage.userFacebookID];
    if (!userAvatar) {
        [BaseServices downloadUserImageWithFacebookID:mymessage.userFacebookID success:^(AFHTTPRequestOperation *operation, id responseObject){
            cell.thumbnailImageView.image = responseObject;
            [_avatarCache setObject:responseObject forKey:mymessage.userFacebookID];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error get user image from facebook: %@",error);
        }];
    }else {
        cell.thumbnailImageView.image = userAvatar;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    message = [_myMomentModel.messages objectAtIndex:indexPath.row];
    if (!message.downloaded && message.localVideoPath) {
        _downloadVideoView.alpha = 1;
        [_downloadVideoView showWithAnimation];
        [_downloadVideoView downloadVideoByMessage:message];
    }else {
        //TODO: Go to detail message
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Trending" bundle: nil];
        MomentDetailViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"momentDetailsTrending"];
        lvc.capturePath = [NSURL fileURLWithPath:message.localVideoPath];
        lvc.messageObject = message;
        lvc.hidesBottomBarWhenPushed = YES;
        NSLog(@"message.localVideoPath %@",message.localVideoPath);
        NSLog(@"momentDetailViewController.capture %@",momentDetailViewController.capturePath);

        [self.navigationController pushViewController:lvc animated:YES];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Trending" bundle: nil];
    MomentDetailViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"momentDetailsTrending"];
    lvc.capturePath = [NSURL fileURLWithPath:message.localVideoPath];
    lvc.messageObject = message;
    lvc.hidesBottomBarWhenPushed = YES;
    NSLog(@"message.localVideoPath %@",message.localVideoPath);
    NSLog(@"momentDetailViewController.capture %@",momentDetailViewController.capturePath);

    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)downloadVideoFailure:(MessageObject *)messageObject  {
    [_downloadVideoView hideWithAnimation];
    [UIAlertView showTitle:@"Error" message:@"Cann't download this video"];
}

#pragma mark - Refresh control management

- (void)refreshTableVieww {
    [_myMomentModel getMyMessagesSuccess:^(id result) {
        NSLog(@"Message found: %lu",(unsigned long)_myMomentModel.messages.count);
        [self refreshTableViewDone];
    } failure:^(NSError *error) {
        [self refreshTableViewDone];
    }];
    _newsMomentButton.hidden = YES;
}

- (void)refreshTableViewDone {
    [_refreshControl endRefreshing];
    [_myMessagesTableView reloadData];
//    [self setupTable];
}

@end
