//
//  TDWebServiceManager.h
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "TDConfiguration.h"

@class TDError;
@interface TDWebServiceManager : AFHTTPSessionManager

+ (TDWebServiceManager *)sharedManager;

- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock;

- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock;


- (void)createPostRequestWithBlocks:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock;


- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, TDError *error))completionBlock;
@end
