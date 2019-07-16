//
//  TDError.h
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface TDError : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL isBlockingError;

+ (id)validateResponseObject:(id)responseObject;
- (id)initWithError:(NSError *)error;
@end
