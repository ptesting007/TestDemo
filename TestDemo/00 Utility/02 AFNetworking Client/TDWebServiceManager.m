//
//  TDWebServiceManager.m
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import "TDWebServiceManager.h"
#import "TDError.h"



@implementation TDWebServiceManager

+ (TDWebServiceManager *)sharedManager
{
    static TDWebServiceManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}


//Post api
- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock
{
    [self POST:requestPath parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (completionBlock) {
            completionBlock (responseObject, nil);
            return ;
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        TDError *customError = [[TDError alloc] initWithError:error];
        if (completionBlock) {
            completionBlock (nil, customError);
        }
    }];
}


//Get api
- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock{
    [self GET:requestPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionBlock) {
            completionBlock (responseObject, nil);
            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TDError *customError = [[TDError alloc] initWithError:error];
        if (completionBlock) {
            completionBlock (nil, customError);
        }
    }];
}

- (void)createPostRequestWithBlocks:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock {
    [self POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:parameters[@"profilePicture"] name:@"profilePicture" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TDError *customError = [TDError validateResponseObject:responseObject];
        
        if (completionBlock) {
            completionBlock (responseObject, customError);
            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        TDError *customError = [TDError validateResponseObject:error];
        if (completionBlock) {
            completionBlock (nil, customError);
        }
    }];
}

//Post api
- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock
{
    [self PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionBlock) {
            completionBlock (responseObject, nil);
            return ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        TDError *customError = [[TDError alloc] initWithError:error];
        if (completionBlock) {
            completionBlock (nil, customError);
        }
    }];
        
        
}
@end
