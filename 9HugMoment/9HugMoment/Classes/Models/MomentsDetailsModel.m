//
//  MomentsDetailsModel.m
//  9HugMoment
//

#import "MomentsDetailsModel.h"
#import "MessageObject.h"

@implementation MomentsDetailsModel

- (id)init
{
    self = [super init];
    if(self){
        _messagesDetails = [NSMutableArray array];
    }
    return self;
}

- (void)getAllDetailSuccess{
    [_messagesDetails removeAllObjects];
    NSDictionary* dict = @{@"id": @"123456789",
                           @"type": @"3",
                           @"text": @"I've been working on lately!"};
    NSArray* detailComment = @[dict,dict,dict,dict,dict,
                               dict,dict,dict,dict,dict,
                               dict,dict,dict,dict,dict,
                               dict,dict,dict,dict,dict];
    NSLog(@"Detail Comment = %@",detailComment);
    for (NSDictionary* mDict in detailComment) {
        MessageObject* message = [MessageObject createMessageByDictionnary:mDict];
        [_messagesDetails addObject:message];
    }
}

- (void)getMessageByKey:(NSString *)keyMessage {
    [BaseServices getMessageByKey:keyMessage sussess:^(AFHTTPRequestOperation *operation, id responseObject){
        [_messagesDetails removeAllObjects];
        _message = [MessageObject createMessageByDictionnary:responseObject];
        if (_delegate && [_delegate respondsToSelector:@selector(didGetMessageDetailSuccess:)]) {
            [_delegate performSelector:@selector(didGetMessageDetailSuccess:) withObject:self];
        }
    }failure:^(NSString *bodyString, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didGetMessageDetailFailed:withError:)]) {
            [_delegate performSelector:@selector(didGetMessageDetailFailed:withError:) withObject:self withObject:error];
        }
    }];
}

- (void)voteMessage {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeVote],
                               KEY_MESSAGE_STRING:@"message",
                               KEY_MEDIA_LINK:@"media link"};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didVoteMessageSuccess:)]) {
            [_delegate performSelector:@selector(didVoteMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didVoteMessageFailed:)]) {
            [_delegate performSelector:@selector(didVoteMessageFailed:) withObject:self];
        }
    }];
}

- (void)commentVoiceMessage:(NSString *)mediaLink {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeVoice],
                               KEY_MESSAGE_STRING:@"",
                               KEY_MEDIA_LINK:mediaLink};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentVoiceMessageSuccess:)]) {
            [_delegate performSelector:@selector(didCommentVoiceMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentVoiceMessageFailed:)]) {
            [_delegate performSelector:@selector(didCommentVoiceMessageFailed:) withObject:self];
        }
    }];
}

- (void)commentPhotoMessage:(NSString *)mediaLink {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypePhoto],
                               KEY_MESSAGE_STRING:@"",
                               KEY_MEDIA_LINK:mediaLink};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentPhotoMessageSuccess:)]) {
            [_delegate performSelector:@selector(didCommentPhotoMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentPhotoMessageFailed:)]) {
            [_delegate performSelector:@selector(didCommentPhotoMessageFailed:) withObject:self];
        }
    }];
}

- (void)commentTextMessage:(NSString *)messageString {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeVote],
                               KEY_MESSAGE_STRING:messageString,
                               KEY_MEDIA_LINK:@""};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentTextMessageSuccess:)]) {
            [_delegate performSelector:@selector(didCommentTextMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentTextMessageFailed:)]) {
            [_delegate performSelector:@selector(didCommentTextMessageFailed:) withObject:self];
        }
    }];
}

@end
