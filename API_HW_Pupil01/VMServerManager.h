//
//  VMServerManager.h
//  API_HW_Pupil01
//
//  Created by Torris on 6/16/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VMUser.h"


@interface VMServerManager : NSObject



+ (VMServerManager*) sharedManager;


- (void) showAllertOnController:(UIViewController*) controller
                     withTittle:(NSString*) title
                     andMessage:(NSString*) message;



 - (void) authorizeUser:(void(^)(NSNumber* userID)) completion;


- (void) getUserFromServerWithId:(NSNumber*)identificator
                              onSuccess:(void(^)(VMUser* user)) success
                                onError:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFriendsFromServerWithUserId:(NSNumber*) identificator
                                 offset:(NSInteger)offset
                                  count:(NSInteger)count
                              onSuccess:(void(^)(NSArray* friends)) success
                                onError:(void(^)(NSError* error, NSInteger code)) failure;

- (void) getFollowersFromServerWithUserId:(NSNumber*) identificator
                                   offset: (NSInteger)offset
                                    count:(NSInteger)count
                                onSuccess:(void(^)(NSArray* followers)) success
                                  onError:(void(^)(NSError* error, NSInteger code)) failure;

- (void) getSubscriptionsFromServerWithUserId:(NSNumber*) identificator
                                    onSuccess:(void(^)(NSArray* array)) success
                                      onError:(void(^)(NSError* error, NSInteger code)) failure;


- (void) getUserWall:(NSNumber*) identificator
          withOffset:(NSInteger) offset
               count:(NSInteger) count
           onSuccess:(void(^)(NSArray* posts)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



- (void) getCityFromServerWithId:(NSNumber*)identificator
                       onSuccess:(void(^)(NSString* cityName)) success
                         onError:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCountryFromServerWithId:(NSNumber*)identificator
                       onSuccess:(void(^)(NSString* countryName)) success
                         onError:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end
