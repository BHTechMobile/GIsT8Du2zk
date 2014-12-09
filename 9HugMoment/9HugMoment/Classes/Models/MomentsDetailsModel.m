//
//  MomentsDetailsModel.m
//  9HugMoment
//
//  Created by PhamHuuPhuong on 8/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
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

@end
