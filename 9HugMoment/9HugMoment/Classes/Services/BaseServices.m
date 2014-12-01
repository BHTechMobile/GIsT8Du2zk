//
//  BaseServices.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "BaseServices.h"

#define TIME_OUT_INTERVAL 10

@implementation BaseServices

+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ws.9hug.com/api/"]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    }
    return manager;
}

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableURLRequest *request = [[BaseServices sharedManager].requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[BaseServices sharedManager].baseURL] absoluteString] parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation =
    [[BaseServices sharedManager] HTTPRequestOperationWithRequest:request
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              
                                                              if (success) {
                                                                  success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                                                              }
                                                              
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              
                                                              NSLog(@"%@",[operation responseString]);
                                                              
                                                              if (error.code == NSURLErrorCancelled) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
                                                              if (error.code == NSURLErrorNotConnectedToInternet) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
                                                              if (error.code == NSURLErrorTimedOut) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
#ifdef APPDEBUG
                                                              [APP_DELEGATE alertView:@"Error" withMessage:@"Somethings was wrong, please contact to Developer" andButton:@"OK"];
#endif
                                                          CALL_FAILURE:
                                                              if (failure) {
                                                                  failure(operation,error);
                                                              }
                                                              
                                                          }];
    [[BaseServices sharedManager].operationQueue addOperation:operation];
    
}

#pragma mark - Login/Logout Services

+ (void)createUserWithParam:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[BaseServices sharedManager] POST:@"user/create" parameters:dicParam
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
                 
             }];
}

#pragma mark - Login

+ (void)createToken:(NSString *)email withPassword:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    NSDictionary* dict;
    dict = @{@"email":email,
             @"password":password
             };
    [[BaseServices sharedManager] POST:@"client/login" parameters:dict
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
             }];
}

#pragma mark - Make QRCode

+ (void)createQRCode:(NSString *)token withType:(NSString *)type success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    NSDictionary* dict;
    dict = @{@"token":token,
             @"type":type
             };
    [[BaseServices sharedManager] POST:@"message/create" parameters:dict
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
             }];
}

#pragma mark - Message Services

+ (void)updateMessage:(NSString*)message
                  key:(NSString*)key
                frame:(NSString*)frame
                 path:(NSURL*)videoPath
         notification:(BOOL)notiF
              sussess:(SuccessBlock)success
              failure:(MessageBlock)failure
{
    NSDictionary* dict;
        dict = @{@"key":key,
                 @"text":message,
                 @"frameid":frame,
                 @"notification":@(notiF)
                 };
    
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:300];
    
    AFHTTPRequestOperation* operator = [[BaseServices sharedManager] POST:@"message/update" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                        {
                                            NSData *videoData = [NSData dataWithContentsOfURL:videoPath];
                                            if (videoData == nil) {
                                                NSError* error = [NSError errorWithDomain:@"DataIsEmpty" code:404 userInfo:nil];
                                                failure(nil,error);
                                                return;
                                            }
                                            
                                            [formData appendPartWithFileData:videoData name:@"attachement1" fileName:@"video.mp4" mimeType:@"video/mp4"];
                                            
                                        } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if (success) {
                                                success(operation,responseObject);
                                            }
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                        {
                                            if (failure) {
                                                failure([operation responseString],error);
                                            }
                                            
                                        }];
    [operator setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}

#pragma mark - Utilities

+(id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}


@end