//
//  TDAccountManager.m
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import "TDAccountManager.h"
#import "TDWebServiceManager.h"

@implementation TDAccountManager

+ (TDAccountManager *)sharedManager
{
    static TDAccountManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:nil] init];
    });
    
    return _sharedManager;
}

- (void)loginWithParameters:(NSDictionary *)params withCompletionHandler:(void (^)(NSDictionary *, TDError *))completionBlock
{
    [[TDWebServiceManager sharedManager] createPostRequestWithParameters:params withRequestPath:LOGIN_USER withCompletionBlock:^(id responseObject, TDError *error) {
        NSDictionary *responseData = (NSDictionary *)responseObject;
        if (completionBlock)
            completionBlock(responseData, error);
    }];
}

- (void)getUserListWithParameters:(NSDictionary *)params withCompletionHandler:(void (^)(NSDictionary *, TDError *))completionBlock
{
    
    
    [[TDWebServiceManager sharedManager] createGetRequestWithParameters:params withRequestPath:LIST_USER withCompletionBlock:^(id responseObject, TDError *error) {
        NSDictionary *responseData = (NSDictionary *)responseObject;
        if (completionBlock)
            completionBlock(responseData, error);
    }];
}


@end
