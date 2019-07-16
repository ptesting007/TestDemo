//
//  TDAccountManager.h
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TDError.h"
#import "TDConfiguration.h"

@interface TDAccountManager : NSObject

+ (TDAccountManager *)sharedManager;

- (void)loginWithParameters:(NSDictionary *)params withCompletionHandler:(void (^) (NSDictionary *responseDict, TDError *error))completionBlock;
- (void)getUserListWithParameters:(NSDictionary *)params withCompletionHandler:(void (^)(NSDictionary *responseDict, TDError *error))completionBlock;
@end
