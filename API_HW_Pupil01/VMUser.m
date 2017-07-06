//
//  VMUser.m
//  API_HW_Pupil01
//
//  Created by Torris on 6/16/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

#import "VMUser.h"
#import "VMServerManager.h"


@implementation VMUser

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        
        
        NSNumber* genderVal = [responseObject objectForKey:@"sex"];
        
        NSInteger genderInt = [genderVal integerValue];
        
        if (genderInt == 1) {
            self.gender = @"female";
        
        } else if (genderInt == 2) {
            
            self.gender = @"male";
        }
        
        
        self.bdate = [responseObject objectForKey:@"bdate"];
        
        
        __weak VMUser* weakSelf = self;
 
        NSNumber* cityId = [responseObject objectForKey:@"city"];
        
        [[VMServerManager sharedManager] getCityFromServerWithId:cityId
                                                       onSuccess:^(NSString* cityName) {
                                                           
                                                           weakSelf.city = cityName;
                                                           
                                                       } onError:^(NSError *error, NSInteger statusCode) {
                                                           
                                                           NSLog(@"error: %@, status code: %ld", [error localizedDescription], statusCode);

                                                           
                                                       }];
  
  
        NSNumber* countryId = [responseObject objectForKey:@"country"];
        
        [[VMServerManager sharedManager] getCountryFromServerWithId:countryId
                                                       onSuccess:^(NSString* countryName) {
                                                           
                                                           weakSelf.country = countryName;
                                                           
                                                       } onError:^(NSError *error, NSInteger statusCode) {
                                                           
                                                           NSLog(@"error: %@, status code: %ld", [error localizedDescription], statusCode);
                                                           
                                                           
                                                       }];
        
        
        
    }
    return self;
}


- (void) assignPhotoFromResponse:(NSDictionary*) responseObject {
    
    NSString* imageURLString = [responseObject objectForKey:@"photo_max"];
    
    self.imageURL = [NSURL URLWithString:imageURLString];
    
    
}



@end
