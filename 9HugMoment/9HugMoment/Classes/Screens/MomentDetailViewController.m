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
#import "PlayerViewTableViewCell.h"
#import "UserInfoTableViewCell.h"

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
    [_momentsDetailsModel getAllDetailSuccess];
    
    _enterMessageView = [EnterMessageView fromNib];
    _enterMessageView.delegate = self;
    _enterMessageView.center = _playerView.center;
    [self.view addSubview:_enterMessageView];
    _enterMessageView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Methods

- (NSString *)setFormatDate :(NSDate *)date andFormat:(NSString *)stringFormat{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:stringFormat];
    NSString *sentDate = [_formatter stringFromDate:date];
    return sentDate;
}

-(void)setupRemotePlayerByUrl:(NSURL*)url{
//    _videoPlayer = [PlayerView fromNib];
//    [_videoPlayer setFrame:CGRectMake(0, 0, _playerView.frame.size.width, _playerView.frame.size.height)];
//    [_playerView addSubview:_videoPlayer];
//    [_videoPlayer playWithUrl:url];
}

#pragma mark - TableView delegates & datasources

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = HEIGHT_ROW_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER;
    if (indexPath.row == ROW_IN_SECTION){
        return _messageContentTableView.frame.size.width;
    }
    else if (indexPath.row == ROW_IN_SECTION_){
        return HEIGHT_ROW_1_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER;
    }
    else if (indexPath.row == ROW_IN_SECTION__){
        return HEIGHT_ROW_2_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER;
    }
    else if (indexPath.row == ROW_IN_SECTION___){
        return HEIGHT_ROW_3_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER;
    }
    else{
        return HEIGHT_ROW_4_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER;
    }

    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_ROW_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER + _momentsDetailsModel.messagesDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell = nil;
    if (indexPath.row == ROW_IN_SECTION){
        PlayerViewTableViewCell *playerCell = [tableView dequeueReusableCellWithIdentifier:PLAYER_VIEW_CELL_INDETIFIER];
        if (playerCell == nil) {
            playerCell = [[PlayerViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PLAYER_VIEW_CELL_INDETIFIER];
        }
        
        _videoPlayer = [PlayerView fromNib];
        [_videoPlayer setFrame:CGRectMake(0, 0, _messageContentTableView.frame.size.width, _messageContentTableView.frame.size.width)];
        [playerCell.playerViewCell addSubview:_videoPlayer];
        [_videoPlayer playWithUrl:_capturePath];
        
        tableCell = playerCell;
    }
    else if (indexPath.row == ROW_IN_SECTION_){
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_VIEW_CELL_INDETIFIER];
        if (cell == nil) {
            cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_VIEW_CELL_INDETIFIER];
        }
        cell.usernameLabel.text = _userLabel;
        cell.voteButton.titleLabel.text = _countVote;
        tableCell = cell;
    }
    else if (indexPath.row == ROW_IN_SECTION__){
        UpvoteMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UPVOTE_VIEW_CELL_INDETIFIER];
        if (cell == nil) {
            cell = [[UpvoteMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UPVOTE_VIEW_CELL_INDETIFIER];
        }
        tableCell = cell;
    }
    else if (indexPath.row == ROW_IN_SECTION___){
        CommentHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_VIEW_CELL_INDETIFIER];
        if (cell == nil) {
            cell = [[CommentHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COMMENT_VIEW_CELL_INDETIFIER];
        }
        [cell setDelegate:self];
        [cell.addCommentButton setTag:indexPath.row];
        tableCell = cell;
    }
    else {
        CommentMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:COMMENT_MESSAGE_VIEW_CELL_INDETIFIER];
        if (cell == nil) {
            cell = [[CommentMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COMMENT_MESSAGE_VIEW_CELL_INDETIFIER];
        }
        message = [_momentsDetailsModel.messagesDetails objectAtIndex:indexPath.row - NUMBER_OF_ROW_TABLE_VIEW_MOMENTS_DETAILS_VIEW_CONTROLLER];
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
    
    CGRect frameExtend2 = [_enterMessageView frame];
    frameExtend2.origin.y = 100;
    frameExtend2.origin.x = _messageContentTableView.centerX;
    [_enterMessageView setFrame:frameExtend2];
    
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

#pragma mark - MomentsDetailsModel delegate

- (void)didGetMessageDetailSuccess:(MomentsDetailsModel *)momentsDetailsModel
{
    //TODO: Update Data
    [_messageContentTableView reloadData];
}
- (void)didGetMessageDetailFailed:(MomentsDetailsModel *)momentsDetailsModel withError:(NSError *)error
{
    //TODO: Get data failed
}

@end
