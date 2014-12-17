//
//  MyMomentsModel.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 15/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMomentsModel : NSObject

@property (nonatomic,strong) NSMutableArray *messages;
@property (nonatomic,strong) NSCache *avatarCache;

- (void)getMyMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;

- (void)downloadImageSuccess:(NSString *)facebookID success:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure;

//Cache
- (UIImage *)getImageFromCacheWithKey:(NSString *)imageKey;
- (void)setImageToCacheWithImage:(UIImage *)image andKey:(NSString *)imageKey;

@end
