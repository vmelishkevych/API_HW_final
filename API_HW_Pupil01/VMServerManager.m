//
//  VMServerManager.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/16/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//



#import "VMServerManager.h"
#import "AFNetworking.h"

#import "VMUser.h"
#import "VMFriend.h"
#import "VMFollower.h"
#import "VMSubscriptor.h"
#import "VMCommunity.h"
#import "VMSubscriptionsGroup.h"
#import "VMToken.h"
#import "VMPost.h"

#import "VMLoginViewController.h"
#import "VMUserViewController.h"


@interface VMServerManager ()

@property (strong,nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) VMToken* token;



@end



@implementation VMServerManager

+ (VMServerManager*) sharedManager {
    
    static VMServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VMServerManager alloc] init];
    });

    
    return manager;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString* urlString = @"https://api.vk.com/method/";
        
        NSURL* baseURL = [NSURL URLWithString:urlString];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}



#pragma mark - Help methods

- (void) showAllertOnController:(UIViewController*) controller
                     withTittle:(NSString*) title
                     andMessage:(NSString*) message {
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:action];
    
    
    [controller presentViewController:alert
                       animated:YES
                     completion:nil];
    
    
    
    
}


#pragma mark - API


 - (void) authorizeUser:(void(^)(NSNumber* userID)) completion {
    
    
    VMLoginViewController* vc = [[VMLoginViewController alloc] initWithBlock:^(VMToken *token) {
        
        
        self.token = token;
        
        if (token) {
            
            completion(self.token.userID);
            
        } else if (completion) {
                
                completion(nil);
                
            }
        
        
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    UIViewController* mainVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [mainVC presentViewController:nav animated:YES completion:nil];
    
}




- (void) getUserFromServerWithId:(NSNumber*)identificator
                       onSuccess:(void(^)(VMUser* user)) success
                         onError:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSArray* fields = @[@"photo_max",
                        @"sex",
                        @"bdate",
                        @"country",
                        @"city"];
    
    
    NSDictionary* params = [NSDictionary
                            dictionaryWithObjectsAndKeys:
                            identificator, @"user_ids",
                            fields, @"fields",
                            @"nom", @"name_case", nil];
    
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                         
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         
                         if ([dictsArray count] > 0) {
                             
                             NSDictionary* userDict = [dictsArray firstObject];
                             
                             VMUser* user = [[VMUser alloc] initWithServerResponse:userDict];
                             
                             if (success) {
                                 
                                 success(user);
                                 
                             }
                             
                         } else {
                             
                             if (failure) {
                                 
                                 failure(nil, [(NSHTTPURLResponse*)[task response] statusCode]);
                             }
                             
                         }
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         
                         if (failure) {
                             
                             failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
                         }
                         
                     }];
    
    
    
}


- (void) getFriendsFromServerWithUserId:(NSNumber*) identificator
                                 offset: (NSInteger)offset
                                  count:(NSInteger)count
                              onSuccess:(void(^)(NSArray* friends)) success
                                onError:(void(^)(NSError* error, NSInteger code)) failure {
    
    
    NSDictionary* params = [NSDictionary
                            dictionaryWithObjectsAndKeys:
                            identificator, @"user_id",
                            @"name", @"order",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"photo_50", @"fields",
                            @"nom", @"name_case", nil];
    
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         for (NSDictionary* dict in dictsArray) {
                             
                             VMFriend* friend = [[VMFriend alloc] initWithServerResponse:dict];
                             
                             [objectsArray addObject:friend];
                         }
                         
                         if (success) {
                             
                             success(objectsArray);
                             
                         }
                         
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             
                             failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
                         }
                         
                     }];
    
    
    
}

- (void) getFollowersFromServerWithUserId:(NSNumber*) identificator
                                   offset: (NSInteger)offset
                                    count:(NSInteger)count
                                onSuccess:(void(^)(NSArray* followers)) success
                                  onError:(void(^)(NSError* error, NSInteger code)) failure {
    
    
    NSDictionary* params = [NSDictionary
                            dictionaryWithObjectsAndKeys:
                            identificator, @"user_id",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"photo_50", @"fields",
                            @"nom", @"name_case", nil];
    
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                         
                        
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         NSArray* dictsArray = [responseObject valueForKeyPath:@"response.items"];
                         
                         for (NSDictionary* dict in dictsArray) {
                             
                             VMFollower* follower = [[VMFollower alloc] initWithServerResponse:dict];
                             
                             [objectsArray addObject:follower];
                         }
                         
                         if (success) {
                             
                             success(objectsArray);
                             
                         }
                         
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             
                             failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
                         }
                         
                     }];
    
    
    
}



- (void) getSubscriptionsFromServerWithUserId:(NSNumber*) identificator
                                    onSuccess:(void(^)(NSArray* array)) success
                                      onError:(void(^)(NSError* error, NSInteger code)) failure {
    
    
    NSDictionary* params = [NSDictionary
                            dictionaryWithObjectsAndKeys:
                            identificator, @"user_id",
                            @"photo_50", @"fields",
                            @"1", @"extended", nil];
    
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                         
                         
                         NSMutableArray* usersArray = [NSMutableArray array];
                         NSMutableArray* groupsArray = [NSMutableArray array];
                         
                         
                         NSArray* dictsArray = [responseObject valueForKeyPath:@"response"];
                         
                         for (NSDictionary* dict in dictsArray) {
                             
                             if ([[dict valueForKey:@"type"] isEqualToString:@"profile"]) {
                                 
                                 VMSubscriptor* subscriptor = [[VMSubscriptor alloc] initWithServerResponse:dict];
                                 
                                 [usersArray addObject:subscriptor];
                                 
                             } else {
                                 
                                 VMCommunity* community = [[VMCommunity alloc] initWithServerResponse:dict];
                                 
                                 [groupsArray addObject:community];
                                 
                             }
                             
                         }
                         
                         VMSubscriptionsGroup* communitiesSubscription = [[VMSubscriptionsGroup alloc] init];
                         
                         communitiesSubscription.subscriptionsName = @"Communities";
                         communitiesSubscription.subscriptionsArray = groupsArray;
                         
                         
                         VMSubscriptionsGroup* usersSubscription = [[VMSubscriptionsGroup alloc] init];
                         
                         usersSubscription.subscriptionsName = @"Users";
                         usersSubscription.subscriptionsArray = usersArray;
                         
                         NSArray* objectsArray = @[communitiesSubscription, usersSubscription];
                         
                         
                         
                         if (success) {
                             
                             success(objectsArray);
                             
                         }
                         
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             
                             failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
                         }
                         
                     }];
    
    
    
}


- (void) getCountryFromServerWithId:(NSNumber*)identificator
                       onSuccess:(void(^)(NSString* countryName)) success
                         onError:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary
                            dictionaryWithObjectsAndKeys:
                            identificator, @"country_ids", nil];
    
    
    [self.sessionManager GET:@"database.getCountriesById"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                        
                         NSArray* countriesArray = [responseObject objectForKey:@"response"];
                         
                         NSDictionary* countryDict = [countriesArray firstObject];
                         
                         NSString* countryName = [countryDict objectForKey:@"name"];
                         
                         if (success) {
                             
                             success(countryName);
                             
                         }
                         
                         
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         
                         if (failure) {
                             
                             failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
                         }
                         
                     }];
    
    
    
}




- (void) getCityFromServerWithId:(NSNumber*)identificator
                       onSuccess:(void(^)(NSString* cityName)) success
                         onError:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = [NSDictionary
                            dictionaryWithObjectsAndKeys:
                            identificator, @"city_ids", nil];
    
    
    [self.sessionManager GET:@"database.getCitiesById"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
                         
                         NSArray* citiesArray = [responseObject objectForKey:@"response"];
                         
                         NSDictionary* cityDict = [citiesArray firstObject];
                         
                         NSString* cityName = [cityDict objectForKey:@"name"];
                         
                         if (success) {
                             
                             success(cityName);
                             
                         }
                         
                         
                     }
     
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         
                         if (failure) {
                             
                             failure(error, [(NSHTTPURLResponse*)task.response statusCode]);
                         }
                         
                     }];
    
    
    
}

- (void) getUserWall:(NSNumber*) identificator
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* posts)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     identificator,             @"owner_id",
     @(count),                  @"count",
     @(offset),                 @"offset",
     @"all",                    @"filter",
     self.token.tokenString,    @"access_token", nil];
    
    
    
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionTask *task, NSDictionary* responseObject) {
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         if (dictsArray.count > 1) {
                             
                             dictsArray = [dictsArray subarrayWithRange:NSMakeRange(1, (int)dictsArray.count - 1)];
                             
                         } else {
                             
                             dictsArray = nil;
                             
                         }
                         
                         
                         
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             
                             VMPost* post = [[VMPost alloc] initWithServerResponse:dict];
                             
                             [objectsArray addObject:post];
                             
                         }
                         
                         
                         if (success) {
                             
                             success(objectsArray);
                             
                         }
                         
                         
                         
                     } failure:^(NSURLSessionTask *task, NSError *error) {
                         
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             
                             failure (error, [(NSHTTPURLResponse*)[task response] statusCode]);
                         }
                         
                     }];
    
}



@end
