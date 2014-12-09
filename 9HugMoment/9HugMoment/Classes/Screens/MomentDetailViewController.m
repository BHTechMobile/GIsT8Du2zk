//
//  MomentDetailViewController.m
//  9HugMoment
//
//  Created by Tommy on 11/24/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MomentDetailViewController.h"
#import "MomentsModel.h"
#import "CommentHeaderTableViewCell.h"
#import "CommentMessageTableViewCell.h"
#import "UpvoteMessageTableViewCell.h"
#import "MomentsDetailsModel.h"

@interface MomentDetailViewController ()<CommentHeaderTableViewCellDelegate>

@end

@implementation MomentDetailViewController{
    MomentsModel *_momentModel;
    MomentsDetailsModel *_momentsDetailsModel;
    AVAudioPlayer * audioPlayer;
    MessageObject *message;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _momentsDetailsModel = [[MomentsDetailsModel alloc] init];
    [self getAllMessage];
    [self setupRemotePlayerByUrl:_capturePath];
    
    [_contentScrollView addSubview:_playerView];
    CGRect frameExtend = [_extendView frame];
    frameExtend.origin.y = CGRectGetHeight(_playerView.frame);
    [_extendView setFrame:frameExtend];
    CGRect frameScroll = [_contentScrollView frame];
    frameScroll.size.height= CGRectGetHeight(_playerView.frame)+CGRectGetHeight(_extendView.frame);
    [_contentScrollView setFrame:frameScroll];
    [_contentScrollView addSubview:_extendView];
    [_contentScrollView setContentSize:CGSizeMake(320, CGRectGetHeight(_contentScrollView.frame))];

    _usernameLabel.text = _userLabel;
    _voteButton.titleLabel.text = _countVote;
    
    _enterMessageView = [EnterMessageView fromNib];
    _enterMessageView.delegate = self;
    _enterMessageView.center = _playerView.center;
    [self.view addSubview:_enterMessageView];
    _enterMessageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ...

- (void)getAllMessage {
//    [_momentsDetailsModel getAllDetailSuccess:^(id result) {
//        NSLog(@"count : %lu",(unsigned long)_momentsDetailsModel.messagesDetails.count);
//        [_messageContentTableView reloadData];
//    } failure:^(NSError *error) {
//    }];
    [_momentsDetailsModel getAllDetailSuccess];
}

- (NSString *)setFormatDate :(NSDate *)date andFormat:(NSString *)stringFormat{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:stringFormat];
    NSString *sentDate = [_formatter stringFromDate:date];
    return sentDate;
}

-(void)setupRemotePlayerByUrl:(NSURL*)url{
    _videoPlayer = [PlayerView fromNib];
    [_videoPlayer setFrame:CGRectMake(0, 0, _playerView.frame.size.width, _playerView.frame.size.height)];
    [_playerView addSubview:_videoPlayer];
    [_videoPlayer playWithUrl:url];
}

#pragma mark - TableView delegates & datasources

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 30;
    if (indexPath.row == 0){
        return 63;
    }
    else if (indexPath.row == 1){
        return 30;
    }
    else{
        return 60;
    }

    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 + _momentsDetailsModel.messagesDetails.count;
//    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell = nil;
    if (indexPath.row == 0){
        UpvoteMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpvoteMessageTableViewCell"];
        if (cell == nil) {
            cell = [[UpvoteMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpvoteMessageTableViewCell"];
        }
        tableCell = cell;
    }
    else if (indexPath.row == 1){
        CommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentHeaderTableViewCell"];
        if (cell == nil) {
            cell = [[CommentHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentHeaderTableViewCell"];
        }
        [cell setDelegate:self];
        [cell.addCommentButton setTag:indexPath.row];
        tableCell = cell;
    }
    else {
        CommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentMessageTableViewCell"];
        if (cell == nil) {
            cell = [[CommentMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentMessageTableViewCell"];
        }
        message = [_momentsDetailsModel.messagesDetails objectAtIndex:indexPath.row - 2];
        cell.commentTextView.text = message.text;
        tableCell = cell;
    }
    
    return tableCell;
}

#pragma mark - Button Control

- (void)clickedAddComment:(UIButton *)btnAddComment{
//    _messageButton.selected = YES;
    _enterMessageView.hidden = NO;
    [_enterMessageView.textView setText:@""];
    _topPosition.constant = 40.0f;
    [_enterMessageView showUpKeyboard];
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
        
    }];
}

-(void)enterMessageDidCancel
{
    
//    if (![_message isEqualToString:@""]&&_message!=nil) {
////        _messageButton.selected = YES;
//    }
//    else{
////        _messageButton.selected = NO;
//    }
    _enterMessageView.hidden = YES;
    
    _topPosition.constant = -_enterMessageView.height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)enterMessage:(EnterMessageView *)enterMessageController DidEnterMessage:(NSString *)message
{
//    if (![message isEqualToString:@""]&&message!=nil) {
////        _messageButton.selected = YES;
//    }
//    else{
////        _messageButton.selected = NO;
//    }
    _enterMessageView.hidden = YES;
//    _message = message;
    [self enterMessageDidCancel];
}


- (IBAction)momentSegmentControllerAction:(id)sender {
    
}

- (IBAction)addVideoButtonAction:(id)sender {
    
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voteButtonAction:(id)sender {
}
@end
