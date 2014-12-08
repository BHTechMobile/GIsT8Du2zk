//
//  MomentsModel.m
//  9HugMoment
//

#import "MomentsModel.h"
#import "MessageObject.h"

@implementation MomentsModel

- (id)init
{
    self = [super init];
    if(self){
        _messages = [NSMutableArray array];
    }
    return self;
}

- (void)getAllMessagesSuccess:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure
{
    [_messages removeAllObjects];
    [BaseServices getAllMessageSussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        NSArray* aaData = [dict customObjectForKey:@"aaData"];
        NSLog(@"%@",aaData);
        for (NSDictionary* mDict in aaData) {
            MessageObject* message = [MessageObject createMessageByDictionnary:mDict];
            [_messages addObject:message];
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSString *bodyString, NSError *error) {
        NSLog(@"%@",bodyString);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)resetMessages:(MessageObject *)message Success:(void (^)(id result))success
             failure:(void (^)(NSError *error))failure
{    
    [BaseServices resetMessage:message Sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [BaseServices getAllMessageSussess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSString *bodyString, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } failure:^(NSString *bodyString, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end