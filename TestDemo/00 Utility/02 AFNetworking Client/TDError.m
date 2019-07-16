//
//  TDError.m
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#import "TDError.h"
#import "TDConfiguration.h"

@implementation TDError

+ (id)validateResponseObject:(id)responseObject
{
    id object = nil;
    TDError *error = [[TDError alloc] init];
    error.isBlockingError = NO;
    if ([responseObject isKindOfClass:[NSNull class]] || !responseObject)
    {
        error.isBlockingError = YES;
        error.messageText = NSLocalizedString(@"no_results_error", @"");
        object = error;
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        object = [[self alloc] initWithDataDict:responseObject];
    }
    
    return object;
}

- (id)initWithError:(NSError *)error
{
    self = [super init];
    
    if (self) {
        self.error = error;
        self.isBlockingError = YES;
        
        if(error.code == kCFURLErrorTimedOut)
        {
            self.messageText = @"We are unable to connect to the servers right now. We apologize for the inconvenience. Please try again later.";
        }
        else
        {
            self.messageText = error.localizedDescription;
        }
    }
    
    return self;
}

- (id)initWithDataDict:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.code = [dictionary objectForKey:kStatusKey];

        if ([self.code intValue] == 0) {
            NSDictionary *errorDict = [dictionary objectForKey:kErrorKey];
            NSString *errorCode = [errorDict objectForKey:kErrorCodeKey];
            NSString *messageText = [errorDict objectForKey:kErrorMessageKey];
            self.errorCode = errorCode;
            self.messageText = messageText;
            self.isBlockingError = YES;
        }
        else {
            self.isBlockingError = NO;
        }
    }
    
    return self;
}

@end
