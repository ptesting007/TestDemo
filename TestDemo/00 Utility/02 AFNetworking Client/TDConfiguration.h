//
//  TDConfiguration.h
//  TestDemo
//
//  Created by Piyush Kaklotar on 16/07/19.
//  Copyright © 2019 Piyush Kaklotar. All rights reserved.
//

#ifndef TDConfiguration_h
#define TDConfiguration_h


#if DEBUG
#define BASE_URL                @"https://reqres.in/"
#else
#define BASE_URL                @"https://reqres.in/"
#endif



#define LOGIN_USER         @"api/login"
#define LIST_USER          @"api/users?page={value}"
#define UPDATE_USER        @"api/users/2"

//Login Keys
#define kEmailKey           @"email"
#define kPasswordKey        @"password"
#define kAuthTokenKey       @"token"

//Update User
#define kNameTitle          @"name"
#define kJobTitle           @"job"


//Global keys
#define kStatusKey       @"status"
#define kErrorKey        @"error"
#define kDataKey         @"data"
#define kErrorCodeKey    @"code"
#define kErrorMessageKey @"message"
#define kApiKey          @"apikey"


//Notification keys
#define kNotificationUserLoginSuccessful @"NotificationUserLoginSuccessful"
#define kNotificationAddWineSuccessful @"NotificationAddWineSuccessful"
#define kNotificationAddBottleSuccessful @"NotificationAddBotteSuccessful"


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


#endif /* TDConfiguration_h */
